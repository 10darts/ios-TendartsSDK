
#import "TDAPIService.h"
#import "TDCommunications.h"
#import "TDSDKExtension.h"
#import "TDReachability.h"

NSString *const REQUEST_METHOD_POST = @"POST";
NSString *const REQUEST_METHOD_PATCH = @"PATCH";

@implementation TDAPIService

+ (void)notificationOpenWithData:(NSData *)aData
                             url:(NSString *)aUrl
                          method:(NSString *)aMethod
                onSuccessHandler:(TDCHandleSuccess)successHandler
                  onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)notificationReceivedWithData:(NSData *)aData
                                 url:(NSString *)aUrl
                              method:(NSString *)aMethod
                    onSuccessHandler:(TDCHandleSuccess)successHandler
                      onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)notificationReadedWithData:(NSData *)aData
                               url:(NSString *)aUrl
                            method:(NSString *)aMethod
                  onSuccessHandler:(TDCHandleSuccess)successHandler
                    onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)deviceWithData:(NSData *)aData
                   url:(NSString *)aUrl
                method:(NSString *)aMethod
      onSuccessHandler:(TDCHandleSuccess)successHandler
        onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)accessWithData:(NSData *)aData
                   url:(NSString *)aUrl
                method:(NSString *)aMethod
      onSuccessHandler:(TDCHandleSuccess)successHandler
        onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)personaWithData:(NSData *)aData
                    url:(NSString *)aUrl
                 method:(NSString *)aMethod
       onSuccessHandler:(TDCHandleSuccess)successHandler
         onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)keysWithData:(NSData *)aData
                 url:(NSString *)aUrl
              method:(NSString *)aMethod
    onSuccessHandler:(TDCHandleSuccess)successHandler
      onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)linkWithData:(NSData *)aData
                 url:(NSString *)aUrl
              method:(NSString *)aMethod
    onSuccessHandler:(TDCHandleSuccess)successHandler
      onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)eventsWithData:(NSData *)aData
                   url:(NSString *)aUrl
                method:(NSString *)aMethod
      onSuccessHandler:(TDCHandleSuccess)successHandler
        onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void)replySelectedWithData:(NSData *)aData
                          url:(NSString *)aUrl
                       method:(NSString *)aMethod
             onSuccessHandler:(TDCHandleSuccess)successHandler
               onErrorHandler:(TDCHandleError)errorHandler {
    [self senData: aData
              url: aUrl
           method: aMethod
 onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
     dispatch_async(dispatch_get_main_queue(), ^{
         if (successHandler != nil) {
             successHandler(json, data, statusCode);
         }
     });
 }
   onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (errorHandler != nil) {
               errorHandler(json, data, statusCode);
           }
       });
   }];
}

+ (void) senData:(NSData *)aData
             url:(NSString *)aUrl
          method:(NSString *)aMethod
onSuccessHandler:(TDCHandleSuccess)successHandler
  onErrorHandler:(TDCHandleError)errorHandler {
    TDRequest *request = [TDRequest new];
    request.data = aData;
    request.sUrl = aUrl;
    request.method = aMethod;
    request.inProcess = NO;
    
    NSTimeInterval today = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%f", today];
    
    request.requestId = timestamp;

    [self processRequestQueue:request OnSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successHandler != nil) {
                successHandler(json, data, statusCode);
            }
        });
    } onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorHandler != nil) {
                errorHandler(json, data, statusCode);
            }
        });
    }];
}

+ (void) processQueue {
    TDRequest* request = [TDRequestQueue nextRequest];
    if ([self isInternetNotAvailable] || !request) {
        [TDRequestQueue updateQueueStatus: NO];
        return;
    }
    if ([TDRequestQueue isQueueProcessing] || [[TDRequestQueue requests] count] <= 0) {
        return;
    }
    [TDRequestQueue updateQueueStatus: YES];
    [self processRequestQueue: request
             OnSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                 [TendartsSDK logEventWithCategory: @"TDQUEUE"
                                              type: @"Success processing TDQueue Request"
                                        andMessage: @""];
             } onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                 [TendartsSDK logEventWithCategory: @"TDQUEUE"
                                              type: @"Error processing TDQueue"
                                        andMessage: @""];
             }];
}

+ (void) processRequestQueue:(TDRequest *)request
            OnSuccessHandler:(TDCHandleSuccess)successHandler
              onErrorHandler:(TDCHandleError)errorHandler {
    if ([self isInternetNotAvailable] || [TDRequestQueue isQueueProcessing]) {
        request.inProcess = NO;
        [TDRequestQueue addRequest: request];
        [TDRequestQueue updateQueueStatus: NO];
        return;
    }
    [TDRequestQueue updateQueueStatus: YES];
    request.inProcess = YES;
    [TDCommunications sendRequest: request
                 onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [TDRequestQueue removeRequest: request.requestId];
                         [TDRequestQueue updateQueueStatus: NO];
                         [self processQueue];
                         [TendartsSDK logEventWithCategory: @"Request"
                                                      type: [NSString stringWithFormat:@"%@ - %@", request.requestId, request.sUrl]
                                                andMessage: @""];
                         if (successHandler != nil) {
                             successHandler(json, data, statusCode);
                         }
                     });
                 }
                   onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           request.inProcess = NO;
                           [TDRequestQueue addRequest: request];
                           [TDRequestQueue updateQueueStatus: YES];
                           if (errorHandler != nil) {
                               errorHandler(json, data, statusCode);
                           }
                       });
                   }];
}

+ (BOOL)isInternetNotAvailable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return (networkStatus == NotReachable);
}

@end
