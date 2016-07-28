//
//  ViewController.m
//  AnimationShowProject
//
//  Created by Bert on 16/7/20.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import "ViewController.h"
#import "AnimationViewController.h"
#import "BasicAnimationVC.h"
@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArr;
}@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"Animation Show";
    titleArr = @[@"Progress",@"Fireworks",@"Circle",@"BasicAnimation",@"Draw Line with animation"];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    

    NSLog(@"-----kkx %@",[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]);
    
     NSLog(@"-----numberWithFloat %@",[NSNumber numberWithFloat:300.434]);
    
    
}

#pragma mark -
#pragma mark --- UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = titleArr[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        BasicAnimationVC *animaVC = [[BasicAnimationVC alloc]init];
        [self.navigationController pushViewController:animaVC animated:YES];
    }else
    {
        AnimationViewController *animaVC = [[AnimationViewController alloc]init];
        animaVC.index = indexPath.row;
        [self.navigationController pushViewController:animaVC animated:YES];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
