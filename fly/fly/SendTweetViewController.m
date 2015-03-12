//
//  SendTweetViewController.m
//  fly
//
//  Created by xyz on 15-3-12.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "SendTweetViewController.h"

@interface SendTweetViewController ()
{
    UITextView *_textView;
}
@end

@implementation SendTweetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.alpha = 0.7f;
    self.view.backgroundColor = [UIColor grayColor];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, -180, self.view.frame.size.width-20, 180);
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(0, textView.frame.size.height-30, 60, 30)];
    [cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:cancelBtn];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"send" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [commitBtn setFrame:CGRectMake(textView.frame.size.width-60, textView.frame.size.height-30, 60, 30)];
    [commitBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:commitBtn];
    
    
    _textView = textView;
    
    [self showView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)showView{
    [UIView animateWithDuration:0.3 animations:^{
        _textView.transform = CGAffineTransformMakeTranslation(0, 210);
    }];
    [_textView becomeFirstResponder];
}

- (void)back{
    [UIView animateWithDuration:0.3 animations:^{
        _textView.transform = CGAffineTransformMakeTranslation(0, -210);
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}

@end
