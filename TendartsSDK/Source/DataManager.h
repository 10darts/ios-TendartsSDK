
#import <Foundation/Foundation.h>

#import "Persona.h"
#import "Device.h"

static NSString * const kPersona = @"kPersona";
static NSString * const kDevice = @"kDevice";

OBJC_ROOT_CLASS

@interface DataManager

+ (void)saveObject:(NSObject *) object forKey:(NSString *) aKey;

+ (Persona *)persona;
+ (Device *)device;
+ (Device *)loadDevice;


@end

