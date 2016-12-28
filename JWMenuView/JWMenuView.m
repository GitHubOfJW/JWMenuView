//
//  JWMenuView.m
//  ASRTableView
//
//  Created by 朱建伟 on 15/9/8.
//  Copyright (c) 2015年 zjw. All rights reserved.
//

/**
 *  菜单按钮的字体
 */
#define KMenuBtnFontSize 16
#define KBtnAddW 15
/**
 *  菜单背景随即色 不要的话找到 删掉那行代码
 */
#define KRandomColor [UIColor colorWithRed:((arc4random_uniform(226)+30)/255.0) green:((arc4random_uniform(226)+30)/255.0) blue:((arc4random_uniform(226)+30)/255.0) alpha:1]

#import "JWMenuButton.h"
#import "JWMenuView.h"

@interface JWMenuView()
/**
 *  菜单上的ScrollView
 */
@property(nonatomic,strong)UIScrollView *bgScrollView;

@property(nonatomic,strong)JWMenuButton *selectedMenuBtn;


/**
 *  btnArray
 */
@property(nonatomic,strong)NSMutableArray<JWMenuButton*>* btnArray;

/**
 *  底部的进度条
 */
@property(nonatomic,strong)UIView* bottomView;
/**
 *  按钮宽度
 */
@property(nonatomic,assign)CGFloat totalMenuW;

@end


@implementation JWMenuView

/**
 *  初始化控件
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //初始化
        _bgScrollView=[[UIScrollView alloc] init];
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.showsVerticalScrollIndicator=NO;
        [self addSubview:_bgScrollView];
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor orangeColor];
        
//        [_bgScrollView addSubview:_bottomView];
        [self addSubview:_bottomView];
    }
    return self;
}

/**
 *  设置菜单
 */
-(void)setMenuTitleArray:(NSArray *)menuTitleArray
{
    _menuTitleArray=menuTitleArray;
    
    
    self.totalMenuW = 0;
    
    [self.btnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.btnArray removeAllObjects];
    
    if (menuTitleArray&&menuTitleArray.count) {
        [menuTitleArray enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL *stop) {
            
            JWMenuButton *menuBtn=[[JWMenuButton alloc] init];
            menuBtn.titleLabel.font = [UIFont systemFontOfSize:KMenuBtnFontSize];
            menuBtn.tag=idx;
            if (self.menuNormalTitleColor) {
                [menuBtn setTitleColor:self.menuNormalTitleColor forState:UIControlStateNormal];
            }
            if(self.menuSelectedTitleColor)
            {
                [menuBtn setTitleColor:self.menuSelectedTitleColor forState:UIControlStateSelected];
            }
            if (idx==0) {
                self.selectedMenuBtn=menuBtn;
                _menuIndex = 0;
                self.selectedMenuBtn.selected=YES;
            }
            [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            menuBtn.backgroundColor=KRandomColor;
            [menuBtn setTitle:title forState:UIControlStateNormal];
            [menuBtn setTitle:title forState:UIControlStateSelected];
            
            
             //计算整个进度条的宽度
             self.totalMenuW += [title boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KMenuBtnFontSize]} context:nil].size.width+KBtnAddW;
            
            [self.btnArray addObject:menuBtn];
            [self.bgScrollView addSubview:menuBtn];
        }];
    }
}

/**
 *  菜单按钮点击
 */
-(void)menuBtnClick:(JWMenuButton*)menuBtn
{
    /**
     *  代理 回调
     */
    if([self.delegate respondsToSelector:@selector(jwMenuView:shouldSelectMenuAtIndex:)])
    {
        if(![self.delegate jwMenuView:self shouldSelectMenuAtIndex:menuBtn.tag]){
            return;
        }
    }
    
    [self.bgScrollView setContentOffset:CGPointMake(menuBtn.OffsetX, 0) animated:YES];
    
    if(menuBtn.selected)return;
    
    _menuIndex = menuBtn.tag;
    if (self.selectedMenuBtn) {
        self.selectedMenuBtn.selected=NO;
    }
    
    menuBtn.selected=YES;
    self.selectedMenuBtn=menuBtn;
    
    
    [self.bottomView.layer removeAllAnimations];
    
//    CGFloat bottomX = 0;
//    if(menuBtn.OffsetX == 0){
//        bottomX = menuBtn.frame.origin.x + KBtnAddW/2
//    }else{
//        
//    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.frame = CGRectMake(menuBtn.frame.origin.x+KBtnAddW/2 - menuBtn.OffsetX , self.bgScrollView.bounds.size.height-2, menuBtn.bounds.size.width-KBtnAddW, 2);
    }];
    
    /**
     *  代理 回调
     */
    if([self.delegate respondsToSelector:@selector(jwMenuView:didSelectMenuAtIndex:)])
    {
        [self.delegate jwMenuView:self didSelectMenuAtIndex:menuBtn.tag];
    }
}


/**
 *  布局
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat thisW=self.bounds.size.width;
    CGFloat thisH=self.bounds.size.height;
    
    //布局scrollView
    CGFloat bgW=thisW;
    CGFloat bgH=thisH;
    CGFloat bgX=0;
    CGFloat bgY=0;
    _bgScrollView.frame=CGRectMake(bgX, bgY, bgW, bgH);
    
         
    //记录最大的X值
    __block CGFloat tempMaxX=0;
    
    
    CGFloat allBtnW = 0;
    //如果小于scrollView宽度
    if(self.totalMenuW < self.bgScrollView.bounds.size.width){
        allBtnW = self.bgScrollView.bounds.size.width / self.menuTitleArray.count;
    }
    
    //布局子控件
    [self.btnArray enumerateObjectsUsingBlock:^(JWMenuButton *menuBtn, NSUInteger idx, BOOL *stop) {
        CGFloat btnW = KBtnAddW;
        NSString *title=[self.menuTitleArray objectAtIndex:idx];
        btnW+=[title boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KMenuBtnFontSize]} context:nil].size.width;
        
        
        //如果不够宽，则设计平分
        if(allBtnW > 0){
            btnW =  allBtnW;
        }
        
        CGFloat btnH=thisH;
        CGFloat btnX=tempMaxX;
        CGFloat btnY=0;
        CGRect menuBtnFrame=CGRectMake(btnX,btnY,btnW,btnH);
        tempMaxX=CGRectGetMaxX(menuBtnFrame);
        menuBtn.frame=CGRectMake(btnX,btnY,btnW,btnH);
        
    }];
    self.bgScrollView.contentSize=CGSizeMake(tempMaxX, thisH);
    
    //设置滚动位置
    [self setUpAllMenuButtonSelectShouldScrollToOffset];
    
    if(self.selectedMenuBtn){
        self.bottomView.frame = CGRectMake(self.selectedMenuBtn.frame.origin.x+KBtnAddW/2 - self.selectedMenuBtn.OffsetX, self.bgScrollView.bounds.size.height-2, self.selectedMenuBtn.bounds.size.width-KBtnAddW, 2);
    }
}

/**
 *  根据传过来的 按钮的frame 算出该按钮点击后应该滑动的位置
 */
-(void)setUpAllMenuButtonSelectShouldScrollToOffset
{
    //contentSize
    CGFloat contentSizeW=self.bgScrollView.contentSize.width;
    
    //背景scrollView的中点
    CGFloat bgCenterX=self.bgScrollView.bounds.size.width*0.5;
    
    //遍历菜单按钮
    [self.btnArray enumerateObjectsUsingBlock:^(JWMenuButton *menuBtn, NSUInteger idx, BOOL *stop) {
        CGRect menuBtnFrame=menuBtn.frame;
        CGFloat menuBtnCenterX=CGRectGetMidX(menuBtnFrame);
        if (menuBtnCenterX>bgCenterX) {//按钮在中点右侧
            CGFloat offsetX=menuBtnCenterX-bgCenterX;
            menuBtn.OffsetX=offsetX;
            
            //在右边的话，拉的太远就会超出 contentSize 判断一下
            if(offsetX+bgCenterX*2>contentSizeW)
            { 
                menuBtn.OffsetX=contentSizeW-bgCenterX*2;
            }
        }
        else//在左侧  不用滚动
        {
            menuBtn.OffsetX=0;
        }
            
    }];
    
}


-(void)setBottomIndicatorColor:(UIColor *)bottomIndicatorColor
{
    _bottomIndicatorColor = bottomIndicatorColor;
    
    self.bottomView.backgroundColor = bottomIndicatorColor;
}

-(void)setMenuNormalTitleColor:(UIColor *)menuNormalTitleColor
{
    _menuNormalTitleColor=menuNormalTitleColor;
    
    [self.btnArray enumerateObjectsUsingBlock:^(JWMenuButton *menuBtn, NSUInteger idx, BOOL *stop) {
        [menuBtn setTitleColor:menuNormalTitleColor forState:UIControlStateNormal];
    }];
}

-(void)setMenuSelectedTitleColor:(UIColor *)menuSelectedTitleColor
{
    _menuSelectedTitleColor=menuSelectedTitleColor;
    
    [self.btnArray enumerateObjectsUsingBlock:^(JWMenuButton *menuBtn, NSUInteger idx, BOOL *stop) {
        [menuBtn setTitleColor:menuSelectedTitleColor forState:UIControlStateSelected];
    }];
}

-(NSMutableArray<JWMenuButton *> *)btnArray{
    if(_btnArray == nil){
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

-(BOOL)clickMenuWithIndex:(NSInteger)menuIndex{
    if(menuIndex < self.btnArray.count&&menuIndex>=0){
        if (menuIndex != self.menuIndex){
            [self menuBtnClick:self.btnArray[menuIndex]];
            return true;
        }else{
            return false;
        }
    }else{
        return false;
    }
}
@end
