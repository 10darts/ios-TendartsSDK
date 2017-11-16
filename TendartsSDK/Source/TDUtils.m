
#import "TDUtils.h"
#import <UIKit/UIKit.h>

@implementation TDUtils

+ (float)getIOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue] ;
}

+ (NSString *)getCurrentLanguage {
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return [language substringToIndex:2];
}

@end

