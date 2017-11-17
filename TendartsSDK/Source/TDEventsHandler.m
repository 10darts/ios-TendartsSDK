
#import "TDEventsHandler.h"
#import "TDAPIService.h"
#import "TDConstants.h"

@implementation TDEventsHandler

+ (void)eventWithPushCode:(NSString *)aPushCode
               device:(NSString *)aDevice
                 kind:(NSString *)aKind
                value:(NSString *)aValue
                onSuccess:(TDOnSuccess)successHandler
                  onError:(TDOnError)errorHandler {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          aPushCode, @"push",
                          aDevice, @"device",
                          aKind, @"kind",
                          aValue, @"value",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    [TDAPIService eventsWithData: data
                             url: [[TDConstants instance] getEvents]
                          method: REQUEST_METHOD_POST
                onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                    [TendartsSDK logEventWithCategory: @"SDK"
                                                 type: @"Session sent"
                                           andMessage: json.description];
                    
                }
                  onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                      [TendartsSDK logEventWithCategory: @"SDK"
                                                   type: @"Error sending session"
                                             andMessage: json.description];
                  }];
}

@end
