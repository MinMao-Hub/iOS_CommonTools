//
//  PTCDVWebViewController.m
//  WKWebViewDemo
//
//  Created by 郭永红 on 16/5/12.
//  Copyright © 2016年 郭永红. All rights reserved.
//

#import "PTWebViewController.h"
#import <WebKit/WebKit.h>

@interface PTWebViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString *entryString;
@property (nonatomic, assign) BOOL navHidden;
@property (nonatomic, assign) CGRect containerFrame;

@property (nonatomic, strong) UIProgressView *progressView;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
//iOS8的新特性代码
@property (nonatomic, strong) WKWebView *webView;
#else
@property (nonatomic, strong) UIWebView *webView;

#endif



@end

@implementation PTWebViewController

- (instancetype)initWithEntry:(NSString *)entryStr navHidden:(BOOL)navHidden
{
    return  [self initWithEntry:entryStr andTitle:nil navHidden:navHidden];
}

- (instancetype)initWithEntry:(NSString *)entryStr andTitle:(NSString *)aTitle navHidden:(BOOL)navHidden {
    self = [super init];
    if (self) {
        self.title = aTitle;
        self.entryString = entryStr;
        self.navHidden = navHidden;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height)];
#else
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
#endif
    
    [self.view addSubview:self.webView];
    
    [self.webView.scrollView setBounces: YES];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.directionalLockEnabled = YES;
    self.webView.autoresizesSubviews = NO;//自动调整大小
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.entryString]]];
    
//    if ([self.webView isKindOfClass:[UIWebView class]]) {
//        UIWebView *tmpWeb = (UIWebView *)self.webView;
//        tmpWeb.allowsPictureInPictureMediaPlayback = YES;   //iOS9可用
//    }else
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        [self setProgressView];
        WKWebView *wkWebView = (WKWebView *)self.webView;
        //添加观察者
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [wkWebView addObserver:self forKeyPath:@"navTitle" options:NSKeyValueObservingOptionNew context:NULL];

    }
    
    [self addEdgePop];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.containerFrame.size.width != 0) {
        [self.webView setFrame:self.containerFrame];
        self.view.layer.masksToBounds=YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.navHidden animated:NO];
    if (!self.navHidden) {
        self.navigationItem.leftItemsSupplementBackButton = NO;
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[self navBackButton]]];
//        [self.webView setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)addEdgePop
{
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGestureRecognizer.delegate = self;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer*)edgePanGestureRecognizer
{
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        UIWebView *tmpWeb = (UIWebView *)self.webView;
        if ([tmpWeb canGoBack]) {
            [tmpWeb goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([self.webView isKindOfClass:[WKWebView class]]) {
        WKWebView *tmpWeb = (WKWebView *)self.webView;
        if ([tmpWeb canGoBack]) {
            [tmpWeb goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

#pragma mark- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.navigationController || [self.navigationController.viewControllers count] == 1) {
        return NO;
    }
    return YES;
}


+ (void)createWebContainerViewWithEntryUrl:(NSString *)entryUrl andFrame:(CGRect)frame addOnTarget:(UIViewController *)viewController
{
    
    //创建一个容器view（用来放CDVVC）
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor lightGrayColor];
    [containView setFrame:frame];
    containView.layer.masksToBounds=YES;
    [viewController.view addSubview:containView];
    
    PTWebViewController *webViewControler = [[PTWebViewController alloc] initWithEntry:entryUrl navHidden:YES];
    webViewControler.containerFrame = containView.bounds;
    
    [viewController addChildViewController:webViewControler];
    [containView addSubview:webViewControler.view];
    [webViewControler didMoveToParentViewController:viewController];
}


- (UIButton *)navBackButton
{
    UIButton *backBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 55, 44);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    return backBtn;
}

- (void)backBtnClicked:(id)sender {
    
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        UIWebView *tmpWeb = (UIWebView *)self.webView;
        if ([tmpWeb canGoBack]) {
            [tmpWeb goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([self.webView isKindOfClass:[WKWebView class]]) {
        WKWebView *tmpWeb = (WKWebView *)self.webView;
        if ([tmpWeb canGoBack]) {
            [tmpWeb goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)setProgressView
{
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 8)];
    _progressView.progressTintColor = [UIColor greenColor];
    _progressView.trackTintColor = [UIColor whiteColor];
    
    
    [self.webView addSubview:_progressView];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        WKWebView *wkWebView = (WKWebView *)self.webView;
        
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            
            if (object == self.webView) {
                [self.progressView setAlpha:1.0f];
                [self.progressView setProgress:wkWebView.estimatedProgress animated:YES];
                
                if(wkWebView.estimatedProgress >= 1.0f) {
                    
                    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self.progressView setAlpha:0.0f];
                    } completion:^(BOOL finished) {
                        [self.progressView setProgress:0.0f animated:NO];
                    }];
                    
                }
            }
            else
            {
                [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            }
            
        }
        else if ([keyPath isEqualToString:@"navTitle"])
        {
            if (object == self.webView) {
                self.title = wkWebView.title;
                
            }
            else
            {
                [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
                
            }
        }
        else {
            
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"navTitle"];
}

@end
