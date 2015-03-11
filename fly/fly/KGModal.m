//
//  KGModal.m
//  KGModal
//
//  Created by David Keegan on 10/5/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "KGModal.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "LocationViewController.h"
#import "SelectImageVC.h"

CGFloat const kFadeInAnimationDuration = 0.3;
CGFloat const kTransformPart1AnimationDuration = 0.2;
CGFloat const kTransformPart2AnimationDuration = 0.1;
CGFloat const kDefaultCloseButtonPadding = 17.0;

NSString *const KGModalGradientViewTapped = @"KGModalGradientViewTapped";

NSString *const KGModalWillShowNotification = @"KGModalWillShowNotification";
NSString *const KGModalDidShowNotification = @"KGModalDidShowNotification";
NSString *const KGModalWillHideNotification = @"KGModalWillHideNotification";
NSString *const KGModalDidHideNotification = @"KGModalDidHideNotification";

@interface KGModalGradientView : UIView
@end

@interface KGModalContainerView : UIView
@property (weak, nonatomic) CALayer *styleLayer;
@property (strong, nonatomic) UIColor *modalBackgroundColor;
@end

@interface KGModalCloseButton : UIButton
@end

@interface KGModalViewController : UIViewController
@property (weak, nonatomic) KGModalGradientView *styleView;
@end

@interface KGModal()
{
    UITextView *infoLabel;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (weak, nonatomic) KGModalViewController *viewController;
@property (weak, nonatomic) KGModalContainerView *containerView;
@property (weak, nonatomic) KGModalCloseButton *closeButton;
@property (weak, nonatomic) UIView *contentView;

@end

@implementation KGModal

+ (instancetype)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if(!(self = [super init])){
        return nil;
    }
    self.hasPic = NO;
    self.hasLocation = NO;
    self.shouldRotate = YES;
    self.tapOutsideToDismiss = YES;
    self.animateWhenDismissed = YES;
    //self.closeButtonType = KGModalCloseButtonTypeNone;
    self.modalBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    return self;
}

-(void)setCloseButtonType:(KGModalCloseButtonType)closeButtonType {
    _closeButtonType = closeButtonType;
    if(closeButtonType == KGModalCloseButtonTypeNone)
    {
        [self.closeButton setHidden:YES];
    }else{
        [self.closeButton setHidden:NO];
        
        CGRect closeFrame = self.closeButton.frame;
        if(closeButtonType == KGModalCloseButtonTypeRight)
        {
            closeFrame.origin.x = round(CGRectGetWidth(self.containerView.frame)-kDefaultCloseButtonPadding-CGRectGetWidth(closeFrame)/2);
        }else{
            closeFrame.origin.x = 0;
        }
        self.closeButton.frame = closeFrame;
    }
}

- (void)showWithContentView:(UIView *)contentView{
    [self showWithContentView:contentView andAnimated:YES];
}

- (void)showWithContentViewController:(UIViewController *)contentViewController{
    [self showWithContentViewController:contentViewController andAnimated:YES];
}

- (void)showWithContentViewController:(UIViewController *)contentViewController andAnimated:(BOOL)animated{
    self.contentViewController = contentViewController;
    [self showWithContentView:contentViewController.view andAnimated:YES];
}
-(void)updateTweet
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 220)];
    [self showWithContentView:contentView andAnimated:YES];
    
}
-(void)commentTweet:(TweetModel *)model
{
    self.model = model;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 220)];
    [self showWithComment:contentView andAnimated:YES];
}
-(void)replyTweet:(TweetModel *)model
{
    self.model = model;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 220)];
    [self showReply:contentView andAnimated:YES];
}
- (void)showReply:(UIView *)contentView andAnimated:(BOOL)animated
{
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.x = 40;
    welcomeLabelRect.origin.y = 0;
    welcomeLabelRect.size.width = 200;
    welcomeLabelRect.size.height = 13;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:12];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"回复";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.textColor = [UIColor orangeColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSendTweetAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [contentView addSubview:cancelBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(240, 0, 40, 20)];
    [sendBtn setTitle:@"回复" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(replyTweetAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sendBtn];
    
    CGRect userNameRect = contentView.bounds;
    userNameRect.origin.y = 13;
    userNameRect.origin.x = 40;
    userNameRect.size.width = 200;
    userNameRect.size.height = 15;
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:userNameRect];
    NSDictionary *userdict = [ShareToken readUserDetail];
    userNameLabel.text = [userdict objectForKey:@"name"];
    userNameLabel.font = [UIFont boldSystemFontOfSize:13];;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.textColor = [UIColor orangeColor];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.shadowColor = [UIColor blackColor];
    userNameLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:userNameLabel];
    UILabel *splitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, 260, 1)];
    splitLabel.backgroundColor = [UIColor orangeColor];
    [contentView addSubview:splitLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = 30;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect) + 50;
    self.accessibilityElementsHidden = NO;
    infoLabel = [[UITextView alloc]initWithFrame:infoLabelRect];
    [infoLabel becomeFirstResponder];
    infoLabel.delegate = self;
    infoLabel.tag = 10;
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:infoLabel];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    
    KGModalViewController *viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    self.viewController = viewController;
    
    CGFloat padding = 17;
    CGRect containerViewRect = CGRectInset(contentView.bounds, -padding, -padding);
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = round(CGRectGetMidX(self.window.bounds)-CGRectGetMidX(containerViewRect));
    //containerViewRect.origin.y = round(CGRectGetMidY(self.window.bounds)-CGRectGetMidY(containerViewRect));
    containerViewRect.origin.y = 20;
    KGModalContainerView *containerView = [[KGModalContainerView alloc] initWithFrame:containerViewRect];
    containerView.modalBackgroundColor = self.modalBackgroundColor;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){padding, 20, contentView.bounds.size};
    //contentView.frame = (CGRect){padding, padding, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    self.containerView = containerView;
    
    KGModalCloseButton *closeButton = [[KGModalCloseButton alloc] init];
    
    if(self.closeButtonType == KGModalCloseButtonTypeRight){
        CGRect closeFrame = closeButton.frame;
        closeFrame.origin.x = CGRectGetWidth(containerView.bounds)-CGRectGetWidth(closeFrame);
        closeButton.frame = closeFrame;
    }
    
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeButton];
    self.closeButton = closeButton;
    
    // Force adjust visibility and placing
    [self setCloseButtonType:self.closeButtonType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];
    
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KGModalWillShowNotification object:self];
        [self.window makeKeyAndVisible];
        
        if(animated){
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];
            
            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalDidShowNotification object:self];
                }];
            }];
        }
    });
}
-(void)repostTweet:(TweetModel *)model
{
    self.model = model;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 220)];
    [self showRepost:contentView andAnimated:YES];
}
- (void)showRepost:(UIView *)contentView andAnimated:(BOOL)animated
{
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.x = 40;
    welcomeLabelRect.origin.y = 0;
    welcomeLabelRect.size.width = 200;
    welcomeLabelRect.size.height = 13;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:12];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"转发微博";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.textColor = [UIColor orangeColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSendTweetAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [contentView addSubview:cancelBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(240, 0, 40, 20)];
    [sendBtn setTitle:@"转发" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(repostTweetAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sendBtn];
    
    CGRect userNameRect = contentView.bounds;
    userNameRect.origin.y = 13;
    userNameRect.origin.x = 40;
    userNameRect.size.width = 200;
    userNameRect.size.height = 15;
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:userNameRect];
    NSDictionary *userdict = [ShareToken readUserDetail];
    userNameLabel.text = [userdict objectForKey:@"name"];
    userNameLabel.font = [UIFont boldSystemFontOfSize:13];;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.textColor = [UIColor orangeColor];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.shadowColor = [UIColor blackColor];
    userNameLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:userNameLabel];
    UILabel *splitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, 260, 1)];
    splitLabel.backgroundColor = [UIColor orangeColor];
    [contentView addSubview:splitLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = 30;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect) + 50;
    self.accessibilityElementsHidden = NO;
    infoLabel = [[UITextView alloc]initWithFrame:infoLabelRect];
    [infoLabel becomeFirstResponder];
    infoLabel.delegate = self;
    infoLabel.tag = 10;
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:infoLabel];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    
    KGModalViewController *viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    self.viewController = viewController;
    
    CGFloat padding = 17;
    CGRect containerViewRect = CGRectInset(contentView.bounds, -padding, -padding);
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = round(CGRectGetMidX(self.window.bounds)-CGRectGetMidX(containerViewRect));
    //containerViewRect.origin.y = round(CGRectGetMidY(self.window.bounds)-CGRectGetMidY(containerViewRect));
    containerViewRect.origin.y = 20;
    KGModalContainerView *containerView = [[KGModalContainerView alloc] initWithFrame:containerViewRect];
    containerView.modalBackgroundColor = self.modalBackgroundColor;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){padding, 20, contentView.bounds.size};
    //contentView.frame = (CGRect){padding, padding, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    self.containerView = containerView;
    
    KGModalCloseButton *closeButton = [[KGModalCloseButton alloc] init];
    
    if(self.closeButtonType == KGModalCloseButtonTypeRight){
        CGRect closeFrame = closeButton.frame;
        closeFrame.origin.x = CGRectGetWidth(containerView.bounds)-CGRectGetWidth(closeFrame);
        closeButton.frame = closeFrame;
    }
    
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeButton];
    self.closeButton = closeButton;
    
    // Force adjust visibility and placing
    [self setCloseButtonType:self.closeButtonType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];
    
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KGModalWillShowNotification object:self];
        [self.window makeKeyAndVisible];
        
        if(animated){
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];
            
            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalDidShowNotification object:self];
                }];
            }];
        }
    });
}
- (void)showWithComment:(UIView *)contentView andAnimated:(BOOL)animated
{
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.x = 40;
    welcomeLabelRect.origin.y = 0;
    welcomeLabelRect.size.width = 200;
    welcomeLabelRect.size.height = 13;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:12];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"评论";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.textColor = [UIColor orangeColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSendTweetAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [contentView addSubview:cancelBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(240, 0, 40, 20)];
    [sendBtn setTitle:@"评论" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(commentTweetAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sendBtn];
    
    CGRect userNameRect = contentView.bounds;
    userNameRect.origin.y = 13;
    userNameRect.origin.x = 40;
    userNameRect.size.width = 200;
    userNameRect.size.height = 15;
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:userNameRect];
    NSDictionary *userdict = [ShareToken readUserDetail];
    userNameLabel.text = [userdict objectForKey:@"name"];
    userNameLabel.font = [UIFont boldSystemFontOfSize:13];;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.textColor = [UIColor orangeColor];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.shadowColor = [UIColor blackColor];
    userNameLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:userNameLabel];
    UILabel *splitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, 260, 1)];
    splitLabel.backgroundColor = [UIColor orangeColor];
    [contentView addSubview:splitLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = 30;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect) + 50;
    self.accessibilityElementsHidden = NO;
    infoLabel = [[UITextView alloc]initWithFrame:infoLabelRect];
    [infoLabel becomeFirstResponder];
    infoLabel.delegate = self;
    infoLabel.tag = 10;
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:infoLabel];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    
    KGModalViewController *viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    self.viewController = viewController;
    
    CGFloat padding = 17;
    CGRect containerViewRect = CGRectInset(contentView.bounds, -padding, -padding);
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = round(CGRectGetMidX(self.window.bounds)-CGRectGetMidX(containerViewRect));
    //containerViewRect.origin.y = round(CGRectGetMidY(self.window.bounds)-CGRectGetMidY(containerViewRect));
    containerViewRect.origin.y = 20;
    KGModalContainerView *containerView = [[KGModalContainerView alloc] initWithFrame:containerViewRect];
    containerView.modalBackgroundColor = self.modalBackgroundColor;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){padding, 20, contentView.bounds.size};
    //contentView.frame = (CGRect){padding, padding, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    self.containerView = containerView;
    
    KGModalCloseButton *closeButton = [[KGModalCloseButton alloc] init];
    
    if(self.closeButtonType == KGModalCloseButtonTypeRight){
        CGRect closeFrame = closeButton.frame;
        closeFrame.origin.x = CGRectGetWidth(containerView.bounds)-CGRectGetWidth(closeFrame);
        closeButton.frame = closeFrame;
    }
    
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeButton];
    self.closeButton = closeButton;
    
    // Force adjust visibility and placing
    [self setCloseButtonType:self.closeButtonType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];
    
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KGModalWillShowNotification object:self];
        [self.window makeKeyAndVisible];
        
        if(animated){
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];
            
            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalDidShowNotification object:self];
                }];
            }];
        }
    });
}
- (void)showWithContentView:(UIView *)contentView andAnimated:(BOOL)animated
{
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.x = 40;
    welcomeLabelRect.origin.y = 0;
    welcomeLabelRect.size.width = 200;
    welcomeLabelRect.size.height = 13;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:12];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"发布";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.textColor = [UIColor orangeColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSendTweetAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [contentView addSubview:cancelBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(240, 0, 40, 20)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendTweetAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sendBtn];
    
    CGRect userNameRect = contentView.bounds;
    userNameRect.origin.y = 13;
    userNameRect.origin.x = 40;
    userNameRect.size.width = 200;
    userNameRect.size.height = 15;
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:userNameRect];
    NSDictionary *userdict = [ShareToken readUserDetail];
    userNameLabel.text = [userdict objectForKey:@"name"];
    userNameLabel.font = [UIFont boldSystemFontOfSize:13];;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.textColor = [UIColor orangeColor];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.shadowColor = [UIColor blackColor];
    userNameLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:userNameLabel];
    UILabel *splitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, 260, 1)];
    splitLabel.backgroundColor = [UIColor orangeColor];
    [contentView addSubview:splitLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = 30;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect) + 50;
    self.accessibilityElementsHidden = NO;
    infoLabel = [[UITextView alloc]initWithFrame:infoLabelRect];
    [infoLabel becomeFirstResponder];
    infoLabel.delegate = self;
    infoLabel.tag = 10;
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:infoLabel];
    
    UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 190, 22, 22)];
    [locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"hasLocation"] forState:UIControlStateSelected];
    [locationBtn addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:locationBtn];
    
    UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(45, 190, 22, 22)];
    [imageBtn setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [imageBtn setImage:[UIImage imageNamed:@"hasPhoto"] forState:UIControlStateSelected];
    [imageBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:imageBtn];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    
    KGModalViewController *viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    self.viewController = viewController;
    
    CGFloat padding = 17;
    CGRect containerViewRect = CGRectInset(contentView.bounds, -padding, -padding);
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = round(CGRectGetMidX(self.window.bounds)-CGRectGetMidX(containerViewRect));
    //containerViewRect.origin.y = round(CGRectGetMidY(self.window.bounds)-CGRectGetMidY(containerViewRect));
    containerViewRect.origin.y = 20;
    KGModalContainerView *containerView = [[KGModalContainerView alloc] initWithFrame:containerViewRect];
    containerView.modalBackgroundColor = self.modalBackgroundColor;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){padding, 20, contentView.bounds.size};
    //contentView.frame = (CGRect){padding, padding, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    self.containerView = containerView;
    
    KGModalCloseButton *closeButton = [[KGModalCloseButton alloc] init];
    
    if(self.closeButtonType == KGModalCloseButtonTypeRight){
        CGRect closeFrame = closeButton.frame;
        closeFrame.origin.x = CGRectGetWidth(containerView.bounds)-CGRectGetWidth(closeFrame);
        closeButton.frame = closeFrame;
    }
    
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeButton];
    self.closeButton = closeButton;
    
    // Force adjust visibility and placing
    [self setCloseButtonType:self.closeButtonType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];
    
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KGModalWillShowNotification object:self];
        [self.window makeKeyAndVisible];
        
        if(animated){
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];
            
            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalDidShowNotification object:self];
                }];
            }];
        }
    });
}
-(void)locationAction
{
    NSLog(@"location");
    LocationViewController *location = [[LocationViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:location];
    [location requestLocation:^(NSDictionary *latlong)
    {
        NSLog(@"lat:%@long:%@",[latlong objectForKey:@"lat"],[latlong objectForKey:@"long"]);
        self.getLat = [latlong objectForKey:@"lat"];
        self.getLong = [latlong objectForKey:@"long"];
        self.hasLocation = YES;
    } failed:^(NSString *noLocation)
    {
        NSLog(@"nolocation:%@",noLocation);
        self.hasLocation = NO;
    }];
    [self.viewController presentViewController:nvc animated:YES completion:nil];
}
-(void)addPicture
{
    NSLog(@"picture");
    SelectImageVC *vc = [[SelectImageVC alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self.viewController presentViewController:nvc animated:NO completion:^{
    }];
    [vc requestImageSuccess:^(NSData *image)
     {
         self.selectImage = image;
         self.hasPic = YES;
         NSLog(@"get image!!:%@",image);
         
     } failed:^(NSString *str)
     {
         self.hasPic = NO;
         NSLog(@"str:%@",str);
     }];
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.allowsEditing = YES;
//    picker.delegate = self;
//    [self.viewController presentViewController:picker animated:YES completion:^{
//    }];
}
-(void)cancelSendTweetAction
{
    [self hideAnimated:self.animateWhenDismissed];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)replyTweetAction
{
    if (infoLabel.text.length>0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *cid = [NSString stringWithFormat:@"%@",_model.tid];
        NSString *tid = [NSString stringWithFormat:@"%@",_model.model.tid];
        NSString *comment = [NSString stringWithFormat:@"%@",infoLabel.text];
        NSMutableDictionary *mydict = [[NSMutableDictionary alloc]init];
        [mydict setValue:[ShareToken readToken] forKey:@"access_token"];
        [mydict setValue:cid forKey:@"cid"];
        [mydict setValue:tid forKey:@"id"];
        [mydict setValue:comment forKey:@"comment"];
        NSLog(@"mydict:%@",mydict);
        [manager POST:kUrlReply parameters:mydict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"success:%@",responseObject);
             [self hideAnimated:self.animateWhenDismissed];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"failed:%@",error.localizedDescription);
         }];
    }
}
-(void)repostTweetAction
{
    NSString *str = infoLabel.text;
    if (str.length == 0)
    {
        str = @"repost";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_model.tid,@"id",str,@"status", nil];
    [manager POST:kURLRepost parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success:%@",responseObject);
         [self hideAnimated:self.animateWhenDismissed];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failed:%@",error.localizedDescription);
     }];
}
-(void)commentTweetAction
{
    NSString *str = infoLabel.text;
    if (str.length == 0)
    {
        str = @"repost";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_model.tid,@"id",str,@"status", nil];
    [manager POST:kURLCreateComment parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success:%@",responseObject);
         [self hideAnimated:self.animateWhenDismissed];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failed:%@",error.localizedDescription);
     }];
}
-(void)sendTweetAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *currentUrl = kURLupdate;
    NSDictionary *tweetdict;
    if (infoLabel.text == 0)
    {
        infoLabel.text = @"分享微博";
    }
    if (self.hasPic)
    {
        currentUrl = kURLupload;
        if (self.hasLocation)
        {
            tweetdict = [NSDictionary dictionaryWithObjectsAndKeys:infoLabel.text,@"status",[ShareToken readToken],@"access_token",self.selectImage,@"pic",self.getLat,@"lat",self.getLong,@"long", nil];
        }else
        {
            tweetdict = [NSDictionary dictionaryWithObjectsAndKeys:infoLabel.text,@"status",[ShareToken readToken],@"access_token", nil];
        }
        
        
        [manager POST:currentUrl parameters:tweetdict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:self.selectImage name:@"pic" fileName:@"test" mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success:%@",responseObject);
            [self hideAnimated:self.animateWhenDismissed];
            self.hasPic = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed:%@",error);
        }];
    }else
    {
        currentUrl = kURLupdate;
        if (self.hasLocation)
        {
            tweetdict = [NSDictionary dictionaryWithObjectsAndKeys:infoLabel.text,@"status",[ShareToken readToken],@"access_token",self.getLat,@"lat",self.getLong,@"long", nil];
        }else
        {
            tweetdict = [NSDictionary dictionaryWithObjectsAndKeys:infoLabel.text,@"status",[ShareToken readToken],@"access_token", nil];
        }
        [manager POST:currentUrl parameters:tweetdict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"success:%@",responseObject);
             [self hideAnimated:self.animateWhenDismissed];
             //[self dismissViewControllerAnimated:YES completion:nil];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             //NSLog(@"failed:%@",error.localizedDescription);
             NSLog(@"failed:%@",error);
         }];
    }
    //NSLog(@"current url :%@",currentUrl);
    //NSLog(@"dict:%@",tweetdict);
    
    /*
    [manager POST:currentUrl parameters:tweetdict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success:%@",responseObject);
         [self hideAnimated:self.animateWhenDismissed];
         //[self dismissViewControllerAnimated:YES completion:nil];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"failed:%@",error.localizedDescription);
         NSLog(@"failed:%@",error);
     }];
     */
}
- (void)closeAction:(id)sender{
    [self hideAnimated:self.animateWhenDismissed];
}

- (void)tapCloseAction:(id)sender{
    if(self.tapOutsideToDismiss){
        [self hideAnimated:self.animateWhenDismissed];
    }
}

- (void)hide{
    [self hideAnimated:YES];
}

- (void)hideWithCompletionBlock:(void(^)())completion{
    [self hideAnimated:YES withCompletionBlock:completion];
}

- (void)hideAnimated:(BOOL)animated{
    [self hideAnimated:animated withCompletionBlock:nil];
}

- (void)hideAnimated:(BOOL)animated withCompletionBlock:(void(^)())completion{
    if(!animated){
        [self cleanup];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KGModalWillHideNotification object:self];

        [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
            self.viewController.styleView.alpha = 0;
        }];
        
        self.containerView.layer.shouldRasterize = YES;
        [UIView animateWithDuration:kTransformPart2AnimationDuration animations:^{
            self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:kTransformPart1AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.containerView.alpha = 0;
                self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            } completion:^(BOOL finished2){
                [self cleanup];
                if(completion){
                    completion();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:KGModalDidHideNotification object:self];
            }];
        }];
    });
}

- (void)cleanup{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.containerView removeFromSuperview];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    [self.window removeFromSuperview];
    self.contentViewController = nil;    
    self.window = nil;
}

- (void)setModalBackgroundColor:(UIColor *)modalBackgroundColor{
    if(_modalBackgroundColor != modalBackgroundColor){
        _modalBackgroundColor = modalBackgroundColor;
        self.containerView.modalBackgroundColor = modalBackgroundColor;
    }
}

- (void)dealloc{
    [self cleanup];
}

@end

@implementation KGModalViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    KGModalGradientView *styleView = [[KGModalGradientView alloc] initWithFrame:self.view.bounds];
    styleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    styleView.opaque = NO;
    [self.view addSubview:styleView];
    self.styleView = styleView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [[KGModal sharedInstance] shouldRotate];
}

- (BOOL)shouldAutorotate
{
    return [[KGModal sharedInstance] shouldRotate];
}

@end

@implementation KGModalContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(!(self = [super initWithFrame:frame]))
    {
        return nil;
    }
    
    CALayer *styleLayer = [[CALayer alloc] init];
    styleLayer.cornerRadius = 4;
    styleLayer.shadowColor= [[UIColor blackColor] CGColor];
    styleLayer.shadowOffset = CGSizeMake(0, 0);
    styleLayer.shadowOpacity = 0.5;
    styleLayer.borderWidth = 1;
    styleLayer.borderColor = [[UIColor whiteColor] CGColor];
    styleLayer.frame = CGRectInset(self.bounds, 12, 12);
    [self.layer addSublayer:styleLayer];
    self.styleLayer = styleLayer;
    
    return self;
}

- (void)setModalBackgroundColor:(UIColor *)modalBackgroundColor{
    if(_modalBackgroundColor != modalBackgroundColor){
        _modalBackgroundColor = modalBackgroundColor;
        self.styleLayer.backgroundColor = [modalBackgroundColor CGColor];
    }
}

@end

@implementation KGModalGradientView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalGradientViewTapped object:nil];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if([[KGModal sharedInstance] backgroundDisplayStyle] == KGModalBackgroundDisplayStyleSolid){
        [[UIColor colorWithWhite:0 alpha:0.55] set];
        CGContextFillRect(context, self.bounds);
    }else{
        CGContextSaveGState(context);
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace), colorSpace = NULL;
        CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
        CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
    }
}

@end

@implementation KGModalCloseButton

- (instancetype)init{
    if(!(self = [super initWithFrame:(CGRect){0, 0, 32, 32}])){
        return nil;
    }
    static UIImage *closeButtonImage;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        closeButtonImage = [self closeButtonImage];
    });
    [self setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    return self;
}

- (UIImage *)closeButtonImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor *topGradient = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:0.9];
    UIColor *bottomGradient = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.9];
    
    //// Gradient Declarations
    NSArray *gradientColors = @[(id)topGradient.CGColor,
                                (id)bottomGradient.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 3;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(0, 1);
    CGFloat shadow2BlurRadius = 0;
    
    
    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 3, 24, 24)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 3), CGPointMake(16, 27), 0);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    CGContextRestoreGState(context);
    
    
    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(18.83, 15)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(16, 17.83)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(13.17, 15)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(16, 12.17)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark textview delegate


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
