
#import <Foundation/Foundation.h>
#import "TDHTTPClient.h"

NSString *const kContentTypeKey = @"Content-Type";
NSString *const kContentTypeValue = @"application/json";

NSString *const kAuthorizationKey = @"Authorization";
NSString *const kAuthorizationValue = @"Token ";

NSString *const kAcceptLanguageKey = @"Accept-Language";

@implementation TDHTTPClient

- (NSMutableURLRequest*)requestWithMethod:(NSString *)aMethod
                                      data:(NSData *)aData
                                      url:(NSString *)aUrl {
    NSURL *url = [NSURL URLWithString: aUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: aMethod];
    [request setHTTPBody: aData];
    [request setValue: kContentTypeValue forHTTPHeaderField: kContentTypeKey];

    return request;
}

- (NSURLSession*)sessionWithToken:(NSString *)aToken
                         language:(NSString *)aLanguage {
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfiguration.HTTPAdditionalHeaders = @{kContentTypeKey : kContentTypeValue,
                                                   kAuthorizationKey : [kAuthorizationValue stringByAppendingString: aToken],
                                                   kAcceptLanguageKey : aLanguage
                                                   };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration];
    
    return session;
}

@end
