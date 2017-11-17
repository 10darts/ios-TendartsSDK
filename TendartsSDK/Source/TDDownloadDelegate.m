
#import "TDDownloadDelegate.h"

@implementation TDDownloadDelegate

- (id)initWithFile:(NSString *)filePath {
    if (self = [super init]) {
        self.finished = NO;
        //if already exists, delete the file
        if ([[NSFileManager defaultManager] fileExistsAtPath: filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil]; //don't care about error
        }
        
        //create empty file
        [[NSFileManager defaultManager] createFileAtPath: filePath contents: l attributes: nil];
        
        //store the file handle
        self.fileHandle = [NSFileHandle fileHandleForWritingAtPath: filePath];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error {
    self.error  = error;
    [self connectionDidFinishLoading: connection];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    [self.fileHandle writeData: data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    self.response = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.fileHandle closeFile];
    self.finished = YES;
}

@end

