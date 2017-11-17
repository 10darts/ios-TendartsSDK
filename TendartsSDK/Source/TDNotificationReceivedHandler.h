//
//  TDNotificationReceivedHandler.h
//  Tendarts
//
//  Created by Ruben Blanco on 16/11/17.
//  Copyright © 2017 10darts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDSDKExtension.h"

@interface TDNotificationReceivedHandler : NSObject

+ (void)notificationReceivedWithCode:(NSString *)aCode
                      notificationId:(NSString *)notificationId
                             handler:(TDOperationComplete)onComplete;

@end
