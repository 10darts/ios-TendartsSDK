
#import <Foundation/Foundation.h>

#import "Persona.h"

@interface Device : NSObject <NSCoding>

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *sdk;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSDictionary *position;
@property (nonatomic, strong) Persona *persona;
@property (nonatomic, assign) BOOL disabled;

- (void) configureDevice:(NSString *)aToken
                platform:(NSString *)aPlatform
                   model:(NSString *)aModel
                 version:(NSString *)aVersion
                     sdk:(NSString *)aSDK
                language:(NSString *)aLanguage
                position:(NSDictionary *)aPosition
                 persona:(Persona *)aPersona
                disabled:(BOOL)aDisabled;

- (BOOL)isUpdateNeeded:(Device *)oldDevice;

@end
