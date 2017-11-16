
#import <Foundation/Foundation.h>

@interface TDHTTPClient : NSObject

- (NSMutableURLRequest*)requestWithMethod:(NSString *)aMethod
                                     data:(NSData *)aData
                                      url:(NSString *)aUrl;

- (NSURLSession*)sessionWithToken:(NSString *)aToken
                         language:(NSString *)aLanguage;

@end
