
#import <Foundation/Foundation.h>
#import "TendartsSDK.h"

typedef void (^TDOperationComplete)(void);
@interface TendartsSDK ()
+ (void)notifyNotificationReceived:(TDNotification * _Nonnull)notification;
+ (void)onNotificationReceived:(TDNotification* _Nonnull)notification  withHandler: (TDOperationComplete _Nullable )onComplete withApiKey: (NSString * _Nonnull)apiKey  andSharedGroup: (NSString * _Nonnull)group;
+ (void)actionSelected:(NSString * _Nonnull)selectedId;
+ (void)onNotificationOpened:(TDNotification* _Nonnull)notification  withHandler: (TDOperationComplete _Nullable )onComplete;
+ (void)logEventWithCategory:(NSString *_Nullable)category type:(NSString *_Nullable)type andMessage:(NSString *_Nullable)message;
+ (BOOL)onAppGoingToBackground;
@end

@interface TendartsSDK (extended)

@end
