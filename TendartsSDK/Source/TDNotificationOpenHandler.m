
#import "TDNotificationOpenHandler.h"
#import "TDAPIService.h"
#import "TDConfiguration.h"
#import "TDConstants.h"

@implementation TDNotificationOpenHandler

+ (void)notificationOpenWithNotificationId:(NSString *)aId
                                   handler:(TDOperationComplete)onComplete  {
    NSString *code = [TDConfiguration getPushCode];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [[TDConstants instance] getDeviceUrl: code], @"device",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject :dict
                                                   options: 0
                                                     error: nil];
    
    NSString *url = [[TDConstants instance] getNotificationClickedUrl: aId];
    
    [TDAPIService notificationOpenWithData: data
                                       url: url
                                    method: REQUEST_METHOD_PATCH
                          onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                              [TendartsSDK logEventWithCategory: @"NOTIFICATION"
                                                           type: @"notification opened sent ok"
                                                     andMessage: json.description];
                              if (onComplete != nil) {
                                  onComplete();
                              }
                          }
                            onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                                [TendartsSDK logEventWithCategory: @"NOTIFICATION"
                                                             type: @"notification opened send error"
                                                       andMessage: json.description];
                                if (onComplete != nil) {
                                    onComplete();
                                }
                            }];
}

@end
