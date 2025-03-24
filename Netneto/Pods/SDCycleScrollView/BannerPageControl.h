//
//  BannerPageControl.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^tapViewSelectAction)(NSInteger index);

@interface BannerPageControl : UIView
/**
 圆点个数
 */
@property(nonatomic, assign) NSInteger pageCount;

/**
 当前选中圆点
 */
@property(nonatomic, assign) NSInteger currentPage;

/**
 点击视图切换圆点动作
 */
@property(nonatomic, copy) tapViewSelectAction selectAction;

@end

NS_ASSUME_NONNULL_END
