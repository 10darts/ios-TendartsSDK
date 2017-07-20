//
//  Constants.h
//  sdk
//
//  Created by Jorge Arimany on 5/7/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDConstants : NSObject
+(TDConstants *)instance;
@property (readonly) NSString *baseUrl;
@property (readonly) NSString *devices;
@property (readonly) NSString *device;
-(NSString*) getDeviceUrl:(NSString*) deviceCode;
-(NSString*) getDeviceAccessUrl:(NSString*) deviceCode;
-(NSString*) getNotificationReceivedUrl:(NSString*)notificationId;
-(NSString*) getNotificationClickedUrl:(NSString*)notificationId;
-(NSString*) getAllNotificationsRead;
-(NSString*) getLinkDevice;
@end
