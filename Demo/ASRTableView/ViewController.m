//
//  ViewController.m
//  ASRTableView
//
//  Created by 朱建伟 on 15/8/24.
//  Copyright (c) 2015年 zjw. All rights reserved.
//
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
    
//    self.menuView.backgroundColor = [UIColor lightGrayColor];
    
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
