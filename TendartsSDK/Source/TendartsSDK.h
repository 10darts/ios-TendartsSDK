
#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#define _IOS_10_FUNCTIONALITY
#import <UserNotifications/UserNotifications.h>
#endif

#import "TDNotification.h"

#ifndef OPERATION_HANDLERS_TD
#define OPERATION_HANDLERS_TD
typedef void (^TDOnSuccess)();
typedef void(^TDOnError)(NSString* _Nullable error);
#endif

@protocol TendartsDelegate <NSObject>

@optional
- (void) onNotificationReceived: (TDNotification* _Nonnull) notification;
- (void) onNotificationOpened: (TDNotification* _Nonnull) notification;
- (void) onLogEventWithCategory:(NSString*_Nullable) category type:(NSString*_Nullable) type andMessage:(NSString *_Nullable) message;
@end

@interface TendartsSDK : NSObject


+ (void) setDelegate:(_Nullable id  <TendartsDelegate>)delegate;
+ (_Nullable id<TendartsDelegate>) getDelegate;

+ (id _Nonnull )initTendartsUsingLaunchOptions:(NSDictionary*_Nullable)launchOptions withAPIKey: (NSString* _Nonnull) apiKey andConfig: (NSDictionary*_Nullable)config andSharedGroup:(NSString* _Nonnull) group ;

+ (void) resetBadge: (TDOnSuccess _Nullable ) successHandler onError: (TDOnError _Nullable ) errorHandler;

+ (void) linkDeviceWithUserIdentifier:(NSString* _Nonnull)userId
						   onSuccess: (TDOnSuccess _Nullable ) successHandler
							 onError: (TDOnError _Nullable ) errorHandler;


+ (void) ModifyUserEmail:(NSString*_Nullable)email
			  firstName:(NSString*_Nullable)firstName
			   lastName:(NSString*_Nullable)lastName
			   password:(NSString*_Nullable)password
			  onSuccess: (TDOnSuccess _Nullable ) successHandler
				onError: (TDOnError _Nullable ) errorHandler;


+ (TendartsSDK* _Nonnull) instance;

#ifdef _IOS_10_FUNCTIONALITY
+ (void) didReceiveNotificationRequest:(UNNotificationRequest *_Nullable)request withContentHandler:(void (^_Nullable)(UNNotificationContent * _Nonnull))contentHandler withApiKey: (NSString* _Nonnull) apiKey andSharedGroup: (NSString* _Nonnull) group;
+ (void) serviceExtensionTimeWillExpire:(UNNotificationContent *_Nullable)content withContentHandler:(void (^_Nullable)(UNNotificationContent * _Nonnull))contentHandler;
#endif

@end
