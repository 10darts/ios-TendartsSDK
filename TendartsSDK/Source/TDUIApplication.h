
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TDUIApplication : NSObject 

+ (void)installTenddartsOnApplication: (Class)application;

+ (void)showNotificationButtonsIfNeeded: (NSDictionary*)userInfo  content:(UNMutableNotificationContent *)content;

@end
