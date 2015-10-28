# NemoPromptDemo
######对于需要用户等待的场景，比较广泛采用的是MBProgressHUD，但是使用MBProgressHUD会造成打断用户操作，使用顶部出现提示的动画，对某些场景下用户的体验会更好。该控件只进行了最基础的设计，可以很容易在上面进行各种扩展，包括新增功能。

######1.该控件是单例，用于在屏幕顶部显示一个固定大小的简单提示界面，一定时间后自动隐藏，自动隐藏时间可以设置。
######2.Prompt具体大小可以用 + (CGSize)statusPromptSize方法获取，现在大小刚好遮住导航栏，不排除苹果以后可能修改导航栏大小，如果以后出现这种情况，Prompt的大小也可能会发生变化。所以使用+ (CGSize)statusPromptSize 方法获取大小。
######3.线程安全，可以在任意线程调用，任何地方使用类方法调用，最终都会在主线程执行界面更新。
######4.重复调用show系列方法，会先立刻隐藏当前内容，再重新显示。


![NemoStatusPrompt](https://raw.githubusercontent.com/NemoAir/IMAGES/master/NemoStatusPrompt.gif)

##使用方法 直接将NemoStatusPrompt 拖入使用

用这三个快捷方法，可以直接显示成功、失败、警告的提示
```Objective-C
+ (void)showSuccess:(UIImage *)successImage title:(NSString *)title completion:(void(^)(BOOL finished))completion;
+ (void)showFailed:(UIImage *)failedImaage title:(NSString *)title completion:(void(^)(BOOL finished))completion;
+ (void)showWaring:(UIImage *)waringImage title:(NSString *)title completion:(void(^)(BOOL finished))completion;
```

这个方法可以最大程度定制要显示的样式
```Objective-C
+ (void)showImage:(UIImage *)image
            title:(NSString *)title
       titleColor:(UIColor *)tColor
  backgroundColor:(UIColor *)bColor
       completion:(void(^)(BOOL finished))completion;
 ```

如果你想要显示自定义的view可以使用下面的方法
```Objective-C
+ (void)showCustomView:(UIView *)customView completion:(void(^)(BOOL finished))completion;
```
