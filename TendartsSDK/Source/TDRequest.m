
#import "TDRequest.h"

static NSString * const kRequestData = @"kRequestData";
static NSString * const kRequestURL = @"kRequestURL";
static NSString * const kRequestMethod = @"kRequestMethod";
static NSString * const kRequestId = @"kRequestId";
static NSString * const kRequestProcess = @"kRequestProcess";

@interface TDRequest ()
@end

@implementation TDRequest


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.data = [aDecoder decodeObjectForKey: kRequestData];
        self.sUrl = [aDecoder decodeObjectForKey: kRequestURL];
        self.method = [aDecoder decodeObjectForKey: kRequestMethod];
        self.requestId = [aDecoder decodeObjectForKey: kRequestId];
        self.inProcess = [aDecoder decodeBoolForKey: kRequestProcess];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject: self.data forKey: kRequestData];
    [aCoder encodeObject: self.sUrl forKey: kRequestURL];
    [aCoder encodeObject: self.method forKey: kRequestMethod];
    [aCoder encodeObject: self.requestId forKey: kRequestId];
    [aCoder encodeBool: self.inProcess forKey: kRequestProcess];
}

- (BOOL)isEqualToRequest:(TDRequest *)tdRequest {
    if (!tdRequest) {
        return NO;
    }
    
    BOOL haveEqualData = (!self.data && !tdRequest.data) || [self.data isEqualToData: tdRequest.data];
    BOOL haveEqualURL = (!self.sUrl && !tdRequest.sUrl) || [self.sUrl isEqualToString: tdRequest.sUrl];
    BOOL haveEqualMethod = (!self.method && !tdRequest.method) || [self.method isEqualToString: tdRequest.method];
    BOOL haveEqualId = (!self.requestId && !tdRequest.requestId) || [self.requestId isEqualToString: tdRequest.requestId];
    BOOL areInProcess = (!self.inProcess && !tdRequest.inProcess) || self.inProcess == tdRequest.inProcess;
    
    return haveEqualData && haveEqualURL && haveEqualMethod && haveEqualId && areInProcess;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual: other]) {
        return NO;
    } else {
        return [self isEqualToRequest:(TDRequest *)other];
    }
}

- (NSUInteger)hash {
    return [self.data hash] ^ [self.sUrl hash] ^ [self.method hash] ^ [self.requestId hash];
}

@end
