
#import <Foundation/Foundation.h>
#import "TDRequest.h"

@interface TDRequestQueue : NSObject

+ (NSArray*)requests;
+ (TDRequest*)nextRequest;
+ (void)addRequest:(TDRequest *)request;
+ (void)removeRequest:(NSString *)requestId;
+(BOOL)isQueueProcessing;
+(void)updateQueueStatus:(BOOL)isProcessing;

@end
