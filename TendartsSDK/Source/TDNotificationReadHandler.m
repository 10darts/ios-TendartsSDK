
#import "TDNotificationReadHandler.h"
#import "TDAPIService.h"
#import "TDConstants.h"

@implementation TDNotificationReadHandler

+ (void)notificationReadedWithCode:(NSString *)aCode
                         onSuccess:(TDOnSuccess)successHandler
                           onError:(TDOnError)errorHandler {
    NSString *deviceURI = [[TDConstants instance] getDeviceUrl: aCode];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          deviceURI, @"device",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    NSString *url = [[TDConstants instance] getAllNotificationsRead];
    
    [TDAPIService notificationReceivedWithData: data
                                           url: url
                                        method: REQUEST_METHOD_PATCH
                              onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                                  [TendartsSDK logEventWithCategory: @"USER"
                                                               type: @"all notifications read sent ok"
                                                         andMessage: json.description];
                                  if (successHandler) {
                                      successHandler();
                                  }
                              }
                                onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                                    [TendartsSDK logEventWithCategory: @"USER"
                                                                 type: @"all notifications read error"
                                                           andMessage: json.description];
                                    if (errorHandler) {
                                        errorHandler( [json description]);
                                    }
                                }];
}

@end
