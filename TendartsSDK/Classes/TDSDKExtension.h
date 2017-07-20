//
//  TDSDKExtension.h
//  sdk
//
//  Created by Jorge Arimany on 27/6/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TendartsSDK.h"


typedef void (^TDOperationComplete)(void);
@interface TendartsSDK ()
+(void)notifyNotificationReceived:(TDNotification *_Nonnull)notification;
+(void) onNotificationReceived:(TDNotification*_Nonnull)notification  withHandler: (TDOperationComplete _Nullable ) onComplete;
+(void) onNotificationOpened:(TDNotification*_Nonnull)notification  withHandler: (TDOperationComplete _Nullable ) onComplete;
+(void) logEventWithCategory:(NSString*_Nullable) category type:(NSString*_Nullable) type andMessage:(NSString *_Nullable) message;

@end



@interface TendartsSDK (extended)

@end
