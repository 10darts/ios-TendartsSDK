
#import "DataManager.h"

@implementation DataManager

+ (void)saveObject:(NSObject *) object forKey:(NSString *) aKey {
    NSData *encodedObject = [self encodeObject: object];
    NSUserDefaults *defaults = [self userDefaults];
    [defaults setObject: encodedObject forKey: aKey];
    [defaults synchronize];
}

#pragma mark - Persona

+ (Persona *)persona {
    Persona *persona = [self loadPersona];
    if (persona) {
        return persona;
    }
    return [Persona new];
}

- (Persona *)loadPersona {
    NSData *encodedObject = [self dataForKey: kPersona];
    Persona *object = [self unarchiveObject: encodedObject];
    return object;
}

#pragma mark - Device

+ (Device *)device {
    Device *device = [self loadDevice];
    if (device) {
        return device;
    }
    return [Device new];
}

+ (Device *)loadDevice {
    NSData *encodedObject = [self dataForKey: kDevice];
    Device *object = [self unarchiveObject: encodedObject];
    return object;
}

#pragma mark - Utils

- (nullable id)unarchiveObject:(NSData *) encodedObject {
    return [NSKeyedUnarchiver unarchiveObjectWithData: encodedObject];
}

- (NSData *)encodeObject:(NSObject *) object {
    return [NSKeyedArchiver archivedDataWithRootObject: object];
}

- (NSUserDefaults *)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}

- (NSData *)dataForKey:(NSString *) aKey {
    return [[self userDefaults] objectForKey: aKey];
}


@end

