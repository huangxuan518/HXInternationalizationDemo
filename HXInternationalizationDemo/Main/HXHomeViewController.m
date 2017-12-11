//
//  HXHomeViewController.m
//  HXInternationalizationDemo https://github.com/huangxuan518/HXInternationalizationDemo
//  博客地址 http://blog.libuqing.com/
//  Created by 黄轩 on 16/7/28.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "HXHomeViewController.h"
#import "HXPreferenceViewController.h"
#import "HXLanguageManager.h"

@interface HXHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *worldImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icoImageView;

@end

@implementation HXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:ChangeLanguageNotificationName object:nil];
    
    [self setWorldImageViewAnimation];

    [self changeLanguage];
}

//设置动画
- (void)setWorldImageViewAnimation {
    NSArray *array = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"world_1"],
                      [UIImage imageNamed:@"world_2"],
                      [UIImage imageNamed:@"world_3"],
                      [UIImage imageNamed:@"world_4"],
                      nil];
    [_worldImageView setAnimationImages:array];
    [_worldImageView setAnimationDuration:1.5];
    [_worldImageView startAnimating];
}

//改变语言界面刷新
- (void)changeLanguage {

    self.title = kLocalizedTableString(@"home", @"HomeLocalizable");
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:kLocalizedTableString(@"preference",@"HomeLocalizable") style:UIBarButtonItemStyleDone target:self action:@selector(gotoPreferenceViewController)];
    self.navigationItem.rightBarButtonItem = item;
    
    _titleLabel.text = kLocalizedTableString(@"welcome",@"HomeLocalizable");
    _icoImageView.image = [kLanguageManager ittemInternationalImageWithName:@"github"];
}

#pragma mark - goto

//去偏好设置界面
- (void)gotoPreferenceViewController {
    HXPreferenceViewController *vc = [HXPreferenceViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

//去本人github页面
- (IBAction)gotoGithub:(UITapGestureRecognizer *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/huangxuan518"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:ChangeLanguageNotificationName];
}

@end
