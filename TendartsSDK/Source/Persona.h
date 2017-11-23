
#import <Foundation/Foundation.h>

@interface Persona : NSObject <NSCoding>

@property (nonatomic, strong) NSString *clientData;

- (BOOL) isClientDataNew:(NSString *) newClientData;

@end

