
#import "Device.h"

static NSString * const kDeviceToken = @"kDeviceToken";
static NSString * const kDevicePlatform = @"kDevicePlatform";
static NSString * const kDeviceModel = @"kDeviceModel";
static NSString * const kDeviceVersion = @"kDeviceVersion";
static NSString * const kDeviceSDK = @"kDeviceSDK";
static NSString * const kDeviceLanguage = @"kDeviceLanguage";
static NSString * const kDeviceCountry = @"kDeviceCountry";
static NSString * const kDevicePosition = @"kDevicePosition";
static NSString * const kDevicePersona = @"kDevicePersona";
static NSString * const kDeviceDisabled = @"kDeviceDisabled";

@interface Device ()
@end

@implementation Device

- (void) configureDevice:(NSString *)aToken
                platform:(NSString *)aPlatform
                model:(NSString *)aModel
                version:(NSString *)aVersion
                sdk:(NSString *)aSDK
                language:(NSString *)aLanguage
                position:(NSDictionary *)aPosition
                persona:(Persona *)aPersona
                disabled:(BOOL)aDisabled {
    self.token = aToken;
    self.platform = aPlatform;
    self.model = aModel;
    self.version = aVersion;
    self.sdk = aSDK;
    self.language = aLanguage;
    self.position = aPosition;
    self.persona = aPersona;
    self.disabled = aDisabled;
}

- (BOOL)isUpdateNeeded:(Device *)oldDevice {
    if (!oldDevice) {
        return YES;
    }
    
    BOOL haveEqualToken = (!self.token && !oldDevice.token) || [self.token isEqualToString: oldDevice.token];
    BOOL haveEqualPlatform = (!self.platform && !oldDevice.platform) || [self.platform isEqualToString: oldDevice.platform];
    BOOL haveEqualModel = (!self.model && !oldDevice.model) || [self.model isEqualToString: oldDevice.model];
    BOOL haveEqualVersion = (!self.version && !oldDevice.version) || [self.version isEqualToString: oldDevice.version];
    BOOL haveEqualSDK = (!self.sdk && !oldDevice.sdk) || [self.sdk isEqualToString: oldDevice.sdk];
    BOOL haveEqualLanguage = (!self.language && !oldDevice.language) || [self.language isEqualToString: oldDevice.language];
    BOOL haveEqualPersona = (!self.persona.clientData && !oldDevice.persona.clientData) || self.persona.clientData == oldDevice.persona.clientData;
    BOOL haveEqualDisabled = (!self.disabled && !oldDevice.disabled) || self.disabled == oldDevice.disabled;
    
    BOOL isEqualDevice = haveEqualToken && haveEqualPlatform && haveEqualModel && haveEqualVersion && haveEqualSDK && haveEqualLanguage && haveEqualPersona && haveEqualDisabled;
    
    return !isEqualDevice;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.token = [aDecoder decodeObjectForKey: kDeviceToken];
        self.platform = [aDecoder decodeObjectForKey: kDevicePlatform];
        self.model = [aDecoder decodeObjectForKey: kDeviceModel];
        self.version = [aDecoder decodeObjectForKey: kDeviceVersion];
        self.sdk = [aDecoder decodeObjectForKey: kDeviceSDK];
        self.language = [aDecoder decodeObjectForKey: kDeviceLanguage];
        self.country = [aDecoder decodeObjectForKey: kDeviceCountry];
        self.position = [aDecoder decodeObjectForKey: kDevicePosition];
        self.persona = [aDecoder decodeObjectForKey: kDevicePersona];
        self.disabled = [aDecoder decodeBoolForKey: kDeviceDisabled];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject: self.token forKey: kDeviceToken];
    [aCoder encodeObject: self.platform forKey: kDevicePlatform];
    [aCoder encodeObject: self.model forKey: kDeviceModel];
    [aCoder encodeObject: self.version forKey: kDeviceVersion];
    [aCoder encodeObject: self.sdk forKey: kDeviceSDK];
    [aCoder encodeObject: self.language forKey: kDeviceLanguage];
    [aCoder encodeObject: self.country forKey: kDeviceCountry];
    [aCoder encodeObject: self.position forKey: kDevicePosition];
    [aCoder encodeObject: self.persona forKey: kDevicePersona];
    [aCoder encodeBool: self.disabled forKey: kDeviceDisabled];
}

- (BOOL)isEqualToDevice:(Device *)device {
    if (!device) {
        return NO;
    }
    
    BOOL haveEqualToken = (!self.token && !device.token) || [self.token isEqualToString: device.token];
    BOOL haveEqualPlatform = (!self.platform && !device.platform) || [self.platform isEqualToString: device.platform];
    BOOL haveEqualModel = (!self.model && !device.model) || [self.model isEqualToString: device.model];
    BOOL haveEqualVersion = (!self.version && !device.version) || [self.version isEqualToString: device.version];
    BOOL haveEqualSDK = (!self.sdk && !device.sdk) || [self.sdk isEqualToString: device.sdk];
    BOOL haveEqualLanguage = (!self.language && !device.language) || [self.language isEqualToString: device.language];
    BOOL haveEqualCountry = (!self.country && !device.country) || [self.country isEqualToString: device.country];
    BOOL haveEqualPosition = (!self.position && !device.position) || [self.position isEqualToDictionary: device.position];
    BOOL haveEqualPersona = (!self.persona && !device.persona) || self.persona == device.persona;
    BOOL haveEqualDisabled = (!self.disabled && !device.disabled) || self.disabled == device.disabled;
    
    return haveEqualToken && haveEqualPlatform && haveEqualModel && haveEqualVersion && haveEqualSDK && haveEqualLanguage && haveEqualCountry && haveEqualPosition && haveEqualPersona && haveEqualDisabled;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual: other]) {
        return NO;
    } else {
        return [self isEqualToDevice:(Device *)other];
    }
}

- (NSUInteger)hash {
    return [self.token hash] ^ [self.platform hash] ^ [self.model hash] ^ [self.version hash] ^ [self.sdk hash] ^ [self.language hash] ^ [self.country hash] ^ [self.position hash] ^ [self.persona hash];
}


@end

