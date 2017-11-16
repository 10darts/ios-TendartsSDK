
#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

@interface TDNotificationOpenHandler : NSObject

+ (void) notificationOpenWithNotificationId:(NSString *)aId
                                    handler:(TDOperationComplete)onComplete;

@end
