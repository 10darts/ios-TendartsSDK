
#import "TDLog.h"

@implementation TDLog

+ (void) writeStringToFile:(NSString *)aString{
    NSString* text = [self readStringFromFile];
    
    if (text) {
        [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%@ \r\r %@ - %@ \r\r ", text, [NSDate date], aString] forKey: @"test"];
    } else {        [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%@ - %@", [NSDate date], aString] forKey: @"test"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)readStringFromFile{
    NSString* text = [[NSUserDefaults standardUserDefaults] stringForKey: @"test"];
    return text;
}

@end
