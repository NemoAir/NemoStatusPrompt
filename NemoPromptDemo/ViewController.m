//
//  ViewController.m
//  NemoPromptDemo
//
//  Created by Nemo on 15/10/27.
//  Copyright © 2015年 Nemo. All rights reserved.
//

#import "ViewController.h"
#import "NemoStatusPrompt.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.sucess addTarget:self action:@selector(successMehtod) forControlEvents:UIControlEventTouchUpInside];
    [self.failed addTarget:self action:@selector(failureMehtod) forControlEvents:UIControlEventTouchUpInside];

    [self.waring addTarget:self action:@selector(waringMehtod) forControlEvents:UIControlEventTouchUpInside];

    [self.custom addTarget:self action:@selector(customMehtod) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)successMehtod{

    [NemoStatusPrompt showSuccess:[UIImage imageNamed:@"sucess"] title:@"成功!" completion:^(BOOL finished) {
        
    }];
}
- (void)failureMehtod{
    [NemoStatusPrompt showFailed:[UIImage imageNamed:@"failed"] title:@"失败..." completion:^(BOOL finished) {
        
    }];
}
- (void)waringMehtod{
    [NemoStatusPrompt showWaring:[UIImage imageNamed:@"waring"] title:@"错误!\n错误原因是什么。查出错误原因错误原因是什么。查出错误原因错误原因是什么。查出错误原因" completion:^(BOOL finished) {
        
    }];
}
- (void)customMehtod{
    UILabel *customView= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [NemoStatusPrompt statusPromptSize].width, [NemoStatusPrompt statusPromptSize].height)];
    customView.text = @"custom";
    customView.backgroundColor = [UIColor orangeColor];
    customView.font = [UIFont boldSystemFontOfSize:16];
    customView.textColor = [UIColor purpleColor];
    customView.textAlignment = NSTextAlignmentCenter;
    [NemoStatusPrompt showCustomView:customView completion:^(BOOL finished) {
        
    }];
}
@end
