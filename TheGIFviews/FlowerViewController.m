//
//  FlowerViewController.m
//  TheGIFviews
//
//  Created by 张君泽 on 16/9/2.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import "FlowerViewController.h"

@interface FlowerViewController ()
@property (assign,nonatomic) BOOL  isCleared;
@property (strong,nonatomic) NSMutableArray *cacheEmitterLayers;
@property (nonatomic, strong)UIButton *start;
@end

@implementation FlowerViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self clear];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    // Do any additional setup after loading the view.
}
- (void)creatUI{
    self.cacheEmitterLayers = [NSMutableArray array];
    
    
    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(240, 80, 150, 30)];
//    buton.backgroundColor = [UIColor cyanColor];
//    [buton setTitle:@"清除" forState:UIControlStateNormal];
    [self.view addSubview:buton];
    [buton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *start = [[UIButton alloc] initWithFrame:CGRectMake(50, 180, 150, 30)];
//    start.backgroundColor = [UIColor cyanColor];
    [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [start setTitle:@"开始" forState:UIControlStateNormal];
    self.start = start;
    [self.view addSubview:start];
    [start addTarget:self action:@selector(starttt) forControlEvents:UIControlEventTouchUpInside];

}
- (void)starttt{
    _isCleared = NO;
    _start.hidden = YES;
    NSLog(@"---%@",self.start.titleLabel.text);
    [_start setTitle:@"" forState:UIControlStateSelected];
    [_start setTitle:@"" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"star"];
    [self shootFrom:self.view.center Level:400 Cells:@[image]];
}
- (void)clear{
    self.isCleared = YES;
    for (CAEmitterLayer *emitterLayer in self.cacheEmitterLayers) {
        [emitterLayer removeFromSuperlayer];
        emitterLayer.emitterCells = nil;
    }
    [self.cacheEmitterLayers removeAllObjects];
}
- (void)shootFrom:(CGPoint)position Level:(int)level Cells:(NSArray <UIImage *>*)images; {
    if (_isCleared) return;
    CGPoint emiterPosition = position;
    // 配置发射器
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = emiterPosition;
    //发射源的尺寸大小
    emitterLayer.emitterSize     = CGSizeMake(10, 10);
    //发射模式
    emitterLayer.emitterMode     = kCAEmitterLayerOutline;
    //发射源的形状
    emitterLayer.emitterShape    = kCAEmitterLayerLine;
    emitterLayer.renderMode      = kCAEmitterLayerOldestLast;
    
    [self.view.layer addSublayer:emitterLayer];
    
    int index = rand()%[images count];
    CAEmitterCell *snowflake          = [CAEmitterCell emitterCell];
    //粒子的名字
    snowflake.name                    = @"sprite";
    //粒子参数的速度乘数因子
    snowflake.birthRate               = level;
    snowflake.lifetime                = 10;
    //粒子速度
    snowflake.velocity                = 400;
    //粒子的速度范围
    snowflake.velocityRange           = 100;
    //粒子y方向的加速度分量
    snowflake.yAcceleration           = 300;
    //snowflake.xAcceleration = 200;
    //周围发射角度
    snowflake.emissionRange           = 0.25*M_PI;
    //    snowflake.emissionLatitude = 200;
    snowflake.emissionLongitude       = 2*M_PI;//
    //子旋转角度范围
    snowflake.spinRange               = 2*M_PI;
    
    snowflake.contents                = (id)[[images objectAtIndex:index] CGImage];
    snowflake.contentsScale = 0.9;
    snowflake.scale                   = 0.1;
    snowflake.scaleSpeed              = 0.1;
    
    
    emitterLayer.emitterCells  = [NSArray arrayWithObject:snowflake];
    [self.cacheEmitterLayers addObject:emitterLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_isCleared)return ;
        emitterLayer.birthRate = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isCleared)return ;
            [emitterLayer removeFromSuperlayer];
            [self.cacheEmitterLayers removeObject:emitterLayer];
             [self.start setTitle:@"开始" forState:UIControlStateNormal];
        });
    });
//   [self.start setTitle:@"为丹丹姑娘献花" forState:UIControlStateSelected];
//    [self.start setTitle:@"为丹丹姑娘献花" forState:UIControlStateNormal];
    self.start.hidden = NO;
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
