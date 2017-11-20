
#import "PushUtils.h"
#import <sys/utsname.h>
#import "TDConstants.h"
#import "TDUtils.h"
#import "TDConfiguration.h"
#import "TDDeviceHandler.h"

#import "DataManager.h"

@implementation PushUtils

+ (void)savePushToken:(NSString *)token inSharedGroup:(NSString *)group {
	[TDConfiguration savePushToken: token];
    
    [self updateAPIDeviceToken: token inSharedGroup: group];
}

+ (void) updateAPIDeviceToken:(NSString *)token inSharedGroup:(NSString *)group{
    NSString *language = [TDUtils currentLanguage];
    NSString *bundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [NSString stringWithFormat:@"%@", bundle];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *model = [NSString stringWithCString: systemInfo.machine
                                          encoding: NSUTF8StringEncoding];
    
    NSString *platform = [TDUtils platform];
    NSDictionary *position = [TDUtils location];
    NSString *sdk = [TDUtils sdkVersion];
    BOOL disabled = [TDUtils platform];
    
    Device *newDevice = [Device alloc];
    
    [newDevice configureDevice: token
                      platform: platform
                         model: model
                       version: version
                           sdk: sdk
                      language: language
                      position: position
                       persona: DataManager.persona
                      disabled: disabled];
    
    if (![newDevice isUpdateNeeded: DataManager.device]) {
        return;
    }
    
    [TDDeviceHandler deviceToken: token
                        language: language
                         version: version
                             sdk: sdk
                           model: model
                        platform: platform
                        location: position
                        disabled: disabled
                           group: group
                       onSuccess:^{
                           [DataManager saveObject: newDevice
                                            forKey: kDevice];
                       }];
}

@end
