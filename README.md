

[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 14.2+](https://img.shields.io/badge/Xcode-14.2%2B-blue.svg)
![iOS 13.0+](https://img.shields.io/badge/iOS-14.0%2B-blue.svg)
![SwiftUI 3.0+](https://img.shields.io/badge/SwiftUI-3.0%2B-orange.svg)

This Package is related to [Gitee](https://gitee.com/zjinhu/HUD). If you feel that the introduction of Github addresses in SPM is slow, you can use Gitee.

HUD is a Loading pop-up tool developed based on SwiftUI, style reference [ProgressHUD](https://github.com/relatedcode/ProgressHUD) and [PopupView](https://github.com/Mijick/PopupView).

The current functions include Loading, Progress, Success, Fail, and PopupView, which support custom styles inherited from protocols and pop-up animations.

Support dark mode

| ![](Image/top.png)     | ![](Image/bottom.png)   | ![](Image/center.png)   |                         |                          |
| ---------------------- | ----------------------- | ----------------------- | ----------------------- | ------------------------ |
| ![](Image/loading.png) | ![](Image/loading2.png) | ![](Image/loading3.png) | ![](Image/progress.png) | ![](Image/progress2.png) |
| ![](Image/succ.png)    | ![](Image/succ2.png)    | ![](Image/fail.png)     | ![](Image/fail2.png)    |                          |



## Usage

Add it on the page that needs to use Loading or pop-up window (only cover the current page, if you need to cover TabView or NavigationView, please add it directly on the root View, such as ContentView())

```Swift
.addHUD()
```
Various built-in pop-up windows

```swift

    @State var loading = LoadingView(text: .constant(nil))

    @State var loadingText = LoadingView(text: .constant("loading...")）

    @State var fail = FailView(text: .constant(nil))
    @State var succ = SuccessView(text: .constant(""))

```

Text and Progress need to bind external parameters, so they can be used like this

```swift
    @State var progress: CGFloat = 0
    @State var progressView: StepView?

    @State var loadingText: String?
    @State var loading: LoadingView?

    //bind in place
    .onAppear {
        progressView = StepView(progress: $progress)
        loading = LoadingView(text: $loadingText)
    }
    //Modify the current progress or loadingText and then it can change automatically

```

The rest only needs to be in the trigger position

```swift
   Button {
       loading.showHUD()
   } label: {
       Text("Loading Short Text")
   }
```

or according to state control

```swift
  .onChange(of: revenueCat.isPurchasing) { newValue in
       if newValue{
            loading.showHUD()
       }else{
            loading.hiddenHUD()
       }
   }
```

close HUD

```
.hiddenHUD()
```

There are many custom functions in the adapter

```Swift
    // Do you need a mask
     var needMask: Bool = true
     // popup window background color
     var backgroundColour: Color = .clear
     //The pop-up window ignores the safe area
     var ignoresSafeArea: Bool = false
     //Click outside the area to close the popup window
     var touchOutsideToHidden: Bool = false
     // rounded corner radian
     var cornerRadius: CGFloat = 10
     // Gesture off
     var dragGestureProgressToClose: CGFloat = 1/3
     // Gesture close animation
     var dragGestureAnimation: Animation = .interactiveSpring()
    
     // popup window background shadow color
     var shadowColour: Color = .black.opacity(0.2)
     var shadowRadius: CGFloat = 5
     var shadowOffsetX: CGFloat = 0
     var shadowOffsetY: CGFloat = 0
    
     //The padding from the top, the default is 0, Top Popup will use it
     var topPadding: CGFloat = 0
     //The padding from the bottom, the default is 0, Bottom Popup will use it
     var bottomPadding: CGFloat = 0
     //Bottom PopupView automatically adds the height of the safe area
     var bottomAutoHeight: Bool = false
    
    
     //horizontal padding, the default is 0, most cases will be used by Center Popup
     var horizontalPadding: CGFloat = 0
     //The execution time of pop-up animation in the middle
     var centerAnimationTime: CGFloat = 0.1
     //Center PopupView pop-up animation ratio
     var centerTransitionExitScale: CGFloat = 0.86
     //Center PopupView pop-up animation ratio
     var centerTransitionEntryScale: CGFloat = 1.1
    
    
     // popup animation
     var transitionAnimation: Animation = .spring(response: 0.32, dampingFraction: 1, blendDuration: 0.32)

     //Stack style--exposed position--default 6
     var stackViewsOffset: CGFloat = 6
     //stack style -- scale
     var stackViewsScale: CGFloat = 0.06
     //stack style - rounded corners
     var stackViewsCornerRadius: CGFloat = 10
     //stack style--maximum heap display quantity
     var maxStackCount: Int = 3
    
    
     // Whether to automatically close
     var autoHidden: Bool = false
     //automatic shutdown waiting time
     var autoHiddenTime: TimeInterval = 3
```



Please refer to Demo for the specific use of the code api and detailed effects



## Install

### Swift Package Manager

Starting from Xcode 11, the Swift Package Manager is integrated, which is very convenient to use. HUD also supports integration via Swift Package Manager.

Select `File > Swift Packages > Add Pacakage Dependency` in Xcode's menu bar, and enter in the search bar

`https://github.com/jackiehu/HUD`, you can complete the integration



## More tools to speed up APP development

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMediator&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMediator)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=Toast_SwiftUI&theme=radical&locale=cn)]([jackiehu/Toast_SwiftUI (github.com)](https://github.com/jackiehu/Toast_SwiftUI))

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftLog&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftLog)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMesh&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMesh)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftNotification&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftNotification)

