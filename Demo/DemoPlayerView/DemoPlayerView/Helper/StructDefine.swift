//
//  StructDefine.swift
//  DemoPlayerView
//
//  Created by Thien on 4/25/20.
//  Copyright © 2020 Thien Nguyen. All rights reserved.
//

import AVFoundation

struct Track {
    var playerItem: AVPlayerItem
    var index: Int
    var state: TrackState

    init(url: URL, index: Int) {
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        playerItem = item
        self.index = index
        self.state = .loading
    }
}

struct Constant {
    static let loadTimeRangedKey = "loadedTimeRanges"
}
