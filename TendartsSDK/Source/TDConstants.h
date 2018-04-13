
#import <Foundation/Foundation.h>

@interface TDConstants : NSObject

#define URL_TYPE_PUSH @"pushes"
#define URL_TYPE_DEVICES @"devices"
#define URL_KIND_SESSION @"/api/v1/event_kinds/session/"

@property (readonly)NSString *baseUrl;
@property (readonly)NSString *devices;
@property (readonly)NSString *device;

+ (TDConstants *)instance;
- (NSString *)getDeviceUrl:(NSString *)deviceCode;
- (NSString *)getDeviceAccessUrl:(NSString *)deviceCode;
- (NSString *)personasUrl:(NSString *)aCode;
- (NSString *)getNotificationReceivedUrl:(NSString *)notificationId;
- (NSString *)getNotificationClickedUrl:(NSString *)notificationId;
- (NSString *)getNotificationRead:(NSString *)notificationId;
- (NSString *)getAllNotificationsRead;
- (NSString *)getLinkDevice;
- (NSString *)getDeviceKeys;
- (NSString *)getPersonaKeys;
- (NSString *)getEvents;
- (NSString *)getReplies:(NSString *)selectedId;
- (NSString *)buildUrlOfType:(NSString *)type andId:(NSString *)identifier;

@end
