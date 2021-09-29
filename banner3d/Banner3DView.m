//
//  BannerView.m
//  banner3d
//
//  Created by idechao on 2021/9/27.
//

#import "Banner3DView.h"

static NSString *const kAnimationKey = @"positionKey";

@import CoreMotion;

@interface Banner3DView ()

@property (nonatomic, strong) CMMotionManager *motionManager ; // 设置全局，保持对象

@property (nonatomic, strong) UIImageView *frontImageView; // 左右，上下移动
//@property (nonatomic, strong) UIImageView *middleImageView; // 设置固定
@property (nonatomic, strong) UIImageView *backImageView; // 背景图
@property (nonatomic, assign) CGPoint lastBackImageViewCenter; // 保存底图上次中心点
@property (nonatomic, assign) CGPoint lastFrontImageViewCenter; // 保存顶图上次中心点

@end

@implementation Banner3DView

- (void)dealloc {
    [self.motionManager stopDeviceMotionUpdates];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _rate = 0.2;
        _maxOffetX = 30.0;
        _maxOffetY = 30.0;
        
        _lastBackImageViewCenter = CGPointZero;
        _updateInterval = 0.1; // 刚好60帧的最大值设置，在大的话肉眼可见的卡顿
        
        [self p_init];
    }
    return self;
}

- (void)p_init {
    UIImageView *frontImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    frontImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.frontImageView = frontImageView;
    
    UIImageView *middleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    middleImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.middleImageView = middleImageView;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView = backImageView;
    
    UIImage *image1 = [UIImage imageNamed:@"banner1"];
    UIImage *image2 = [UIImage imageNamed:@"banner2"];
    UIImage *image3 = [UIImage imageNamed:@"banner3"];
    
    frontImageView.image = image1;
    middleImageView.image = image2;
    backImageView.image = image3;
    
    [self addSubview:backImageView];
    [self addSubview:middleImageView];
    [self addSubview:frontImageView];
    
    backImageView.frame = CGRectMake(0, 0, self.frame.size.width+self.maxOffetX*2, self.frame.size.height);
    backImageView.center = self.center;

    middleImageView.frame = self.bounds;
    
    frontImageView.frame = CGRectMake(0, 0, self.frame.size.width+self.maxOffetX*2, self.frame.size.height+self.maxOffetY);
    frontImageView.center = self.center;
}

- (void)start {
    if (!self.motionManager.deviceMotionAvailable) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
        __unused double x = motion.gravity.x;
        __unused double y = motion.gravity.y;
        __unused double z = motion.gravity.z;
        
        double roll = motion.attitude.roll;
        double pitch = motion.attitude.pitch;
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateRoll:roll pitch:pitch];
    }];
}

/*取消动画，unused只为消除警告*/
- (void)stop __attribute__((unused)) {
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)updateRoll:(double)roll pitch:(double)pitch {

    // 设置最大偏移值X
    CGFloat maxOffsetX = self.center.x*roll * 0.2;
    if (maxOffsetX > self.maxOffetX) {
        maxOffsetX = self.maxOffetX;
    } else if (maxOffsetX < -self.maxOffetX) {
        maxOffsetX = -self.maxOffetX;
    }
    
    CGFloat centerX = self.center.x + maxOffsetX;
    CGPoint newBackImageViewCenter = CGPointMake(centerX, self.center.y);
    
    CABasicAnimation *backImageViewAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    backImageViewAnimation.fromValue = [NSValue valueWithCGPoint:self.lastBackImageViewCenter];
    backImageViewAnimation.toValue = [NSValue valueWithCGPoint:newBackImageViewCenter];
    backImageViewAnimation.duration = self.updateInterval;
    backImageViewAnimation.fillMode = kCAFillModeForwards;
    backImageViewAnimation.removedOnCompletion = NO;
    
    self.lastBackImageViewCenter = newBackImageViewCenter;
    [self.backImageView.layer removeAnimationForKey:kAnimationKey];
    [self.backImageView.layer addAnimation:backImageViewAnimation forKey:kAnimationKey];
    
    // 设置最大偏移值Y
    CGFloat maxOffsetY = self.center.y*pitch * 0.2;
    if (maxOffsetY > self.maxOffetY) {
        maxOffsetY = self.maxOffetY;
    } else if (maxOffsetY < -self.maxOffetY) {
        maxOffsetY = -self.maxOffetY;
    }
    CGPoint newFrontImageViewCenter = CGPointMake(self.center.x-maxOffsetX, self.center.y+maxOffsetY);

    CABasicAnimation *frontImageViewAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    frontImageViewAnimation.fromValue = [NSValue valueWithCGPoint:self.lastFrontImageViewCenter];
    frontImageViewAnimation.toValue = [NSValue valueWithCGPoint:newFrontImageViewCenter];
    frontImageViewAnimation.duration = self.updateInterval;
    frontImageViewAnimation.fillMode = kCAFillModeForwards;
    frontImageViewAnimation.removedOnCompletion = NO;

    self.lastFrontImageViewCenter = newFrontImageViewCenter;
    [self.frontImageView.layer removeAnimationForKey:kAnimationKey];
    [self.frontImageView.layer addAnimation:frontImageViewAnimation forKey:kAnimationKey];
}

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = self.updateInterval;
    }
    return _motionManager;
}

@end
