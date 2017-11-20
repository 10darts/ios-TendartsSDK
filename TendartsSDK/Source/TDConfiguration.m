
#import "TDConfiguration.h"
#import "TDUtils.h"

@implementation TDConfiguration
NSString * const TD_API_KEY = @"TendartsAPIKey";
NSString * const TD_PUSH_TOKEN = @"TendartsPushToken";
NSString * const TD_PUSH_CODE = @"TendartsPushCode";
NSString * const TD_TOKEN_VERSION = @"TendartsTokenAndVersion";
NSString * const TD_USER_CODE = @"TendartsUserCode";
NSString * const TD_GEOSTATS = @"TendartsGeostats";
NSString * const TD_SHARED_GROUP = @"TendartsSharedGroup";

+ (NSUserDefaults* )getSharedUserDefaults: (NSString * _Nonnull )groupName {
	if ([TDUtils iOSVersion]>=10) {
		NSUserDefaults *defaults =
		[[NSUserDefaults alloc] initWithSuiteName:groupName];
		if (defaults) {
			return defaults;
		}
		NSLog(@"error: you should add correct group to your app and service extension group capability ");
	}
	return [NSUserDefaults standardUserDefaults];
}

+ (void)saveAPIKey:(NSString *)apiKey {
	@try
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:apiKey forKey:TD_API_KEY];
		[userDefaults synchronize];
	} @catch (NSException *exception) {
		NSLog(@"TD configuration: could not save api key: %@",exception.reason);
	}
}

+ (NSString *)getAPIKey {
	NSUserDefaults* userDefaults =  [NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey:TD_API_KEY];
}

+ (void)savePushToken:(NSString *)pushToken {
	@try
	{
		NSUserDefaults* userDefaults =  [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:pushToken forKey:TD_PUSH_TOKEN];
		[userDefaults synchronize];
	} @catch (NSException *exception) {
		NSLog(@"TD configuration: could not save api key: %@",exception.reason);
	}
}

+ (NSString *)getPushToken {
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey:TD_PUSH_TOKEN];
}

+ (void)saveTokenAndVersion: (NSString *)tokenAndVersion {
	@try
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:tokenAndVersion forKey:TD_TOKEN_VERSION];
		[userDefaults synchronize];
	} @catch (NSException *exception) {
		NSLog(@"TD configuration: could not save api key: %@",exception.reason);
	}
}

+ (NSString *)getTokenAndVersion {
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey: TD_TOKEN_VERSION];
}

+ (void)savePushCode:(NSString *)pushCode
          withApiKey:(NSString * _Nonnull)apiKey
        andGroupName:(NSString * _Nonnull)group {
	@try
	{
		//save shared combined
		NSUserDefaults* userDefaults = [TDConfiguration getSharedUserDefaults:group];
		[userDefaults setObject:[NSString stringWithFormat:@"%@%@",apiKey, pushCode] forKey:TD_PUSH_CODE];
		[userDefaults synchronize];
		//save local as it is
		userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:pushCode forKey:TD_PUSH_CODE];
		[userDefaults synchronize];
	} @catch (NSException *exception) {
		NSLog(@"TD configuration: could not save api key: %@",exception.reason);
	}
}

+ (NSString *)getPushCode {
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey: TD_PUSH_CODE];
}

+ (NSString *)getPushCodeWithApiKey:(NSString *)apiKey andGroupName:(NSString * _Nonnull)group {
	NSUserDefaults* userDefaults =  [TDConfiguration getSharedUserDefaults:group];
	NSString * combined = [userDefaults objectForKey:TD_PUSH_CODE];
	if (combined == nil) {
		return nil;
	}
	return [combined stringByReplacingOccurrencesOfString:apiKey withString:@""];
}

+ (void)saveUserCode: (NSString *)userCode {
	@try
	{
		NSUserDefaults* userDefaults =  [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:userCode forKey:TD_USER_CODE];
		[userDefaults synchronize];
	} @catch (NSException *exception) {
		NSLog(@"TD configuration: could not save api key: %@",exception.reason);
	}    
}

+ (NSString *)getUserCode {
	NSUserDefaults* userDefaults =  [NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey:TD_USER_CODE];
}

+ (void)saveLastGeostatsSent: (NSDate*)date {
	@try
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:date forKey:TD_GEOSTATS];
		[userDefaults synchronize];
	} @catch (NSException *exception) {
		NSLog(@"TD configuration: could not save api key: %@",exception.reason);
	}    
}

+ (NSDate*)getLastGeostatsSent {
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey:TD_GEOSTATS];    
}

+ (void)saveSharedGroup:( NSString * _Nonnull)group {
	@try
	{
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:group forKey:TD_SHARED_GROUP];
		[userDefaults synchronize];
	} @catch (NSException *exception) {
		NSLog(@"TD configuration: could not save api key: %@",exception.reason);
	}    
}

+ (NSString *)getSharedGroup {
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey:TD_SHARED_GROUP];

}

@end
