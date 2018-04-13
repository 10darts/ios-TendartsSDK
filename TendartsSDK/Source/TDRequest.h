
#import <Foundation/Foundation.h>

@interface TDRequest : NSObject <NSCoding>

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *sUrl;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, assign) BOOL inProcess;

@end
