
#import "TDDeviceHandler.h"
#import "TDAPIService.h"
#import "TDConfiguration.h"
#import "TDConstants.h"

@implementation TDDeviceHandler

+ (void)deviceToken:(NSString *)aToken
           language:(NSString *)aLanguage
            version:(NSString *)aVersion
                sdk:(NSString *)aSDK
              model:(NSString *)aModel
           platform:(NSString *)aPlatform
           location:(NSDictionary *)aLocation
           disabled:(BOOL)aDisabled
              group:(NSString *)aGroup
          onSuccess:(TDOnSuccess)successHandler {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          aToken,@"token",
                          aPlatform,@"platform",
                          aLanguage,@"language",
                          [NSNumber numberWithBool: aDisabled],@"disabled",
                          aVersion,@"version",
                          aSDK,@"sdk",
                          aModel,@"model",
                          aLocation,@"position",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    NSString *tokenAndVersion = [aToken stringByAppendingString: aVersion];
    NSString *code = [TDConfiguration getPushCode];
    NSString *method = REQUEST_METHOD_POST;
    NSString *url =  [[TDConstants instance] devices];
    
    if (aPlatform == nil || aToken == nil ) {
        return;
    }
    
    if (code != nil) {
        url = [[TDConstants instance] getDeviceUrl:code];
        method = REQUEST_METHOD_PATCH;
    }
    
    [TDAPIService deviceWithData: data
                             url: url
                          method: method
                onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                    [TendartsSDK logEventWithCategory: @"PUSH"
                                                 type: @"token_sent_ok"
                                           andMessage: json.description];
                    
                    NSString * code = [json objectForKey: @"code"];
                    if (code != nil) {
                        [TDConfiguration savePushCode: code
                                           withApiKey: [TDConfiguration getAPIKey]
                                         andGroupName: aGroup];
                        if (statusCode == 201) {
                            [TDConfiguration saveTokenAndVersion: tokenAndVersion];
                        }
                    }
                    
                    NSString *persona = [json objectForKey:@"persona"];
                    if (persona != nil) {
                        [TDConfiguration saveUserCode: persona];
                    }
                    if (successHandler) {
                        successHandler();
                    }
                }
                  onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                      [TendartsSDK logEventWithCategory: @"PUSH"
                                                   type: @"Error sending token"
                                             andMessage: json.description];
                  }];
    
    
}

+ (void)location:(NSDictionary *)aLocation
        accuracy:(NSString *)aAccuracy
        pushCode:(NSString *)aPushCode {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          aLocation, @"position",
                          aAccuracy, @"debug_info",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    NSString *method = REQUEST_METHOD_PATCH;
    NSString *url = [[TDConstants instance] getDeviceUrl: aPushCode];
    
    [TDAPIService deviceWithData: data
                             url: url
                          method: method
                onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                    [TDConfiguration saveLastGeostatsSent: [NSDate date]];
                    [TendartsSDK logEventWithCategory: @"DEVICE"
                                                 type: @"location succesfully sent"
                                           andMessage: json.description];
                }
                  onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                      [TendartsSDK logEventWithCategory: @"DEVICE"
                                                   type: @"Error sending location"
                                             andMessage: json.description];
                  }];
}

@end
