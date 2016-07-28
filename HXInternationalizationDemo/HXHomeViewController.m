//
//  HXHomeViewController.m
//  HXInternationalizationDemo
//
//  Created by 黄轩 on 16/7/28.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "HXHomeViewController.h"
#import "InternationalizationManager.h"

@interface HXHomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeLanguageButton;
@property (weak, nonatomic) IBOutlet UIImageView *icoImageView;

@end

@implementation HXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:ChangeLanguageNotificationName object:nil];
    
    [self changeLanguage];
}

- (IBAction)changeLanguageButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [kInternationalizationManager setUserlanguage:@"en"];
    } else {
        [kInternationalizationManager setUserlanguage:@"zh-Hans"];
    }
}

- (void)changeLanguage {
    [_changeLanguageButton setTitle:kLocalizedString(@"buttonInfo",nil) forState:UIControlStateNormal];
    _titleLabel.text = kLocalizedString(@"invite",nil);
    _icoImageView.image = [kInternationalizationManager ittemInternationalImageWithName:@"details_promotion"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:ChangeLanguageNotificationName];
}

@end
