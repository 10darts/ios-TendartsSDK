
#import "TDPersonaHandler.h"
#import "TDAPIService.h"
#import "TDConfiguration.h"
#import "TendartsSDK.h"

@implementation TDPersonaHandler

+ (void)personaWithUrl:(NSString *)aUrl
                 email:(NSString *)aEmail
             firstName:(NSString *)aFirstName
              lastName:(NSString *)aLastName
              password:(NSString *)aPassword
             onSuccess:(TDOnSuccess)successHandler
               onError:(TDOnError)errorHandler {
    NSString *code = [TDConfiguration getPushCode];
    if (code.length < 3) {
        if (errorHandler) {
            errorHandler(@"device not yet registered");
        }
        return;
    }
    
    NSString *userCode = [TDConfiguration getUserCode];
    if (userCode.length < 3) {
        if (errorHandler) {
            errorHandler(@"the user should be already registered");
        }
        return;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 aEmail, @"email",
                                 nil];
    
    if (aFirstName.length > 0) {
        [dict setObject: aFirstName forKey: @"first_name"];
    }
    
    if (aLastName.length > 0) {
        [dict setObject: aLastName forKey: @"last_name"];
    }
    
    if (aPassword.length > 0) {
        [dict setObject: aPassword forKey: @"password"];
    }
    
    [dict setObject: userCode forKey: @"persona"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    [TDAPIService personaWithData: data
                              url: aUrl
                           method: REQUEST_METHOD_PATCH
                 onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                     [TendartsSDK logEventWithCategory: @"USER"
                                                  type: @"modify user sent ok"
                                            andMessage: json.description];
                     if (successHandler) {
                         successHandler();
                     }
                 }
                   onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                       [TendartsSDK logEventWithCategory: @"USER"
                                                    type: @"modify user send error"
                                              andMessage: json.description];
                       if (errorHandler) {
                           errorHandler( [json description]);
                       }
                   }];
}

@end
