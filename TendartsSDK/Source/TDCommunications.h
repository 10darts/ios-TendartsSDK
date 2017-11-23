
#import <Foundation/Foundation.h>

#ifndef TD_COMMUNICATION_HANDLERS_DEFINED
#define TD_COMMUNICATION_HANDLERS_DEFINED
typedef void (^TDCHandleSuccess)(NSDictionary* json , NSData *data, NSInteger statusCode);
typedef void(^TDCHandleError)(NSDictionary* json , NSData *data, NSInteger statusCode);
#endif

@interface TDCommunications : NSObject

+ (void)sendData:(NSData *)data toURl:(NSString *)sUrl withMethod: (NSString *)method onSuccessHandler: (TDCHandleSuccess)successHandler onErrorHandler:(TDCHandleError)errorHandler;

@end
