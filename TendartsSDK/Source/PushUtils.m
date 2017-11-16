
#import "PushUtils.h"
#import <sys/utsname.h> 
#import "TDCommunications.h"
#import "TDConstants.h"
#import "TDUtils.h"
#import "TDConfiguration.h"
#import "LocationUtils.h"
#import "TDSDKExtension.h"

@implementation PushUtils

+ (void)savePushToken:(NSString *)token inSharedGroup:(NSString *)group {
	[TDConfiguration savePushToken:token];
    
	NSString *language = [TDUtils getCurrentLanguage];
	NSString * version = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
	struct utsname systemInfo;
	uname(&systemInfo);
    
	NSString * model = [NSString stringWithCString:systemInfo.machine  encoding:NSUTF8StringEncoding];
	NSString * platform = @"ios";
    
#if DEBUG
	platform = @"ios_sandbox";
#endif

	NSDictionary *loc =[LocationUtils getLocationData];
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  token, @"token",
						  platform, @"platform",
						  language,@"language",
						  version,@"version",
						  model, @"model",
						  loc,@"position",
						  nil];
	
	NSData* data = [NSJSONSerialization dataWithJSONObject: dict options:0 error:nil];
	NSString * tokenAndVersion = [token stringByAppendingString: version];
	NSString * saved = [TDConfiguration getTokenAndVersion];
	NSString * code = [TDConfiguration getPushCode];
	
	if (code == nil ||! [tokenAndVersion isEqualToString:saved]) {
		NSString * method = @"POST";
		NSString *url =  [[TDConstants instance] devices];
		if (code != nil) {
			url = [[TDConstants instance] getDeviceUrl:code];
			method = @"PATCH";
		}
		
        [TDCommunications sendData:data toURl:url withMethod:method
                  onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                      [TendartsSDK logEventWithCategory:@"PUSH" type:@"token_sent_ok" andMessage:json.description];
                      NSString * code = [json objectForKey:@"code"];
                      if (code != nil) {
                          [TDConfiguration savePushCode:code withApiKey:[TDConfiguration getAPIKey] andGroupName:group];
                          if (statusCode == 201) {
                              [TDConfiguration saveTokenAndVersion:tokenAndVersion];
                          }
                      }
                      NSString *persona = [json objectForKey:@"persona"];
                      if (persona != nil) {
                          [TDConfiguration saveUserCode:persona];
                      }
                      NSLog(@"SDK saved token: %@", json);
                  }
                    onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                        [TendartsSDK logEventWithCategory:@"PUSH" type:@"Error sending token" andMessage:json.description];
                        NSLog(@"SDK error saving token %@", json);
                    }];
	}    
}

@end
