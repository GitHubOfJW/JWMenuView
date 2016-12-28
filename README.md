# JWMenuView
1. 分页显示菜单
2. 自动滚动

## 展示效果
![2016-12-28 14.05.50-w314](https://github.com/GitHubOfJW/JWMenuView/blob/master/Introduce/2016-12-28%2014.05.50.gif****)

## 头文件

```
#import <UIKit/UIKit.h>
@class JWMenuView;
/**
 *  代理方法
 */
@protocol JWMenuViewDelegate <NSObject>

@optional
/**
 *  点击的回调 点击指定的 菜单按钮对应 的索引
 */
-(void)jwMenuView:(JWMenuView*)menuView didSelectMenuAtIndex:(NSInteger)menuIndex;

/**
 *  点击的回调 点击指定的 菜单按钮对应 的索引
 */
-(BOOL)jwMenuView:(JWMenuView*)menuView shouldSelectMenuAtIndex:(NSInteger)menuIndex;

@end

@interface JWMenuView : UIView
/**
 *  菜单标题，@[@"中国",@"韩国",@"朝鲜"];
 */
@property(nonatomic,strong)NSArray *menuTitleArray;
/**
 *  设置未选中标题的颜色
 */
@property(nonatomic,assign)UIColor *menuNormalTitleColor;
/**
 *  设置选中标题的颜色
 */
@property(nonatomic,strong)UIColor *menuSelectedTitleColor;

/**
 *  设置底部条颜色
 */
@property(nonatomic,strong)UIColor *bottomIndicatorColor;


/**
 *  代理
 */
@property(nonatomic,weak)id<JWMenuViewDelegate> delegate;

/**
 *  当前索引
 */
@property(nonatomic,assign,readonly)NSInteger menuIndex;

/**
 *  滚动到指定的菜单 会执行回调用
 */
-(BOOL)clickMenuWithIndex:(NSInteger)menuIndex;

@end

```
## Usage

```
#import "JWMenuView.h"
#import "ViewController.h"


@interface ViewController ()<JWMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topMenu;

@property(nonatomic,strong)JWMenuView *menuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.automaticallyAdjustsScrollViewInsets =  NO;
    
    [self.view addSubview:self.menuView];
     
    //菜单
    self.menuView.menuTitleArray=@[@"中国",@"韩国",@"白俄罗斯",@"日本",@"乌兹别克斯坦",@"俄罗斯",@"美国",@"意大利",@"新加坡",@"大不列颠",@"缅甸"];
    
    self.menuView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.menuView.menuNormalTitleColor= [UIColor blackColor];
    self.menuView.menuSelectedTitleColor= [UIColor redColor];
    self.menuView.delegate=self;
    
}


/**
 *  菜单 回调
 */
-(void)jwMenuView:(JWMenuView *)menuView didSelectMenuAtIndex:(NSInteger)menuIndex
{
    NSLog(@"选中了索引为%zd的菜单按钮",menuIndex);
}

-(JWMenuView *)menuView
{
    if(_menuView==nil)
    {
        _menuView=[[JWMenuView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    }
    
    return _menuView;
}
@end

```


