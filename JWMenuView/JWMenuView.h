//
//  JWMenuView.h
//  ASRTableView
//
//  Created by 朱建伟 on 15/9/8.
//  Copyright (c) 2015年 zjw. All rights reserved.
//

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
