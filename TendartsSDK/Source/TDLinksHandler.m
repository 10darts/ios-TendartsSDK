
#import "TDLinksHandler.h"
#import "TDAPIService.h"
#import "TDUtils.h"
#import "TDConstants.h"
#import "TDConfiguration.h"

@implementation TDLinksHandler

+ (void)linkWithCode:(NSString *)aCode
              userId:(NSString *)aString
           onSuccess:(TDOnSuccess)successHandler
             onError:(TDOnError)errorHandler {
    NSString *device = [TDUtils getDeviceURI: aCode];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          device, @"device",
                          aString, @"client_data",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    NSString *url = [[TDConstants instance] getLinkDevice];
    
    [TDAPIService linkWithData: data
                           url: url
                        method: REQUEST_METHOD_POST
              onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                  NSString *persona = [json objectForKey:@"persona"];
                  if (persona != nil) {
                      [TDConfiguration saveUserCode: persona];
                  }
                  [TendartsSDK logEventWithCategory: @"USER"
                                               type: @"link device sent ok"
                                         andMessage: json.description];
                  if (successHandler) {
                      successHandler();
                  }
              }
                onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                    if (errorHandler) {
                        errorHandler( [json description]);
                    }
                    [TendartsSDK logEventWithCategory: @"USER"
                                                 type: @"link device send error"
                                           andMessage: json.description];
                }];
}

@end
