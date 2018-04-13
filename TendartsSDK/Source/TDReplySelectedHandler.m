
#import "TDReplySelectedHandler.h"
#import "TDAPIService.h"
#import "TDConstants.h"

@implementation TDReplySelectedHandler

+ (void)replySelected:(NSString *)selectedId
               device:(NSString *)aDevice
            onSuccess:(TDOnSuccess)successHandler
              onError:(TDOnError)errorHandler {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          aDevice, @"device",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    [TDAPIService replySelectedWithData: data
                                    url: [[TDConstants instance] getReplies: selectedId]
                                 method: REQUEST_METHOD_POST
                       onSuccessHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                           [TendartsSDK logEventWithCategory: @"SDK"
                                                        type: @"Reply selected"
                                                  andMessage: json.description];
                           
                       }
                         onErrorHandler: ^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                             [TendartsSDK logEventWithCategory: @"SDK"
                                                          type: @"Error sending reply selected"
                                                    andMessage: json.description];
                         }];
}

@end
