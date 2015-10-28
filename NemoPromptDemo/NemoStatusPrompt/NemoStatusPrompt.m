//
//  NemoStatusTint.m
//  NemoPromptDemo
//
//  Created by Nemo on 15/10/27.
//  Copyright © 2015年 Nemo. All rights reserved.
//

#import "NemoStatusPrompt.h"

#define STATUS_SIZE CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)
#define CUSTOM_TAG 4UL<<4

#define TITLE_EDGE_INSET UIEdgeInsetsMake(12, 8, 12, 8)

#define F_COLOR [UIColor colorWithRed:205./255.0f green:4./255.0f blue:0./255.0f alpha:1.]
#define S_COLOR [UIColor colorWithRed:93./255.0f green:200./255.0f blue:0./255.0f alpha:1.]
#define W_COLOR [UIColor colorWithRed:241./255.0f green:224./255.0f blue:0./255.0f alpha:1.]
#define T_COLOR [UIColor whiteColor]

static UIView *_statusBackgroundView = nil;
static UILabel *_titleLabel = nil;
static UIImageView *_promptImageView = nil;
static BOOL _isShow = NO;
static NSTimeInterval _hideTime = 1.5;
static BOOL _userInteractionEnabled = YES;

static NemoStatusPrompt *__Singleton__Prompt__ = nil;

@implementation NemoStatusPrompt

+ (void)initialize
{
    if (self == [NemoStatusPrompt class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //类无法使用NSObject的perform系列方法，生成一个静态实例变量来执行延迟隐藏方法
            //使用disptach_after无法取消执行，NSRunLoop添加的方法也无法取消，所以只能生成一个静态实例变量来实现
            __Singleton__Prompt__ = [NemoStatusPrompt new];
        });
        _statusBackgroundView = UIView.new;
        _statusBackgroundView.frame = CGRectMake(0, -STATUS_SIZE.height, STATUS_SIZE.width, STATUS_SIZE.height);
        _statusBackgroundView.backgroundColor = [UIColor greenColor];
        _statusBackgroundView.hidden = YES;
        _statusBackgroundView.clipsToBounds = YES;
        
        _titleLabel = UILabel.new;
        _titleLabel.textColor = T_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        [_statusBackgroundView addSubview:_titleLabel];
        
        _promptImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 30 , 30)];
        _promptImageView.backgroundColor = [UIColor clearColor];
        [_statusBackgroundView addSubview:_promptImageView];
        
    }
}

+ (void)showImage:(UIImage *)image
            title:(NSString *)title
       titleColor:(UIColor *)tColor
  backgroundColor:(UIColor *)bColor
       completion:(void(^)(BOOL))completion{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isShow]) {
            [self hide];
        }
        _isShow = YES;
        _titleLabel.hidden = NO;
        _promptImageView.hidden = NO;
        
        _promptImageView.image = image;
        
        _titleLabel.text = title;
        _titleLabel.textColor = tColor ? tColor : T_COLOR;
        
        CGFloat labelLeft = image ? _promptImageView.frame.origin.x + _promptImageView.frame.size.width + TITLE_EDGE_INSET.left: TITLE_EDGE_INSET.left;
        _titleLabel.textAlignment = image ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        
        
        CGSize fitSize = CGSizeMake(STATUS_SIZE.width - TITLE_EDGE_INSET.right - labelLeft, STATUS_SIZE.height - TITLE_EDGE_INSET.top - TITLE_EDGE_INSET.bottom);
        CGSize fitedSize = [_titleLabel sizeThatFits:fitSize];
        fitedSize.height = fitedSize.height > fitSize.height ? fitSize.height : fitedSize.height;
        
        _titleLabel.frame = CGRectMake(labelLeft, (STATUS_SIZE.height - fitSize.height)/2., fitSize.width, fitSize.height);
        _statusBackgroundView.backgroundColor = bColor ? bColor : S_COLOR;
        
        _statusBackgroundView.hidden = NO;
        [self show:YES completion:completion];
    });

}

+ (void)showSuccess:(UIImage *)successImage title:(NSString *)title completion:(void(^)(BOOL finished))completion{
    [self showImage:successImage title:title titleColor:T_COLOR backgroundColor:S_COLOR completion:completion];
}
+ (void)showFailed:(UIImage *)failedImaage title:(NSString *)title completion:(void(^)(BOOL finished))completion{
    [self showImage:failedImaage title:title titleColor:T_COLOR backgroundColor:F_COLOR completion:completion];

}
+ (void)showWaring:(UIImage *)waringImage title:(NSString *)title completion:(void(^)(BOOL finished))completion{
    [self showImage:waringImage title:title titleColor:T_COLOR backgroundColor:W_COLOR completion:completion];

}
+ (void)showCustomView:(UIView *)customView completion:(void(^)(BOOL finished))completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self isShow]) {
            [self hide];
        }
        _isShow = YES;
        _titleLabel.hidden = YES;
        _promptImageView.hidden = YES;
        [_statusBackgroundView addSubview:customView];
        customView.tag = CUSTOM_TAG;
        _statusBackgroundView.backgroundColor = [UIColor clearColor];
        _statusBackgroundView.hidden = NO;
        

        [self show:YES completion:completion];
    });
  
}

#pragma mark - configure
+ (void)userInteractionEnabledDuringAnimation:(BOOL)enable{
    _userInteractionEnabled = enable;
}
+ (void)setAutoHideTime:(NSTimeInterval)time{

    _hideTime = time;
}
+ (void)setTitleFont:(UIFont *)font{
    _titleLabel.font = font;
}

#pragma mark - status
+ (BOOL)isShow{
    return _isShow;
}
+(CGSize)statusPromptSize{
    return STATUS_SIZE;
}
#pragma mark - private method

+ (void)show:(BOOL)animation completion:(void(^)(BOOL finished))completion{
    
    if (!_statusBackgroundView.superview) {
        [[self getKeyWindow] addSubview:_statusBackgroundView];
        [[self getKeyWindow] bringSubviewToFront:_statusBackgroundView];
    }
    //开始动画前，取消之前可能添加到runloop中的隐藏动画
//    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHide:) object:nil];
    [NemoStatusPrompt cancelPreviousPerformRequestsWithTarget:__Singleton__Prompt__ selector:@selector(delayHide) object:nil];

    if (!_userInteractionEnabled) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }else{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    }
    [[self getKeyWindow] setWindowLevel:UIWindowLevelStatusBar + 1];
    if (animation) {
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                                _statusBackgroundView.frame = CGRectMake(0, 0, STATUS_SIZE.width, STATUS_SIZE.height);
                            }
                         completion:^(BOOL finished) {
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];

                             if (completion) {
                                 completion(finished);
                             }
                             //order runloop中的优先级 -2147483647优先级最高，autoreleasepool push使用该优先级
                             //2147483647优先级最低，autoreleasepool pop使用该优先级，这里使用中间的优先级
//                             [[NSRunLoop currentRunLoop] performSelector:@selector(delayHide:)
//                                                                  target:self
//                                                                argument:@(_hideTime)
//                                                                   order:0
//                                                                   modes:@[NSRunLoopCommonModes]];
                             [__Singleton__Prompt__ performSelector:@selector(delayHide) withObject:nil afterDelay:_hideTime];


                         }];

    }else{

//        [[NSRunLoop currentRunLoop] performSelector:@selector(delayHide:)
//                                             target:self
//                                           argument:@(_hideTime)
//                                              order:0
//                                              modes:@[NSRunLoopCommonModes]];
        [__Singleton__Prompt__ performSelector:@selector(delayHide) withObject:nil afterDelay:_hideTime];

        _statusBackgroundView.frame = CGRectMake(0, 0, STATUS_SIZE.width, STATUS_SIZE.height);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        if (completion) {
            completion(YES);
        }
    }
 
}
+ (void)hide:(BOOL)animation completion:(void(^)(BOOL finished))completion{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (animation) {
            [UIView animateWithDuration:1.0
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    _statusBackgroundView.frame = CGRectMake(0, -STATUS_SIZE.height, STATUS_SIZE.width, STATUS_SIZE.height);
                                }
                             completion:^(BOOL finished) {
                                 [self hide];
                                 if (completion) {
                                     completion(finished);
                                 }

                             }];
        }else{
            [self hide];
            if (completion) {
                completion(YES);
            }
        }
    });

}

+ (void)hide{
    
    
    _statusBackgroundView.frame = CGRectMake(0, -STATUS_SIZE.height, STATUS_SIZE.width, STATUS_SIZE.height);
    _statusBackgroundView.hidden = YES;
    _titleLabel.hidden = NO;
    _promptImageView.hidden = NO;
    _isShow = NO;
    [[self getKeyWindow] setWindowLevel:UIWindowLevelNormal];

    for (UIView *view in _statusBackgroundView.subviews) {
        if (view.tag == CUSTOM_TAG) {
            [view removeFromSuperview];
        }
    }

}
- (void)delayHide{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [[NemoStatusPrompt getKeyWindow] setWindowLevel:UIWindowLevelNormal];
        [UIView animateWithDuration:1.0
                              delay:0.
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                _statusBackgroundView.frame = CGRectMake(0, -STATUS_SIZE.height, STATUS_SIZE.width, STATUS_SIZE.height);
                            }
                         completion:^(BOOL finished) {

                         }];
    });
    
}

+ (UIWindow *)getKeyWindow{
    return [UIApplication sharedApplication].keyWindow;
}

@end
