
#import "TDRequestQueue.h"
#import "DataManager.h"

@implementation TDRequestQueue


+ (NSArray*)requests {
    return [DataManager loadRequest];
}

+ (void)saveRequests:(NSArray *)requests {
    [DataManager saveObject: requests
                     forKey: kRequest];
}

+ (TDRequest*)nextRequest {
    NSArray* requests = [self requests];
    if (!requests) {
        return nil;
    }
    if (requests.count == 0) {
        return nil;
    }
    for (TDRequest *request in requests) {
        if (request.inProcess == NO) {
            return request;
            break;
        }
    }
    return requests[0];
}

+ (void)addRequest:(TDRequest *)request {
    NSMutableArray* requests = [NSMutableArray arrayWithArray: [self requests]];
    [requests addObject: request];
    [self saveRequests: requests];
}

+ (void)removeRequest:(NSString *)requestId {
    NSMutableArray* requests = [NSMutableArray arrayWithArray: [self requests]];
    
    for (TDRequest* request in requests) {
        if([request.requestId isEqualToString: requestId]) {
            [requests removeObject: request];
            break;
        }
    }
    [self saveRequests: requests];
}

+(BOOL)isQueueProcessing {
    return [DataManager queueStatus];
}

+(void)updateQueueStatus:(BOOL)isProcessing {
    [DataManager queueStatus: isProcessing];
}

@end
