
#import <UIKit/UIKit.h>

#import "TendartsSDK.h"
#import "NotificationUtils.h"
#import "TDUtils.h"

#ifdef _IOS_10_FUNCTIONALITY
#import <UserNotifications/UserNotifications.h>
#endif

@implementation NotificationUtils

+ (void)registerRemoteNotifications {
	//todo: save if already registered (dont ask twice)
#if !(IN_APP_EXTENSION)
	if ([TDUtils iOSVersion] >=10.0) {
#ifdef _IOS_10_FUNCTIONALITY
        [self registeriOS10];
#endif
	} else {
        [self registeriOS8];
	}
	[[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

+ (void)registeriOS8 {
    #if !(IN_APP_EXTENSION)
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    #endif
}

+ (void)registeriOS10 {
    #if !(IN_APP_EXTENSION)
    UIApplication* app = [UIApplication sharedApplication];
    NSSet* categories = [[app currentUserNotificationSettings] categories];
    [app registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)categories:categories]];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              dispatch_async(dispatch_get_main_queue(), ^
                                             {
                                                 //td1- notify new authorization status
                                             });
                          }];
    #endif
}

@end
