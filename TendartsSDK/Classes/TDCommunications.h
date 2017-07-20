//
//  TDCommunications.h
//  sdk
//
//  Created by Jorge Arimany on 3/7/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TD_COMMUNICATION_HANDLERS_DEFINED
#define TD_COMMUNICATION_HANDLERS_DEFINED
typedef void (^TDCHandleSuccess)(NSDictionary* json , NSData *data, NSInteger statusCode);
typedef void(^TDCHandleError)(NSDictionary* json , NSData *data, NSInteger statusCode);
#endif

@interface TDCommunications : NSObject


//[string dataUsingEncoding:NSUTF8StringEncoding]

+ (void)sendData:(NSData *)data toURl:(NSString *)sUrl withMethod: (NSString*) method onSuccessHandler: (TDCHandleSuccess) successHandler onErrorHandler:(TDCHandleError) errorHandler;

@end

@interface TDDownloadDelegate : NSObject

@property (strong) NSError* error;
@property (strong) NSURLResponse* response;
@property (strong) NSFileHandle* fileHandle;
@property  BOOL finished;
- (id)initWithFile:(NSString*)filePath;
@end
