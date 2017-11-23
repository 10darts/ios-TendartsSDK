
#import <Foundation/Foundation.h>

@interface TDDownloadDelegate : NSObject

@property (strong)NSError* error;
@property (strong)NSURLResponse* response;
@property (strong)NSFileHandle* fileHandle;
@property  BOOL finished;

- (id)initWithFile:(NSString *)filePath;

@end

