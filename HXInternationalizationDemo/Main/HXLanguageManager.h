//
//  HXLanguageManager.h
//  HXInternationalizationDemo https://github.com/huangxuan518/HXInternationalizationDemo
//  博客地址 http://blog.libuqing.com/
//  Created by 黄轩 on 16/7/28.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ChangeLanguageNotificationName @"changeLanguage"
#define kLocalizedString(key) [kLanguageManager localizedStringForKey:key]
#define kLocalizedTableString(key,tableN) [kLanguageManager localizedStringForKey:key tableName:tableN]

@interface HXLanguageManager : NSObject

@property (nonatomic,copy) void (^completion)(NSString *currentLanguage);

- (NSString *)currentLanguage; //当前语言
- (NSString *)languageFormat:(NSString*)language;
- (void)setUserlanguage:(NSString *)language;//设置当前语言

- (NSString *)localizedStringForKey:(NSString *)key;

- (NSString *)localizedStringForKey:(NSString *)key tableName:(NSString *)tableName;

- (UIImage *)ittemInternationalImageWithName:(NSString *)name;

+ (instancetype)shareInstance;

#define kLanguageManager [HXLanguageManager shareInstance]

@end
