
#import <Foundation/Foundation.h>

#import "TDRequest.h"

#ifndef TD_COMMUNICATION_HANDLERS_DEFINED
#define TD_COMMUNICATION_HANDLERS_DEFINED
typedef void (^TDCHandleSuccess)(NSDictionary* json , NSData *data, NSInteger statusCode);
typedef void(^TDCHandleError)(NSDictionary* json , NSData *data, NSInteger statusCode);
#endif

@interface TDCommunications : NSObject

+ (void)sendRequest:(TDRequest *)tdRequest
   onSuccessHandler:(TDCHandleSuccess)successHandler
     onErrorHandler:(TDCHandleError)errorHandler;

@end
