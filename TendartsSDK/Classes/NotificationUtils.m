//
//  NotificationUtils.m
//  sdk
//
//  Created by Jorge Arimany on 26/6/17.
//  Copyright © 2017 10Darts. All rights reserved.
//
#import "TendartsSDK.h"
#import "NotificationUtils.h"
#import <UIKit/UIKit.h>


#ifdef _IOS_10_FUNCTIONALITY
#import <UserNotifications/UserNotifications.h>
#endif
#import "TDUtils.h"



@implementation NotificationUtils



+(void) registerRemoteNotifications
{
	//todo: save if already registered (dont ask twice)
	
	
	if( [TDUtils getIOSVersion] >=10.0)
	{
#ifdef _IOS_10_FUNCTIONALITY
		UIApplication* app = [UIApplication sharedApplication];
		NSSet* categories = [[app currentUserNotificationSettings] categories];
		[app registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) categories:categories]];

		
		UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
		[center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
							  completionHandler:^(BOOL granted, NSError * _Nullable error)
		{
			
			dispatch_async(dispatch_get_main_queue(), ^
			{
				//td1- notify new authorization status
			});
			
		
		}];
		
#endif
	}
	else
	{
		
		// ios 8
		UIUserNotificationType types = UIUserNotificationTypeBadge |
		UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
		UIUserNotificationSettings *settings =
		[UIUserNotificationSettings settingsForTypes:types categories:nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
		
	}
	
	
	
	id backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
	bool backgroundModesRemote = (backgroundModes && [backgroundModes containsObject:@"remote-notification"]);
	if( ! backgroundModesRemote)
	{
		
	}
	

	[[UIApplication sharedApplication] registerForRemoteNotifications];
	
	
	
	
	
	
	
	
	
}


@end
