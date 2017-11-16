
#import "TDConstants.h"

@implementation TDConstants

- (TDConstants *)init {
	_baseUrl = @"https://10darts.com";
	_device = [_baseUrl stringByAppendingString: @"/api/v1/devices/%@/"];
	_devices = [_baseUrl stringByAppendingString:  @"/api/v1/devices/"];
	
	return self;
}
static TDConstants * _instance = nil;

+ (TDConstants *)instance {
	if (_instance == nil) {
		_instance = [[TDConstants alloc]init];
	}
	return _instance;    
}

- (NSString *)getDeviceUrl:(NSString *)deviceCode {
	return [NSString stringWithFormat:_device,deviceCode];
}

- (NSString *)getDeviceAccessUrl:(NSString *)deviceCode {
	return [NSString stringWithFormat:@"%@/api/v1/devices/%@/access/",_baseUrl,deviceCode];
}

- (NSString *)getNotificationReceivedUrl:(NSString *)notificationId {
	return [NSString stringWithFormat:@"%@/api/v1/pushes/%@/received/",_baseUrl,notificationId];

}

- (NSString *)getNotificationClickedUrl:(NSString *)notificationId {
	return [NSString stringWithFormat:@"%@/api/v1/pushes/%@/follow/",_baseUrl,notificationId];    
}

- (NSString *)getAllNotificationsRead {
	return [NSString stringWithFormat:@"%@/api/v1/pushes/all_read/",_baseUrl];    
}

- (NSString *)getLinkDevice {
	return [NSString stringWithFormat:@"%@/api/v1/devices/links/",_baseUrl];    
}

- (NSString *)getEvents {
	return [NSString stringWithFormat:@"%@/api/v1/events/",_baseUrl];

}

- (NSString *)buildUrlOfType:(NSString *)type andId:(NSString *)identifier {
	return [NSString stringWithFormat:@"/api/v1/%@/%@/", type, identifier];
}

@end
