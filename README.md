# IOSPLayerView
Just use AVFoundation and UIKit (programmatically, no storyboard), SwiftLint (A tool to enforce Swift style and conventions).

## 📝 Table of Contents
+ [About](#about)
+ [Getting Started](#getting_started)
+ [Usage](#usage)
+ [Final Demo](#final_demo)
+ [Built Using](#usage)
+ [Author](#author)

## 🧐 About <a name = "about"></a>
- Learn about AVFoundation and UIKit framework. All view was created programmatically (with code and no storyboard).
- Autolayout with code (no Interface Builder)
- Custom UI (UIView)
- GitFlow.
- SwiftLint (A tool to enforce Swift style and conventions).
- Use Delegation Pattern

## 🏁 Getting Started <a name = "getting_started"></a>
Clone this repo and copy my AVPlayerView.swift into your project!

## 🎈 Usage <a name = "usage"></a>
With code programmatically:

```
let videoView = AVPlayerView()
let heightConstant: CGFloat = UIScreen.main.bounds.width * 9 / 16
// and use autolayout to this view (detail in demo example).
...
layer.frame = videoView.bounds
videoView.layer.insertSublayer(layer, at: 0)
videoView.playerLayer = layer
```

Or in storyboard (drag out a UIView in your storyboard and choose Custom Class > Class is AVPlayerView):

![Usage in storyboard](https://github.com/NguyenQuyThien/IOSPLayerView/blob/master/demo%20and%20screenshot/usage%20in%20storyboard.png)

Note: you should have a PlayerManager class. 
      And you have to check the slider is being touched befor update slider with KVO.

```
guard videoView.slider.isTracking == false else { return }
```

## 🎉 Final Demo <a name = "final_demo"></a>
![Demo Iphone 8](https://github.com/NguyenQuyThien/IOSPLayerView/blob/master/demo%20and%20screenshot/demoIphone8.gif)
![Demo Iphone 11](https://github.com/NguyenQuyThien/IOSPLayerView/blob/master/demo%20and%20screenshot/demoIphone11.gif)
![View Hierarchy](https://github.com/NguyenQuyThien/IOSPLayerView/blob/master/demo%20and%20screenshot/View%20Hierarchy.png)

## ⛏️ Built Using <a name = "built_using"></a>
- [AVFoundation and UIKit](https://developer.apple.com/documentation/) - Apple Developer Documentation.
- [SwiftLint](https://realm.github.io/SwiftLint) - A tool to enforce Swift style and conventions.

## ✍️ Author <a name = "author"></a>
- [@NguyenQuyThien](https://github.com/NguyenQuyThien) - Github link.
- [Email](dev.thien@gmail.com) - My email is dev.thien@gmail.com.
