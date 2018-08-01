//
//  HMViewController.m
//  HMCodeInputView
//
//  Created by 1013732192@qq.com on 08/01/2018.
//  Copyright (c) 2018 1013732192@qq.com. All rights reserved.
//

#import "HMViewController.h"
#import "HMCodeInputView.h"
@interface HMViewController ()

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    HMCodeInputView * inputView = [[HMCodeInputView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 50) maxLength:6 borderColor:[UIColor redColor] borderColorHL:[UIColor greenColor] keyboardType:(UIKeyboardTypeNumberPad) codeBlock:^(NSString *code) {
        NSLog(@"+++++%@", code);
    }];
    [self.view addSubview:inputView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
