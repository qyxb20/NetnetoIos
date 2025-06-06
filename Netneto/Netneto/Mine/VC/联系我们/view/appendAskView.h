//
//  appendAskView.h
//  Netneto
//
//  Created by apple on 2025/4/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface appendAskView : UIView
+ (instancetype)initViewNIB;
@property (nonatomic, copy) void (^sureClickBlock) (NSString *content);

@end

NS_ASSUME_NONNULL_END
