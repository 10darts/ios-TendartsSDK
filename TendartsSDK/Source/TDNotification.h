
#import <Foundation/Foundation.h>

@interface TDNotification : NSObject

@property (nonatomic) BOOL read;
@property (nonatomic) BOOL silent;  //sil
@property (nonatomic) BOOL confirm; //cfm
@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, strong) NSString *title;//title
@property (nonatomic, strong) NSString *message; //body
@property (nonatomic, strong) NSDictionary *data; //raw data
@property (nonatomic, strong) NSString *nId;//notification id  //id
@property (nonatomic, strong) NSString *nNot;//notification-generator id  //not
@property (nonatomic, strong) NSString *deepLink;//dl
@property (nonatomic, strong) NSString *contentId;//dsc
@property (nonatomic, strong) NSString *contentType;//dst
@property (nonatomic, strong) NSString * image;//img
@property (nonatomic, strong) NSString * userData;//ctm
@property (nonatomic, strong) NSString * alreadySent;//internal use

- (id)initWithDictionary:(NSDictionary *)dict;
+ (BOOL)isTendartsNotification: (NSDictionary*)data;

@end
