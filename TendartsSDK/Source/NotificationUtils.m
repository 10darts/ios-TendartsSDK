
#import "TendartsSDK.h"
#import "NotificationUtils.h"
#import <UIKit/UIKit.h>

#ifdef _IOS_10_FUNCTIONALITY
#import <UserNotifications/UserNotifications.h>
#endif
#import "TDUtils.h"

@implementation NotificationUtils

+(void) registerRemoteNotifications {
    //todo: save if already registered (dont ask twice)
    if ([TDUtils iOSVersion] >=10.0) {
#ifdef _IOS_10_FUNCTIONALITY
#if !(IN_APP_EXTENSION)
        UIApplication* app = [UIApplication sharedApplication];
        NSSet* categories = [[app currentUserNotificationSettings] categories];
        [app registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) categories:categories]];
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  dispatch_async(dispatch_get_main_queue(), ^
                                                 {
                                                     //td1- notify new authorization status
                                                 });
                                  
                              }];
#endif
#endif
    } else {
#if !(IN_APP_EXTENSION)
        // ios 8
        UIUserNotificationType types = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    }
    id backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
#if !(IN_APP_EXTENSION)
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

@end
