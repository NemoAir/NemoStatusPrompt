//
//  NemoStatusTint.h
//  NemoPromptDemo
//
//  Created by Nemo on 15/10/27.
//  Copyright © 2015年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NemoStatusPrompt : NSObject
/**
 *  1.该控件是单例，用于在屏幕顶部显示一个固定大小的简单提示界面，一定时间后自动隐藏，时间可以设置。
 *  2.Prompt具体大小可以用 + (CGSize)statusPromptSize 方法获取，现在大小刚好遮住导航栏，不排除苹果以后可能修改导航栏大小，如果以后出现这种情况，
 *    Prompt的大小也可能会发生变化。所以使用+ (CGSize)statusPromptSize 方法获取大小。
 *  3.线程安全，可以在任意线程调用，最终都会在主线程执行界面更新。
 *  4.重复调用show系列方法，会先立刻隐藏当前内容，再重新显示。
 */


/**
*  显示成功Prompt
*
*  @param successImage 成功时显示的图片，传nil不显示，title居中显示
*  @param title        显示的title，白色字体，绿色背景,如果文字过长会被截断，传nil则不会显示
*  @param completion   显示完毕回调
*/

+ (void)showSuccess:(UIImage *)successImage title:(NSString *)title completion:(void(^)(BOOL finished))completion;

/**
 *  显示失败Prompt
 *
 *  @param failedImaage 失败时显示的图片,传nil不显示，title居中显示
 *  @param title        失败显示的Title，白色字体，红色背景,如果文字过长会被截断，传nil则不会显示
 *  @param completion   显示完毕回调
 */
+ (void)showFailed:(UIImage *)failedImaage title:(NSString *)title completion:(void(^)(BOOL finished))completion;

/**
 *  显示警告Prompt
 *
 *  @param waringImage 警告显示的图片，传nil不显示，title居中显示
 *  @param title       警告显示的title，白色字体，黄色背景,如果文字过长会被截断，传nil则不会显示
 *  @param completion  显示完毕回调
 */
+ (void)showWaring:(UIImage *)waringImage title:(NSString *)title completion:(void(^)(BOOL finished))completion;

/**
 *  最详尽的显示内容定义，如果该方法还不能满足需求，应该考虑使用 + (void)showCustomView:(UIView *)customView方法
 *
 *  @param image  显示的时的图片,如果传nil，则不会显示图片，且title居中显示
 *  @param title  显示时的title,如果文字过长会被截断，传nil则不会显示
 *  @param tColor 显示时title的颜色,传nil则会显示白色
 *  @param bColor 显示时Tint的背景颜色,传nil则会显示绿色
 */

+ (void)showImage:(UIImage *)image
            title:(NSString *)title
       titleColor:(UIColor *)tColor
  backgroundColor:(UIColor *)bColor
       completion:(void(^)(BOOL finished))completion;

/**
 *  使用自定义的视图显示，如果需要最大限度的自定义视图显示，使用该方法。
 *  注意：如果自定义视图size大于Tint预定的size会被截取。该控件本来的
 *  的目的只是用来显示提示信息，所以不适合用于显示其他类型的界面信息。
 *
 *  @param customView 想要显示的自定义视图
 */
+ (void)showCustomView:(UIView *)customView completion:(void(^)(BOOL finished))completion;

/**
 *  隐藏Prompt
 *
 *  @param animation  是否使用动画
 */

+ (void)hide:(BOOL)animation completion:(void(^)(BOOL finished))completion;


/**
 *  Tint是否正在显示
 */
+ (BOOL)isShow;

/**
 *  Tint的size，可以用来定制自定义显示的视图使用
 *
 */
+ (CGSize)statusPromptSize;

/**
 *  设置title显示的font,默认是系统14号字体，全局设置
 *
 *  @param font 需要显示的font
 */
+ (void)setTitleFont:(UIFont *)font;

/**
 *  设置显示信息后自动隐藏的时间，默认1.5秒，全局设置
 *
 *  @param time 自动隐藏的时间
 */
+ (void)setAutoHideTime:(NSTimeInterval)time;


@end
