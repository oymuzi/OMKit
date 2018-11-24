//
//  ViewController.m
//  OMKit
//
//  Created by oymuzi on 2018/11/24.
//  Copyright © 2018年 幸福的小木子. All rights reserved.
//

#import "ViewController.h"
#import "TimerViewController.h"

static NSString *const reuse = @"cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

/** 标题*/
@property (nonatomic, strong) NSArray *titles;
/** 表单*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OMKit";
    [self setupView];
}

- (void)setupView{
    UITableView *tableview = [[UITableView alloc] initWithFrame: self.view.frame];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc] init];
    tableview.tableHeaderView = [[UIView alloc] init];
    [tableview registerClass: [UITableView class] forCellReuseIdentifier: reuse];
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)jumpToPageByIndex: (NSInteger)index{
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = [[TimerViewController alloc] init];
            break;
        default:
            break;
    }
    if (vc) {
        vc.title = _titles[index];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuse];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self jumpToPageByIndex: indexPath.row];
}

- (NSArray *)titles{
    return @[@"OMtimer"];
}

@end
