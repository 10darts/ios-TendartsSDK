
#import <Foundation/Foundation.h>

@interface TDConfiguration : NSObject

+ (void) saveAPIKey:(NSString * _Nonnull) apiKey;
+ (NSString *_Nullable)getAPIKey;

+ (NSString *_Nullable)getPushToken;
+ (void)savePushToken:(NSString * _Nonnull) pushToken;

+ (NSString *_Nullable)getPushCodeWithApiKey:(NSString * _Nonnull) apiKey
                                andGroupName:(NSString * _Nonnull) group;
+ (NSString *_Nullable)getPushCode;
+ (void)savePushCode: (NSString * _Nonnull) pushCode
          withApiKey: (NSString * _Nonnull) apiKey
        andGroupName:(NSString * _Nonnull) group;

+ (NSString *_Nullable)getTokenAndVersion;
+ (void)saveTokenAndVersion:(NSString * _Nonnull) tokenAndVersion;

+ (NSString *_Nullable)getUserCode;
+ (void)saveUserCode:(NSString * _Nonnull) userCode;

+ (NSDate *_Nullable)getLastGeostatsSent;
+ (void)saveLastGeostatsSent:(NSDate * _Nonnull) date;

+ (NSString * _Nonnull)getSharedGroup;
+ (void)saveSharedGroup:(NSString * _Nonnull) group;

@end
