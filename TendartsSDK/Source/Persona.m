
#import "Persona.h"

static NSString * const kClientData = @"kClientData";

@interface Persona ()
@end

@implementation Persona


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.clientData = [aDecoder decodeObjectForKey: kClientData];
    }
    
    return self;
}
                    
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject: self.clientData forKey: kClientData];
}

- (BOOL)isClientDataNew:(NSString *)newClientData {
    return ![self.clientData isEqualToString: newClientData];
}

- (BOOL)isEqualToPersona:(Persona *)persona {
    if (!persona) {
        return NO;
    }
    
    BOOL haveEqualClientData = (!self.clientData && !persona.clientData) || [self.clientData isEqualToString: persona.clientData];
    
    return haveEqualClientData;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return [self isEqualToPersona:(Persona *)other];
    }
}

- (NSUInteger)hash {
    return [self.clientData hash];
}


@end
