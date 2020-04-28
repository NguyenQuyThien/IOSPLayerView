//
//  AVPlayerExt.swift
//  DemoPlayerView
//
//  Created by Thien on 4/25/20.
//  Copyright © 2020 Thien Nguyen. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
