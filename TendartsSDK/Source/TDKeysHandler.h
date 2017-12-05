//
//  TDKeysHandler.h
//  Tendarts
//
//  Created by Ruben Blanco on 5/12/17.
//  Copyright © 2017 10darts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

#ifndef OPERATION_HANDLERS_TD
#define OPERATION_HANDLERS_TD
typedef void (^TDOnSuccess)();
typedef void(^TDOnError)(NSString * _Nullable error);
#endif

@interface TDKeysHandler : NSObject

+ (void)keyDevice:(NSString *)aKey
             kind:(NSNumber *)aKind
            value:(NSString *)aValue
        onSuccess:(TDOnSuccess)successHandler
          onError:(TDOnError)errorHandler;

+ (void)keyPersona:(NSString *)aKey
              kind:(NSNumber *)aKind
             value:(NSString *)aValue
         onSuccess:(TDOnSuccess)successHandler
           onError:(TDOnError)errorHandler;
    
@end
