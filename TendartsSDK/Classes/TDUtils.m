//
//  TDUtils.m
//  sdk
//
//  Created by Jorge Arimany on 3/7/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import "TDUtils.h"
#import <UIKit/UIKit.h>

@implementation TDUtils

+ (float)getIOSVersion
{
	return [[[UIDevice currentDevice] systemVersion] floatValue] ;
}
+(NSString*) getCurrentLanguage
{
	//return [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
	NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
	return [language substringToIndex:2];
	
}



@end
