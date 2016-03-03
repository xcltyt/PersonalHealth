//
//  PHPageViewController.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHPageViewController.h"
#import "PHShowViewController.h"
#import "PHBookList.h"
#import "PHBook.h"
#import "PHBookPageDetail.h"

@interface PHPageViewController () <UIPageViewControllerDataSource>
/** 存储返回的数据 */
@property (nonatomic, strong) NSMutableDictionary *pages;

@end

@implementation PHPageViewController

- (NSMutableDictionary *)pages
{
    if (_pages == nil) {
        
        _pages = [NSMutableDictionary dictionary];
    }
    return _pages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化所有数据
   // [self loadpageDetailDate];
    [self createContentPages];
    
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin],UIPageViewControllerOptionInterPageSpacingKey:[NSNumber numberWithFloat:0]};
    
    UIPageViewController *pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageController = pageController;
    pageController.view.frame = self.view.bounds;
    
    pageController.dataSource = self;
    
    // 得到currentIndex页
    PHShowViewController *initialController = [self viewControllerAtIndex:_currentIndex];
    
    NSArray *viewControllers =[NSArray arrayWithObject:initialController];
    [pageController setViewControllers:viewControllers
    direction:UIPageViewControllerNavigationDirectionForward  animated:YES  completion:nil];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [self.view addSubview:pageController.view];
    
    // 添加监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:PHShowVcFinishNotification object:nil];
    
}

- (void)UpdateData:(NSNotification *)noti
{
//    PHBookPageDetail *pageDetail = [noti.userInfo objectForKey:self.pageContent[_currentIndex]];
//    self.title = pageDetail.title;
    
    [self.pages addEntriesFromDictionary:noti.userInfo];
    
}

// 得到相应的VC对象
- (PHShowViewController *)viewControllerAtIndex:(NSUInteger)index {
    if ((self.pageContent.count == 0) || (index >= self.pageContent.count)) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    PHShowViewController *showViewController =[[PHShowViewController alloc] init];
    showViewController.pageIndex =[self.pageContent objectAtIndex:index];
    
    showViewController.pages = self.pages;
    return showViewController;
}

// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(PHShowViewController *)viewController {
    return [self.pageContent indexOfObject:viewController.pageIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
   // [self.navigationController setNavigationBarHidden:YES animated:NO];
}

// 初始化所有数据
- (void)createContentPages
{
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.book.list.count; i++){
        
        PHBookList *list = self.book.list[i];
        
        NSString *contentString = list.ID;
        [pageStrings addObject:contentString];
    }
    
    self.pageContent = pageStrings;
    
}


#pragma mark- UIPageViewControllerDataSource

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:(PHShowViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
    
    
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:(PHShowViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


    

- (void)didReceiveMemoryWarning {
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

@end
