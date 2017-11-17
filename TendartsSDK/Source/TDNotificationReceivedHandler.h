
#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

@interface TDNotificationReceivedHandler : NSObject

+ (void)notificationReceivedWithCode:(NSString *)aCode
                      notificationId:(NSString *)notificationId
                             handler:(TDOperationComplete)onComplete;

@end
