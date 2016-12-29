###webView控制器简单的封装实现

特性：

* 加载web带有进度条（iOS8以上才行）
* 可自由控制导航条标题
* 可自由控制导航条的显隐

###Usage



1. `- (instancetype)initWithEntry:(NSString *)entryStr andTitle:(NSString *)aTitle navHidden:(BOOL)navHidden`

 *  初始化一个webView控制器 
 *
 *  @param entryStr  内容地址
 *  @param aTitle    标题
 *  @param navHidden 导航条是否隐藏（一般网页不需要隐藏、本地自定义的需要隐藏）
 *
 *  @return PTCDVWebViewController对象


2. `- (instancetype)initWithEntry:(NSString *)entryStr navHidden:(BOOL)navHidden`

 *  初始化一个无导航title的webView控制器
 *
 *  @param entryStr  内容地址
 *  @param navHidden 导航条是否隐藏
 *
 *  @return PTCDVWebViewController对象


3. `+ (void)createWebContainerViewWithEntryUrl:(NSString *)entryUrl andFrame:(CGRect)frame addOnTarget:(UIViewController *)viewController`

 *  挖坑
 *  在某个控制器上面添加一个自定义大小的webView控制器
 *
 *  @param entryUrl       内容地址
 *  @param frame          frame
 *  @param viewController 父控制器

