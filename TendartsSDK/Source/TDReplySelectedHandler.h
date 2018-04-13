
#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

#ifndef OPERATION_HANDLERS_TD
#define OPERATION_HANDLERS_TD
typedef void (^TDOnSuccess)();
typedef void(^TDOnError)(NSString * _Nullable error);
#endif

@interface TDReplySelectedHandler : NSObject

+ (void)replySelected:(NSString *)selectedId
               device:(NSString *)aDevice
            onSuccess:(TDOnSuccess)successHandler
              onError:(TDOnError)errorHandler;

@end
