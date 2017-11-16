
#import <Foundation/Foundation.h>

@interface TDConstants : NSObject
+ (TDConstants *)instance;
@property (readonly)NSString *baseUrl;
@property (readonly)NSString *devices;
@property (readonly)NSString *device;
- (NSString *)getDeviceUrl:(NSString *)deviceCode;
- (NSString *)getDeviceAccessUrl:(NSString *)deviceCode;
- (NSString *)getNotificationReceivedUrl:(NSString *)notificationId;
- (NSString *)getNotificationClickedUrl:(NSString *)notificationId;
- (NSString *)getAllNotificationsRead;
- (NSString *)getLinkDevice;
- (NSString *)getEvents;

#define URL_TYPE_PUSH @"pushes"
#define URL_TYPE_DEVICES @"devices"
#define URL_KIND_SESSION @"/api/v1/event_kinds/session/"
- (NSString *)buildUrlOfType:(NSString *)type andId:(NSString *)identifier;
@end
