
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#ifdef _IOS_10_FUNCTIONALITY
#import <UserNotifications/UserNotifications.h>
#endif

@interface TDUIApplication : NSObject 

+ (void)installTenddartsOnApplication: (Class)application;

#ifdef _IOS_10_FUNCTIONALITY
+ (void)showNotificationButtonsIfNeeded:(NSDictionary *)userInfo content:(UNMutableNotificationContent *)content;
#endif

@end
