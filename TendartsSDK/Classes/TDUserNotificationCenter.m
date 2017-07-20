//
//  TDUserNotificationCenter.m
//  sdk
//
//  Created by Jorge Arimany on 3/7/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import "TDUserNotificationCenter.h"
#import "TDClassUtils.h"
#import <UserNotifications/UserNotifications.h>
#import "TendartsSDK.h"
@implementation TDUserNotificationCenter



static UNUserNotificationCenter * currentNC = nil;
+ (void) installTDUserNotifications
{
	

	
	
	
	//insert our custom set delegate override that will install all delegate functionality
	putMethodInTarget([TDUserNotificationCenter class], @selector(setTDDelegate:), [UNUserNotificationCenter class], @selector(setDelegate:));

#ifdef _IOS_10_FUNCTIONALITY
	
	
	//td3

	
	currentNC = [UNUserNotificationCenter currentNotificationCenter];
	if( currentNC.delegate == nil)
	{
		TendartsSDK* instance = [TendartsSDK instance];
		currentNC.delegate = (id) instance;
	}
#endif
}

- (void) setTDDelegate:(id)delegate
{
	NSLog(@"Set delegate: user notification center");
	
	
	Class existingDelegate =  searchAncestorImplementingProtocol([delegate class], @protocol(UNUserNotificationCenterDelegate));
	NSArray * childs = getChilds(existingDelegate);
	
	//install our methods:
	
	installOverrideMethod([TDUserNotificationCenter class],
						  @selector(TDUNC:willPresentNotification:withCompletionHandler:),
						  existingDelegate,
						  childs,
						  @selector(userNotificationCenter:willPresentNotification:withCompletionHandler:));
	
	installOverrideMethod([TDUserNotificationCenter class],
						  @selector(TDUNC:didReceiveNotificationResponse:withCompletionHandler:),
						  existingDelegate,
						  childs,
						  @selector(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:));
	
	//call esxisting
	if( [self respondsToSelector:@selector(setTDDelegate:)])
	{
		[self setTDDelegate:delegate];
	}
	

}




- (void)TDUNC:(UNUserNotificationCenter *)center
				willPresentNotification:(UNNotification *)notification
				  withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {


	//notify openned notification
	NSLog(@"td: willPresentNotification");
	
	//td7
	
	completionHandler( UNAuthorizationOptionBadge|  UNAuthorizationOptionSound | UNAuthorizationOptionAlert);
}

//Called to let your app know which action was selected by the user for a given notification.
- (void)TDUNC:(UNUserNotificationCenter *)center
		 didReceiveNotificationResponse:(UNNotificationResponse *)response
				  withCompletionHandler:(void(^)())completionHandler {
	
	NSLog(@"td: didReceiveNotificationResponse");
	
	//td8
	
	completionHandler();
}



@end
