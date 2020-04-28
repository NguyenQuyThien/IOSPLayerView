//
//  ViewController.swift
//  DemoPlayerView
//
//  Created by Thien on 4/21/20.
//  Copyright © 2020 Thien Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let videoView = AVPlayerView()
    let heightConstant: CGFloat = UIScreen.main.bounds.width * 9 / 16
    var heightOfVideoView: NSLayoutConstraint!
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let stackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    let greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupViewConstraints()
        
        guard let path =
            Bundle.main.path(
                forResource: "ben-trong-nha-ga-ngam-dau-tien-sap-hoan-thanh-1587975303",
                ofType: "mp4") else {
                    return
        }
        let videoUrl = URL(fileURLWithPath: path)
        
        PlayerManager.shared.playlistUrls = [videoUrl]
        PlayerManager.shared.delegate = self
        let isPlaying = PlayerManager.shared.avPlayer != nil
        isPlaying ? PlayerManager.shared.continueAVPlayer(forController: self) :
            PlayerManager.shared.configAVPlayer(forController: self)
    }
    
    func setupViewConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(videoView)
        stackViewContainer.addArrangedSubview(redView)
        stackViewContainer.addArrangedSubview(blueView)
        stackViewContainer.addArrangedSubview(greenView)
        
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        
        let safeArea = view.safeAreaLayoutGuide
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        heightOfVideoView = videoView.heightAnchor.constraint(equalToConstant: heightConstant)
        NSLayoutConstraint.activate([
            //=== View's constraint===
            heightOfVideoView,
            
            redView.heightAnchor.constraint(equalToConstant: 100),
            blueView.heightAnchor.constraint(equalToConstant: 200),
            greenView.heightAnchor.constraint(equalToConstant: 300),
            //===
            
            //=== Constraint to scrollable (content's height must be fixed) ===
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // this is important for scrolling
            stackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            //===
        ])
        
    }
    
    // viewWillTransition & viewWillAppear phải check orientation thì videoview mới OK
    fileprivate func changeHeightOfVideoView(size: CGSize) {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            heightOfVideoView.constant = size.height
            redView.isHidden = true
            blueView.isHidden = true
            greenView.isHidden = true
        case .portrait, .portraitUpsideDown:
            heightOfVideoView.constant = heightConstant
            redView.isHidden = false
            blueView.isHidden = false
            greenView.isHidden = false
        default: break
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        changeHeightOfVideoView(size: size)
    }
    override func viewWillAppear(_ animated: Bool) {
        let size = UIScreen.main.bounds.size
        changeHeightOfVideoView(size: size)
    }
    
    // MARK: KVO Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            var status: AVPlayerItem.Status = .unknown
            if let statusNumber = change?[.newKey] as? NSNumber,
                let newStatus = AVPlayerItem.Status(rawValue: statusNumber.intValue) {
                status = newStatus
            }
            switch status {
            case .readyToPlay:
                // time to play
                PlayerManager.shared.currentTrack?.state = .readyToPlay
                videoView.pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
                PlayerManager.shared.play()
            default:
                break
            }
        } else if keyPath == Constant.loadTimeRangedKey {
            // update buffer display
            //            onLoadedTimeRangedChanged()
        }
    }
}

extension ViewController: PlayerManagerDelegate {
    func onConfigAVPlayerTrigger(layer: AVPlayerLayer?) {
        guard let layer = layer else { return }
        
        layer.frame = videoView.bounds
        videoView.layer.insertSublayer(layer, at: 0)
        videoView.playerLayer = layer
        
        PlayerManager.shared.play()
    }
    
    func onTimeObserverTrigger(currentTime: Double, duration: Double) {
        guard let currentTrack = PlayerManager.shared.currentTrack else { return }
        // check the slider is being touched. (ko touch mới update)
        // nếu ko có dòng này slider bị lag:
        //   https://stackoverflow.com/questions/55059162/uislider-jumps-when-updating-for-avplayer)
        guard videoView.slider.isTracking == false else { return }
        
        if currentTrack.state != .seeking {
            videoView.slider.setValue(Float(currentTime / Double(duration)), animated: true)
        }
        if Float(currentTime / Double(duration)) >= 1 {
            PlayerManager.shared.currentTrack?.state = .playedToTheEnd
            videoView.pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        }
        
        // set time label
        videoView.currentTime.text = Utilities.formatDurationTime(time: Int(currentTime))
        videoView.totalTime.text = Utilities.formatDurationTime(time: Int(duration))
    }
}
