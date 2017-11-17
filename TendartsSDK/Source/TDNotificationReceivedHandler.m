
#import "TDNotificationReceivedHandler.h"
#import "TDAPIService.h"
#import "TDUtils.h"
#import "TDConstants.h"

@implementation TDNotificationReceivedHandler


+ (void)notificationReceivedWithCode:(NSString *)aCode
                      notificationId:(NSString *)notificationId
                             handler:(TDOperationComplete)onComplete {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [TDUtils getDeviceURI: aCode], @"device",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    NSString *url = [[TDConstants instance] getNotificationReceivedUrl: notificationId];
    
    [TDAPIService notificationReceivedWithData: data
                                           url: url
                                        method: REQUEST_METHOD_PATCH
                              onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                                  [TendartsSDK logEventWithCategory: @"NOTIFICATION"
                                                               type: @"notification received sent ok"
                                                         andMessage: json.description];
                                  if (onComplete != nil) {
                                      onComplete();
                                  }
                              }
                                onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                                             [TendartsSDK logEventWithCategory: @"NOTIFICATION"
                                                                          type: @"notification received send error"
                                                                    andMessage: json.description];
                                    if (onComplete != nil) {
                                        onComplete();
                                    }
                                }];
}

@end
