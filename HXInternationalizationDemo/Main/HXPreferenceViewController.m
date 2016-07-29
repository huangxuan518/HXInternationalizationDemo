//
//  HXPreferenceViewController.m
//  HXInternationalizationDemo
//
//  Created by 黄轩 on 16/7/29.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "HXPreferenceViewController.h"
#import "HXInternationalizationManager.h"

@interface HXPreferenceViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataAry;

@end

@implementation HXPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    
    [self changeLanguage];
    
    __weak __typeof(self)weakSelf = self;
    kInternationalizationManager.completion = ^(NSString *currentLanguage) {
        __strong __typeof(self)self = weakSelf;
        
        [self changeLanguage];
    };
}

- (void)changeLanguage {
    self.title = kLocalizedString(@"preference",@"偏好");
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:kLocalizedString(@"cancel",@"取消") style:UIBarButtonItemStyleDone target:self action:@selector(cancleButtonAction:)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.tableView reloadData];
}

- (NSArray *)dataAry {
    if (!_dataAry) {
        _dataAry = @[@"zh-Hans-CN", //中文简体
                     @"ko-CN", //韩语
                     @"it-CN", //意大利语
                     @"ja-CN", //日语
                     @"zh-Hant-CN", //中文繁体
                     @"en-CN", //英语
                     @"fr-CN"]; //法语
    }
    return _dataAry;
}

#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }
    
    NSString *language = [kInternationalizationManager languageFormat:self.dataAry[indexPath.row]];
    
    //对应国家的语言
    NSString *countryLanguage = [[[NSLocale alloc] initWithLocaleIdentifier:language] displayNameForKey:NSLocaleIdentifier value:language];
    //当前语言
    NSString *currentLanguage = kInternationalizationManager.currentLanguage;
    //当前语言下的对应国家语言翻译
    NSString *currentLanguageName = [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] displayNameForKey:NSLocaleIdentifier value:language] ;
    
    cell.textLabel.text = countryLanguage;
    cell.detailTextLabel.text = currentLanguageName;
    
    if([currentLanguage rangeOfString:language].location != NSNotFound)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *language = self.dataAry[indexPath.row];
    [kInternationalizationManager setUserlanguage:language];
    
    [self cancleButtonAction:nil];
}

- (void)cancleButtonAction:(UIButton *)button {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
