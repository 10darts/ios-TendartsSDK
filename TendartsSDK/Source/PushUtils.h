
#import <Foundation/Foundation.h>

@interface PushUtils : NSObject

+ (void) savePushToken:(NSString *)token inSharedGroup:(NSString *) group;

@end
