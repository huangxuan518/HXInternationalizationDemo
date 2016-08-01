//
//  HXHomeViewController.m
//  https://github.com/huangxuan518/HXInternationalizationDemo
//
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

- (void)gotoPreferenceViewController {
    HXPreferenceViewController *vc = [HXPreferenceViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)changeLanguage {
    self.title = kLocalizedString(@"home",@"首页");
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:kLocalizedString(@"preference",@"偏好") style:UIBarButtonItemStyleDone target:self action:@selector(gotoPreferenceViewController)];
    self.navigationItem.rightBarButtonItem = item;
    
    _titleLabel.text = kLocalizedString(@"welcome",@"你好 世界!");
    _icoImageView.image = [kLanguageManager ittemInternationalImageWithName:@"github"];
}

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
