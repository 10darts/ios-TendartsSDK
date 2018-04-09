
#import <Foundation/Foundation.h>

@interface TDLog : NSObject

+ (void)writeStringToFile:(NSString *)aString;
+ (NSString *)readStringFromFile;

@end
