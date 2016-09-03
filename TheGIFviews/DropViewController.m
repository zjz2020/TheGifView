//
//  DropViewController.m
//  TheGIFviews
//
//  Created by 张君泽 on 16/9/2.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import "DropViewController.h"
#import <CoreMotion/CoreMotion.h>
#define Screen_Width [UIScreen mainScreen].bounds.size.width
@interface DropViewController ()
///界面动态动画
@property (nonatomic, strong)UIDynamicAnimator *animator;
///重力行为
@property (nonatomic, strong)UIGravityBehavior *gravityBehavior;
///碰撞行为
@property (nonatomic, strong)UICollisionBehavior *collisionBehavitor;
///动态UI项目行为
@property (nonatomic, strong)UIDynamicItemBehavior *itemBehavitor;
@property (nonatomic, strong)CMMotionManager *motionMManager;
@property (nonatomic, strong)NSMutableArray *dropsArray;

@property (nonatomic, strong)UIImageView *leftShoot;
@property (nonatomic, strong)UIImageView *rightShoot;
@property (nonatomic, strong)UIView *gifView;
@property (nonatomic, strong)dispatch_source_t timer;
@property (nonatomic, assign)BOOL isDropping;
@property (nonatomic, assign)NSInteger pag;

@end

@implementation DropViewController
- (UIDynamicAnimator *)animator {
    if (!_animator) {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:_gifView];
        ///重力效果
        self.gravityBehavior = [[UIGravityBehavior alloc] init];
        ///碰撞效果
        self.collisionBehavitor = [[UICollisionBehavior alloc] init];
        [self.collisionBehavitor setTranslatesReferenceBoundsIntoBoundary:YES];
        [_animator addBehavior:self.gravityBehavior];
        [_animator addBehavior:self.collisionBehavitor];
    }
    return _animator;
}

- (NSMutableArray *)dropsArray {
    if (!_dropsArray) {
        self.dropsArray = [NSMutableArray new];
    }
    return _dropsArray;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _motionMManager = [[CMMotionManager alloc] init];
        [self startMotion];
    }
    return self;
}
- (void)startMotion{
    if (_motionMManager.accelerometerActive) {//加速剂活跃
        _motionMManager.accelerometerUpdateInterval = 1/3.0;
        __block typeof (self)weakSelf = self;
        [_motionMManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"CoreMotion Error:%@",error);
                [_motionMManager stopAccelerometerUpdates];
            }
            CGFloat a = accelerometerData.acceleration.x;
            CGFloat b = accelerometerData.acceleration.y;
            CGVector gravityDirection = CGVectorMake(a, -b);
            weakSelf.gravityBehavior.gravityDirection = gravityDirection;
        }];
    }else{
        NSLog(@"加速计不活跃");
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self didClickedClear:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)creatUI{
    _gifView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_gifView];
    _leftShoot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _leftShoot.image = [UIImage imageNamed:@"leftShoot"];
    [self.gifView addSubview:_leftShoot];
    _leftShoot.center = CGPointMake(50, 100);
    
    _rightShoot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _rightShoot.image = [UIImage imageNamed:@"rightShoot"];
    [self.gifView addSubview:_rightShoot];
    _rightShoot.center = CGPointMake(Screen_Width - 50, 100);
    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 50, 30)];
    buton.backgroundColor = [UIColor grayColor];
    [buton setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:buton];
    [buton addTarget:self action:@selector(addSerialDrop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 50, 30)];
    clearButton.backgroundColor = [UIColor grayColor];
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    [self.view addSubview:clearButton];
    [clearButton addTarget:self action:@selector(didClickedClear:) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark CLICKACTION
- (void)addSerialDrop{
    [self startMotion];
    UIImage *love = [UIImage imageNamed:@"love"];
    UIImage *star = [UIImage imageNamed:@"star"];
    if (self.dropsArray.count %2 == 0) {
        [self dropWithCount:30 images:@[love]];
    }else{
        [self dropWithCount:30 images:@[star,love]];
    }
    [self serialDrop];
}
- (NSMutableArray *)dropWithCount:(NSInteger)count images:(NSArray *)images{
    NSMutableArray *viewArray = [NSMutableArray new];
    for (NSInteger i = 0; i < count; i ++) {
        UIImage *image = [images objectAtIndex:rand()%[images count]];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
        imageV.contentMode = UIViewContentModeCenter;
        imageV.center = CGPointMake(50, 100);
        imageV.tag = 101;
        if (i %2 == 0) {
            imageV.center = CGPointMake(Screen_Width - 50, 100);
            imageV.tag = 202;
        }
        [viewArray addObject:imageV];
    }
    [self.dropsArray addObject:viewArray];
    return _dropsArray;
}
- (void)serialDrop{//串行
    if (_isDropping) return;
    _isDropping = YES;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.5 *NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.05 *NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        if (self.dropsArray.count == 0) return;
        NSMutableArray *currentDrops = self.dropsArray[0];
        if ([currentDrops count]) {
            if (currentDrops.count == 0) return;
            UIImageView *dropView = currentDrops[0];
            [currentDrops removeObjectAtIndex:0];
            [self.gifView addSubview:dropView];
            UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[dropView] mode:UIPushBehaviorModeInstantaneous];
            [self.animator addBehavior:pushBehavior];
            //角度范围[0.6--1.0]
            float random = ((int)(2 +(arc4random()%(10-4+1)))) *0.1;
            pushBehavior.pushDirection = CGVectorMake(0.6, random);
            if (dropView.tag != 101) {
                pushBehavior.pushDirection = CGVectorMake(-0.6, random);
            }
            pushBehavior.magnitude = 0.3;
            [self.gravityBehavior addItem:dropView];
            [self.collisionBehavitor addItem:dropView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dropView.alpha = 0;
                [self.gravityBehavior removeItem:dropView];
                [self.collisionBehavitor removeItem:dropView];
                [pushBehavior removeItem:dropView];
                [self.animator removeBehavior:pushBehavior];
                [dropView removeFromSuperview];
            });
        }else{
            dispatch_source_cancel(self.timer);
            [self.dropsArray removeObject:currentDrops];
            _isDropping = NO;
            if (self.dropsArray.count) {
                [self serialDrop];
            }
        }
    });
    dispatch_source_set_cancel_handler(_timer, ^{
        
    });
    //启动
    dispatch_resume(self.timer);
}
- (void)didClickedClear:(UIButton *)sender{
    //停止陀螺仪
    [_motionMManager stopAccelerometerUpdates];
    _isDropping = NO;
    if (_timer) {
//        dispatch_cancel(_timer);
        _timer = nil;
    }
    for (UIDynamicBehavior *behavior in _animator.behaviors) {
        if (behavior == self.gravityBehavior) {
            for (UIImageView *imageV in self.gravityBehavior.items) {
                [self.gravityBehavior removeItem:imageV];
                if (imageV.superview) {
                    [imageV removeFromSuperview];
                }
                continue;
            }
        }else if (behavior == self.collisionBehavitor){
            for (UIImageView *iview in self.collisionBehavitor.items) {
                [self.collisionBehavitor removeItem:iview];
                if (iview.superview) {
                    [iview removeFromSuperview];
                }
                continue;
            }
        }else{
            [_animator removeBehavior:behavior];
        }
    }
    self.animator = nil;
    [self.dropsArray removeAllObjects];
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
