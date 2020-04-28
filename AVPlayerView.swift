//
//  AVPlayerView.swift
//  DemoPlayerView
//
//  Created by Thien on 4/25/20.
//  Copyright © 2020 Thien Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView {
    var playerLayer: CALayer?
    /// func này chạy khi view's bounds thay đổi
    /// giúp set lại frame cho layer
    /// - Parameter layer: truyền thuộc tính AVPlayerLayer vào
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }

    var videoControlIsHiden: Bool = false
    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(gesture)
        return view
    }()
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        if videoControlIsHiden {
            pausePlayButton.isHidden = false
            bottomControlContainer.isHidden = false
        } else {
            pausePlayButton.isHidden = true
            bottomControlContainer.isHidden = true
        }
        videoControlIsHiden.toggle()
    }

    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    let bottomControlContainer: UIStackView = {
        let bottomControlContainer = UIStackView()
        bottomControlContainer.axis = .horizontal
        bottomControlContainer.spacing = 8
        bottomControlContainer.alignment = .center
        return bottomControlContainer
    }()
    let currentTime: UILabel = {
        let currentTime = UILabel()
        currentTime.text = "00:00"
        currentTime.textColor = .white
        currentTime.font = UIFont.boldSystemFont(ofSize: 18)
        return currentTime
    }()
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "sliderThumb")?.withTintColor(.red), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    let totalTime: UILabel = {
        let slider = UILabel()
        slider.text = "00:00"
        slider.textColor = .white
        slider.font = UIFont.boldSystemFont(ofSize: 18)
        return slider
    }()

    private func setupUI() {
        self.addSubview(view)
        view.addSubview(bottomControlContainer)
        view.addSubview(pausePlayButton)
        bottomControlContainer.addArrangedSubview(currentTime)
        bottomControlContainer.addArrangedSubview(slider)
        bottomControlContainer.addArrangedSubview(totalTime)

        view.translatesAutoresizingMaskIntoConstraints = false
        bottomControlContainer.translatesAutoresizingMaskIntoConstraints = false
        pausePlayButton.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

            bottomControlContainer.heightAnchor.constraint(equalToConstant: 30),
            bottomControlContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomControlContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            bottomControlContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),

            pausePlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pausePlayButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
        backgroundColor = .black
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    @objc func handlePause() {
//        check isPlaying and set again image of pausePlayButton
    }

    @objc func handleSliderChange() {
        if let duration = PlayerManager.shared.avPlayer?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(slider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
//            your AVPlayer: avPlayer.seek(to: seekTime, completionHandler: { (_) in
//                perhaps do something later here
//            })
        }
    }

}
