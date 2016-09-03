//
//  LiveViewController.m
//  TheGIFviews
//
//  Created by 张君泽 on 16/9/2.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import "LiveViewController.h"
#import "UIButton+Bubbling.h"
@interface LiveViewController ()
@property (strong,nonatomic) UIButton *bubbeBtn;

@property (strong,nonatomic) NSArray *images;
@end

@implementation LiveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(200, self.view.frame.size.height - 100, 50, 30)];
    buton.backgroundColor = [UIColor grayColor];
    [buton setTitle:@"冒泡" forState:UIControlStateNormal];
    [self.view addSubview:buton];
    [buton addTarget:self action:@selector(clickeLiveBtn) forControlEvents:UIControlEventTouchUpInside];
    self.bubbeBtn = buton;
    
    _images = @[@"ic_menu_bluepig",
                @"ic_menu_bluepig2",
                @"ic_menu_greenpig",
                @"ic_menu_greenpig2",
                @"ic_menu_pinkpig",
                @"ic_menu_pinkpig2",
                @"ic_menu_purplepig",
                @"ic_menu_purplepig2",
                @"ic_menu_yellowpig",
                @"ic_menu_yellowpig2"];

    // Do any additional setup after loading the view.
}
- (void)clickeLiveBtn{
    [self.bubbeBtn bubbingImage:[UIImage imageNamed:@"love"]];
    [self.bubbeBtn bubbingImages:_images];
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
