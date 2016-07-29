//
//  HXPreferenceViewController.m
//  HXInternationalizationDemo
//
//  Created by 黄轩 on 16/7/29.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "HXPreferenceViewController.h"
#import "HXLanguageManager.h"

@interface HXPreferenceViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,copy) NSString *searchText;//搜索词

@end

@implementation HXPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataAry = [NSMutableArray new];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    searchBar.placeholder = kLocalizedString(@"search",@"搜索");
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    [self changeSearchBarCancleText:searchBar];
    self.tableView.tableHeaderView = searchBar;
    [self.view addSubview:self.tableView];
    
    [self changeLanguage];
    
    __weak __typeof(self)weakSelf = self;
    kLanguageManager.completion = ^(NSString *currentLanguage) {
        __strong __typeof(self)self = weakSelf;
        
        [self changeLanguage];
    };
}

//刷新界面
- (void)changeLanguage {
    self.title = kLocalizedString(@"preference",@"偏好");
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:kLocalizedString(@"cancel",@"取消") style:UIBarButtonItemStyleDone target:self action:@selector(cancleButtonAction:)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.tableView reloadData];
}

//目前支持的语言
- (NSArray *)languageAry {
    return @[@"zh-Hans-CN", //中文简体
             @"zh-Hant-CN", //中文繁体
             @"en-CN", //英语
             @"ko-CN", //韩语
             @"ja-CN", //日语
             @"fr-CN", //法语
             @"it-CN"]; //意大利语
}

- (NSArray *)dataAry {
    if (_searchText.length > 0) {
        //搜索则返回搜索数据
        return _dataAry;
    }
    else
    {
        //反之返回所有数据
        return self.languageAry;
    }
}

////对应国家的语言
- (NSString *)ittemCountryLanguage:(NSString *)lang {
    NSString *language = [kLanguageManager languageFormat:lang];
    NSString *countryLanguage = [[[NSLocale alloc] initWithLocaleIdentifier:language] displayNameForKey:NSLocaleIdentifier value:language];
    return countryLanguage;
}

////当前语言下的对应国家语言翻译
- (NSString *)ittemCurrentLanguageName:(NSString *)lang {
    NSString *language = [kLanguageManager languageFormat:lang];
    //当前语言
    NSString *currentLanguage = kLanguageManager.currentLanguage;
    //当前语言下的对应国家语言翻译
    NSString *currentLanguageName = [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] displayNameForKey:NSLocaleIdentifier value:language] ;
    return currentLanguageName;
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
    
    NSString *language = [kLanguageManager languageFormat:self.dataAry[indexPath.row]];
    
    //对应国家的语言
    NSString *countryLanguage = [self ittemCountryLanguage:self.dataAry[indexPath.row]];
    //当前语言下的对应国家语言翻译
    NSString *currentLanguageName = [self ittemCurrentLanguageName:self.dataAry[indexPath.row]] ;
    
    cell.textLabel.text = countryLanguage;
    cell.detailTextLabel.text = currentLanguageName;
    
    if (_searchText.length > 0) {
        cell.textLabel.attributedText = [self searchTitle:countryLanguage key:_searchText keyColor:[UIColor redColor]];
        cell.detailTextLabel.attributedText = [self searchTitle:currentLanguageName key:_searchText keyColor:[UIColor redColor]];
    } else {
        cell.textLabel.text = countryLanguage;
        cell.detailTextLabel.text = currentLanguageName;
    }
    
    //当前语言
    NSString *currentLanguage = kLanguageManager.currentLanguage;
    
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
    [kLanguageManager setUserlanguage:language];
    
    [self cancleButtonAction:nil];
}

// 设置文字中关键字高亮
- (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor {
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSString *copyStr = title;
    
    NSMutableString *xxstr = [NSMutableString new];
    for (int i = 0; i < key.length; i++) {
        [xxstr appendString:@"*"];
    }
    
    while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
        
        [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
        copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
    }
    return titleStr;
}

//修改searchBar中的文字为多语言
- (void)changeSearchBarCancleText:(UISearchBar *)searchBar {
    for (UIView *view in [[searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:kLocalizedString(@"cancel",@"取消") forState:UIControlStateNormal];
            [cancelBtn setTitle:kLocalizedString(@"cancel",@"取消") forState:UIControlStateHighlighted];
            [cancelBtn setTitle:kLocalizedString(@"cancel",@"取消") forState:UIControlStateSelected];
            [cancelBtn setTitle:kLocalizedString(@"cancel",@"取消") forState:UIControlStateDisabled];
        }
    }
}

//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tableView.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height*1.5);
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
    _searchText = searchText;
    
    [self ittemSearchResultsDataAryWithSearchText:searchText];
    
    [self.tableView reloadData];
}

//根据搜索词来查找符合的数据
- (void)ittemSearchResultsDataAryWithSearchText:(NSString *)searchText {
    [_dataAry removeAllObjects];
    
    [self.languageAry enumerateObjectsUsingBlock:^(NSString *lang, NSUInteger idx, BOOL * _Nonnull stop) {
        //对应国家的语言
        NSString *countryLanguage = [self ittemCountryLanguage:lang];
        //当前语言下的对应国家语言翻译
        NSString *currentLanguageName = [self ittemCurrentLanguageName:lang] ;
        
        if([countryLanguage rangeOfString:_searchText options:NSCaseInsensitiveSearch].location != NSNotFound || [currentLanguageName rangeOfString:_searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [_dataAry addObject:lang];
        }
    }];
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchText = nil;
    [self.view endEditing:YES];
    self.tableView.contentSize = CGSizeMake(0, 0);
    [self.tableView reloadData];
}

//搜索结果按钮点击的回调
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    [kLanguageManager setUserlanguage:searchBar.text];
    [self cancleButtonAction:nil];
}

//取消按钮
- (void)cancleButtonAction:(UIButton *)button {
    [self.view endEditing:YES];
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
