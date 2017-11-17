
#import "TDAPIService.h"
#import "TDCommunications.h"


NSString *const REQUEST_METHOD_POST = @"POST";
NSString *const REQUEST_METHOD_PATCH = @"PATCH";

@implementation TDAPIService

+ (void)notificationOpenWithData:(NSData *)aData
                             url:(NSString *)aUrl
                          method:(NSString *)aMethod
                onSuccessHandler:(TDCHandleSuccess)successHandler
                  onErrorHandler:(TDCHandleError)errorHandler {
    [TDCommunications sendData: aData
                         toURl: aUrl
                    withMethod: aMethod
              onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (successHandler != nil) {
                          successHandler(json, data, statusCode);
                      }
                  });
              }
                onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
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
    [TDCommunications sendData: aData
                         toURl: aUrl
                    withMethod: aMethod
              onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (successHandler != nil) {
                          successHandler(json, data, statusCode);
                      }
                  });
              }
                onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
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
    [TDCommunications sendData: aData
                         toURl: aUrl
                    withMethod: aMethod
              onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (successHandler != nil) {
                          successHandler(json, data, statusCode);
                      }
                  });
              }
                onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
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
    [TDCommunications sendData: aData
                         toURl: aUrl
                    withMethod: aMethod
              onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (successHandler != nil) {
                          successHandler(json, data, statusCode);
                      }
                  });
              }
                onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
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
    [TDCommunications sendData: aData
                         toURl: aUrl
                    withMethod: aMethod
              onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (successHandler != nil) {
                          successHandler(json, data, statusCode);
                      }
                  });
              }
                onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (errorHandler != nil) {
                            errorHandler(json, data, statusCode);
                        }
                    });
                }];
}


@end
