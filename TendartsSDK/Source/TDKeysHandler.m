
#import "TDKeysHandler.h"
#import "TDAPIService.h"
#import "TDConstants.h"
#import "TDConfiguration.h"
#import "TDConstants.h"

@implementation TDKeysHandler

+ (void)keyDevice:(NSString *)aKey
             kind:(NSNumber *)aKind
            value:(NSString *)aValue
        onSuccess:(TDOnSuccess)successHandler
          onError:(TDOnError)errorHandler {
    if (aKey == nil || aKind == nil || aValue == nil) {
        [TendartsSDK logEventWithCategory: @"KEYS"
                                     type: @"keys send error"
                               andMessage: @"Set keys, a type and a value"];
        return;
    }
    
    NSString *pushCode = [TDConfiguration getPushCode];
    NSString *device = [[TDConstants instance] getDeviceUrl: pushCode];
    
    NSDictionary *keyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             aKey, @"label",
                             nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          keyDict, @"key",
                          aKind, @"kind",
                          aValue, @"value",
                          device, @"device",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    NSString *url = [[TDConstants instance] getDeviceKeys];
    
    [self sendKeysData: data
                   url: url
                method: REQUEST_METHOD_POST
      onSuccessHandler: ^{
          if (successHandler) {
              successHandler();
          }
      }
        onErrorHandler: ^(NSString * _Nullable error) {
            if (errorHandler) {
                errorHandler(error);
            }
        }];
}

+ (void)keyPersona:(NSString *)aKey
              kind:(NSNumber *)aKind
             value:(NSString *)aValue
         onSuccess:(TDOnSuccess)successHandler
           onError:(TDOnError)errorHandler {
    if (aKey == nil || aKind == nil || aValue == nil) {
        [TendartsSDK logEventWithCategory: @"KEYS"
                                     type: @"keys send error"
                               andMessage: @"Set keys, a type and a value"];
        return;
    }
    
    NSString *persona = [TDConfiguration getUserCode];
    if (persona.length < 3) {
        if (errorHandler) {
            errorHandler(@"the user should be already registered");
        }
        return;
    }
    
    NSDictionary *keyDict = @{@"label": aKey};
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          keyDict, @"key",
                          aKind, @"kind",
                          aValue, @"value",
                          persona, @"persona",
                          nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    NSString *url = [[TDConstants instance] getPersonaKeys];
    [self sendKeysData: data
                   url: url
                method: REQUEST_METHOD_POST
      onSuccessHandler: ^{
          if (successHandler) {
              successHandler();
          }
      }
        onErrorHandler: ^(NSString * _Nullable error) {
          if (errorHandler) {
              errorHandler(error);
          }
      }];
}

+ (void)sendKeysData:(NSData *)aData
                 url:(NSString *)aUrl
              method:(NSString *)aMethod
    onSuccessHandler:(TDOnSuccess)successHandler
      onErrorHandler:(TDOnError)errorHandler {
    [TDAPIService keysWithData: aData
                           url: aUrl
                        method: aMethod
              onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                  [TendartsSDK logEventWithCategory: @"KEYS"
                                               type: @"keys sent ok"
                                         andMessage: json.description];
                  if (successHandler) {
                      successHandler();
                  }
              } onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                  [TendartsSDK logEventWithCategory: @"KEYS"
                                               type: @"keys send error"
                                         andMessage: json.description];
                  if (errorHandler) {
                      errorHandler([json description]);
                  }
              }];
}

@end
