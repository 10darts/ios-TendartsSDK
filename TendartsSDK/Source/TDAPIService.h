
#import <Foundation/Foundation.h>

#import "TDRequest.h"
#import "TDRequestQueue.h"

#ifndef TD_COMMUNICATION_HANDLERS_DEFINED
#define TD_COMMUNICATION_HANDLERS_DEFINED
typedef void (^TDCHandleSuccess)(NSDictionary* json , NSData *data, NSInteger statusCode);
typedef void(^TDCHandleError)(NSDictionary* json , NSData *data, NSInteger statusCode);
#endif

FOUNDATION_EXPORT NSString *const REQUEST_METHOD_POST;
FOUNDATION_EXPORT NSString *const REQUEST_METHOD_PATCH;

@interface TDAPIService : NSObject

+ (void)notificationOpenWithData:(NSData *)aData
                             url:(NSString *)aUrl
                          method:(NSString *)aMethod
                onSuccessHandler:(TDCHandleSuccess)successHandler
                  onErrorHandler:(TDCHandleError)errorHandler;

+ (void)notificationReceivedWithData:(NSData *)aData
                                 url:(NSString *)aUrl
                              method:(NSString *)aMethod
                    onSuccessHandler:(TDCHandleSuccess)successHandler
                      onErrorHandler:(TDCHandleError)errorHandler;

+ (void)notificationReadedWithData:(NSData *)aData
                               url:(NSString *)aUrl
                            method:(NSString *)aMethod
                  onSuccessHandler:(TDCHandleSuccess)successHandler
                    onErrorHandler:(TDCHandleError)errorHandler;

+ (void)deviceWithData:(NSData *)aData
                   url:(NSString *)aUrl
                method:(NSString *)aMethod
      onSuccessHandler:(TDCHandleSuccess)successHandler
        onErrorHandler:(TDCHandleError)errorHandler;

+ (void)accessWithData:(NSData *)aData
                   url:(NSString *)aUrl
                method:(NSString *)aMethod
      onSuccessHandler:(TDCHandleSuccess)successHandler
        onErrorHandler:(TDCHandleError)errorHandler;

+ (void)personaWithData:(NSData *)aData
                    url:(NSString *)aUrl
                 method:(NSString *)aMethod
       onSuccessHandler:(TDCHandleSuccess)successHandler
         onErrorHandler:(TDCHandleError)errorHandler;

+ (void)keysWithData:(NSData *)aData
                 url:(NSString *)aUrl
              method:(NSString *)aMethod
    onSuccessHandler:(TDCHandleSuccess)successHandler
      onErrorHandler:(TDCHandleError)errorHandler;

+ (void)linkWithData:(NSData *)aData
                 url:(NSString *)aUrl
              method:(NSString *)aMethod
    onSuccessHandler:(TDCHandleSuccess)successHandler
      onErrorHandler:(TDCHandleError)errorHandler;

+ (void)eventsWithData:(NSData *)aData
                   url:(NSString *)aUrl
                method:(NSString *)aMethod
      onSuccessHandler:(TDCHandleSuccess)successHandler
        onErrorHandler:(TDCHandleError)errorHandler;

+ (void)replySelectedWithData:(NSData *)aData
                          url:(NSString *)aUrl
                       method:(NSString *)aMethod
             onSuccessHandler:(TDCHandleSuccess)successHandler
               onErrorHandler:(TDCHandleError)errorHandler;

+ (void) processQueue;

+ (void) processRequestQueue:(TDRequest *)request
            OnSuccessHandler:(TDCHandleSuccess)successHandler
              onErrorHandler:(TDCHandleError)errorHandler;

+ (BOOL)isInternetNotAvailable;

@end
