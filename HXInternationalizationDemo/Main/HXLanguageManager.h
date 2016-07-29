//
//  HXLanguageManager.h
//  HXInternationalizationDemo
//
//  Created by 黄轩 on 16/7/28.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ChangeLanguageNotificationName @"changeLanguage"
#define kLocalizedString(key, comment) [kLanguageManager localizedStringForKey:key value:comment]

@interface HXLanguageManager : NSObject

@property (nonatomic,copy) void (^completion)(NSString *currentLanguage);

- (NSString *)currentLanguage; //当前语言
- (NSString *)languageFormat:(NSString*)language;
- (void)setUserlanguage:(NSString *)language;//设置当前语言

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;

- (UIImage *)ittemInternationalImageWithName:(NSString *)name;

+ (instancetype)shareInstance;

#define kLanguageManager [HXLanguageManager shareInstance]

@end
