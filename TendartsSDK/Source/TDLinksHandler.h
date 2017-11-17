//
//  TDLinksHandler.h
//  Tendarts
//
//  Created by Ruben Blanco on 16/11/17.
//  Copyright © 2017 10darts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

#ifndef OPERATION_HANDLERS_TD
#define OPERATION_HANDLERS_TD
typedef void (^TDOnSuccess)();
typedef void(^TDOnError)(NSString * _Nullable error);
#endif

@interface TDLinksHandler : NSObject

+ (void)linkWithCode:(NSString *)aCode
              userId:(NSString *)aString
           onSuccess:(TDOnSuccess)successHandler
             onError:(TDOnError)errorHandler;

@end
