//
//  BannerView.h
//  banner3d
//
//  Created by idechao on 2021/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Banner3DView : UIView

/**
 * 移动速度
 * 取值范围，0-1，数值越大，移动速度越快，默认0.2
 */
@property (nonatomic, assign) CGFloat rate;

/**
 * 更新频率
 * 默认0.1
 */
@property (nonatomic, assign) CGFloat updateInterval;


/**
 * x坐标最大偏移值，左右相同，设置绝对值
 * 作用于底图，和顶图，默认30.0
 */
@property (nonatomic, assign) CGFloat maxOffetX;

/**
 * y坐标最大偏移值
 * 作用于顶图，默认10.0
 */
@property (nonatomic, assign) CGFloat maxOffetY;

//@property (n)


/**
 * 开启动态检测
 */
- (void)start;

/**
 * 停止动态检测
 */
- (void)stop __attribute__((unused));

@end

NS_ASSUME_NONNULL_END
