
#import "TDCommunications.h"
#import "TDHTTPClient.h"
#import "TDConfiguration.h"
#import "TDUtils.h"

@implementation TDCommunications

static TDHTTPClient *_httpClient;
+ (TDHTTPClient*)httpClient {
    if (!_httpClient)
        _httpClient = [TDHTTPClient new];
    return _httpClient;
}

+ (void)sendData:(NSData *)data
           toURl:(NSString *)sUrl
      withMethod: (NSString *)method
onSuccessHandler: (TDCHandleSuccess)successHandler
  onErrorHandler:(TDCHandleError)errorHandler {
	NSString * apiKey =[TDConfiguration getAPIKey];
	if (apiKey == nil) {
		return;
	}
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSession* session = [self.httpClient sessionWithToken:apiKey
                                                         language: [TDUtils getCurrentLanguage]];
        
        NSMutableURLRequest* request = [self.httpClient requestWithMethod: method
                                                                     data: data
                                                                      url: sUrl];
		
		NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
			NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
			NSDictionary *json = nil;
                                                        
			if (data != nil) {
				NSError *jerror;
				json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
				if (jerror != nil) {
					NSLog(@"TD: Error in server data: %@\non: %@", error, data);
				}
			}
			
			if (HTTPResponse.statusCode >= 200 && HTTPResponse.statusCode < 300) {
				dispatch_async(dispatch_get_main_queue(), ^{
					if (successHandler != nil) {
                        successHandler(json, data, HTTPResponse.statusCode);
					}
				});
			} else {
				dispatch_async(dispatch_get_main_queue(), ^{
					if (errorHandler != nil) {
						errorHandler(json, data, HTTPResponse.statusCode);
					}
				});
			}
		}];
		[dataTask resume];
	});
}

@end
