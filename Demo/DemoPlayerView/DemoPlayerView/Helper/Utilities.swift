//
//  Utilities.swift
//  DemoPlayerView
//
//  Created by Thien on 4/25/20.
//  Copyright © 2020 Thien Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum DeviceOrientation {
    case portrait
    case landscape
}

class Utilities {

    private struct UtilsConstant {
        static let countTimeFormat = "%02d:%02d"
        static let countTimeFormatWithHour = "%02d:%02d:%02d"
        static let secondsPerHour = 3600
        static let secondsPerMinute = 60
        static let milisecondsPerSecond = 1000
    }

    static func getDeviceOrientation(screenSize: CGSize = UIScreen.main.bounds.size) -> DeviceOrientation {
        return screenSize.width < screenSize.height ? .portrait : .landscape
    }

    static func formatDurationTime(time: Int) -> String {
        var tmpTime = time
        let hours = tmpTime / UtilsConstant.secondsPerHour
        tmpTime -= hours * UtilsConstant.secondsPerHour
        let minutes = tmpTime / UtilsConstant.secondsPerMinute
        tmpTime -= minutes * UtilsConstant.secondsPerMinute
        let seconds = tmpTime
        if hours <= 0 {
            return String(format: UtilsConstant.countTimeFormat, minutes, seconds)
        } else {
            return String(format: UtilsConstant.countTimeFormatWithHour, hours, minutes, seconds)
        }
    }
}
