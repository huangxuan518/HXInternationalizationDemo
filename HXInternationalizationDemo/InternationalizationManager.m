//
//  InternationalizationManager.m
//  HXInternationalizationDemo
//
//  Created by 黄轩 on 16/7/28.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "InternationalizationManager.h"

#define NSLocalizedStringTableName @"Hello"
#define UserLanguage @"userLanguage"

@interface InternationalizationManager ()

@property (nonatomic,strong) NSBundle *bundle;

@end

@implementation InternationalizationManager

+ (instancetype)shareInstance {
    static InternationalizationManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

//初始化语言
- (void)initUserLanguage {
    
    NSString *currentLanguage = [self currentLanguage];
    
    if(currentLanguage.length == 0){
        
        //获取系统当前语言版本(中文zh-Hans,英文en)
        NSArray *languages = [NSLocale preferredLanguages];
        
        currentLanguage = [languages objectAtIndex:0];
        
        [self saveLanguage:currentLanguage];
    }

    [self changeBundle:currentLanguage];
}

//语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
- (NSString *)languageFormat:(NSString*)lan {
    if([lan rangeOfString:@"zh-Hans"].location != NSNotFound)
    {
        return @"zh-Hans";
    }
    else if([lan rangeOfString:@"zh-Hant"].location != NSNotFound)
    {
        return @"zh-Hant";
    }
    else
    {
        //字符串查找
        if([lan rangeOfString:@"-"].location != NSNotFound) {
            //除了中文以外的其他语言统一处理@"ru_RU" @"ko_KR"取前面一部分
            NSArray *ary = [lan componentsSeparatedByString:@"_"];
            if (ary.count > 1) {
                NSString *str = ary[0];
                return str;
            }
        }
    }
    return lan;
}

//设置语言
- (void)setUserlanguage:(NSString *)language {

    if (![[self currentLanguage] isEqualToString:language] && _bundle) {
        [self saveLanguage:language];
        
        [self changeBundle:language];
        
        //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeLanguageNotificationName object:nil];
    }
}

//改变bundle
- (void)changeBundle:(NSString *)language {
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:[self languageFormat:language] ofType:@"lproj" ];
    _bundle = [NSBundle bundleWithPath:path];
}

//保存语言
- (void)saveLanguage:(NSString *)language {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:language forKey:UserLanguage];
    [defaults synchronize];
}

//获取语言
- (NSString *)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [defaults objectForKey:UserLanguage];
    return language;
}

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value {
    if (!_bundle) {
        [self initUserLanguage];
    }
    
    if (key.length > 0) {
        if (_bundle) {
            NSString *str = NSLocalizedStringFromTableInBundle(key, NSLocalizedStringTableName, _bundle, value);
            if (str.length > 0) {
                return str;
            }
        }
    }
    return @"";
}

- (UIImage *)ittemInternationalImageWithName:(NSString *)name {
    NSString *selectedLanguage = [self languageFormat:[self currentLanguage]];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",name,selectedLanguage]];
    return image;
}

@end
