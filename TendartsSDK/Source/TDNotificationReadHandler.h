
#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

#ifndef OPERATION_HANDLERS_TD
#define OPERATION_HANDLERS_TD
typedef void (^TDOnSuccess)();
typedef void(^TDOnError)(NSString * _Nullable error);
#endif

@interface TDNotificationReadHandler : NSObject

+ (void)allNotificationReadedWithCode:(NSString *)aCode
                            onSuccess:(TDOnSuccess)successHandler
                              onError:(TDOnError)errorHandler;

+ (void)notificationReadedWithDeviceCode:(NSString *)aCode
                          notificationId:(NSString *)aId
                               onSuccess:(TDOnSuccess)successHandler
                                 onError:(TDOnError)errorHandler;

@end
