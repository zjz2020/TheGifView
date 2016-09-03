//
//  ViewController.m
//  TheGIFviews
//
//  Created by 张君泽 on 16/9/2.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import "ViewController.h"
#import "DropViewController.h"
#import "LiveViewController.h"
#import "FireViewController.h"
#import "FlowerViewController.h"
#import "SnowViewController.h"
static NSString *reuseIdentifier = @"reuserCell";
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *titles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"酷炫效果";
    [self _initTabelView];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void) _initTabelView{
    _titles = @[@"粒子掉落",@"直播礼物冒泡效果",@"烟花效果",@"喷射效果",@"雪花飘落"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView setExclusiveTouch:YES];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            [self.navigationController pushViewController:[[DropViewController alloc] init] animated:YES];
            break;
        }
        case 1:{
            [self.navigationController pushViewController:[[LiveViewController alloc] init] animated:YES];
            break;
        }
        case 2:{
            [self.navigationController pushViewController:[[FireViewController alloc] init] animated:YES];
            break;
        }
        case 3:{
            [self.navigationController pushViewController:[[FlowerViewController alloc] init] animated:YES];
            break;
        }
        case 4:{
            [self.navigationController pushViewController:[[SnowViewController alloc] init] animated:YES];
            break;
        }
            
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
