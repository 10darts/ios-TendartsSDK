
#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

#ifndef OPERATION_HANDLERS_TD
#define OPERATION_HANDLERS_TD
typedef void (^TDOnSuccess)();
typedef void(^TDOnError)(NSString * _Nullable error);
#endif

@interface TDPersonaHandler : NSObject

+ (void)personaWithUrl:(NSString *)aUrl
                 email:(NSString *)aEmail
             firstName:(NSString *)aFirstName
              lastName:(NSString *)aLastName
              password:(NSString *)aPassword
             onSuccess:(TDOnSuccess)successHandler
               onError:(TDOnError)errorHandler;

@end
