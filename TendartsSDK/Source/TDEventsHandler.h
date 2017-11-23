
#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

#ifndef OPERATION_HANDLERS_TD
#define OPERATION_HANDLERS_TD
typedef void (^TDOnSuccess)();
typedef void(^TDOnError)(NSString * _Nullable error);
#endif

@interface TDEventsHandler : NSObject

+ (void)eventWithPushCode:(NSString *)aPushCode
               device:(NSString *)aDevice
                 kind:(NSString *)aKind
                value:(NSString *)aValue
                onSuccess:(TDOnSuccess)successHandler
                  onError:(TDOnError)errorHandler;

@end
