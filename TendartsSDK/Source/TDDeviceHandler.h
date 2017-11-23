
#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

#ifndef OPERATION_HANDLERS_TD
#define OPERATION_HANDLERS_TD
typedef void (^TDOnSuccess)();
typedef void(^TDOnError)(NSString * _Nullable error);
#endif

@interface TDDeviceHandler : NSObject

+ (void)deviceToken:(NSString *)aToken
           language:(NSString *)aLanguage
            version:(NSString *)aVersion
                sdk:(NSString *)aSDK
              model:(NSString *)aModel
           platform:(NSString *)aPlatform
           location:(NSDictionary *)aLocation
           disabled:(BOOL)aDisabled
              group:(NSString *)aGroup
          onSuccess:(TDOnSuccess)successHandler;

+ (void)location:(NSDictionary *)aLocation
        accuracy:(NSString *)aAccuracy
        pushCode:(NSString *)aPushCode;

@end
