//
//  TDCommunications.m
//  sdk
//
//  Created by Jorge Arimany on 3/7/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import "TDCommunications.h"

#import "TDConfiguration.h"
#import "TDUtils.h"

@implementation TDCommunications



+ (void)sendData:(NSData *)data toURl:(NSString *)sUrl withMethod: (NSString*) method onSuccessHandler: (TDCHandleSuccess) successHandler onErrorHandler:(TDCHandleError) errorHandler
{
	
	NSString * apiKey =[TDConfiguration getAPIKey];
	if( apiKey == nil)
	{
		return;
	}
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		// session config
		NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
		sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type"      : @"application/json",
													  // @"Geolocation"       : [self getGeolocationHeader],
													   @"Authorization"     : [@"Token " stringByAppendingString: apiKey]   ,
													   @"Accept-Language"   :  [TDUtils getCurrentLanguage]
													   };
		
		// session init
		NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
		
		NSURL *url = [NSURL URLWithString:sUrl];//[sUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
		[request setHTTPMethod:method];
		[request setHTTPBody:data];
		[request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
		
		NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
		{
			// get http response and convert to json
			NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
			NSDictionary *json = nil;
			if( data != nil)
			{
			
				NSError *jerror;
				json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
				if (jerror != nil)
				{
					NSLog(@"TD: Error in server data: %@\non: %@", error, data);
				}
				
				
			}
			
			if (HTTPResponse.statusCode >= 200 && HTTPResponse.statusCode < 300)
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					
					if( successHandler != nil)
					{
						successHandler( json,data, HTTPResponse.statusCode);
					}
				});
			}
			else
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					if( errorHandler != nil)
					{
					
						errorHandler(json,data,HTTPResponse.statusCode);
					}
				});
			}
			
		}];
		
		[dataTask resume];
	});
}





@end






@implementation TDDownloadDelegate


- (id)initWithFile:(NSString*)filePath
{
	if (self = [super init])
	{
		self.finished = NO;
		//if already exists, delete the file
		if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
		{
			[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil]; //don't care about error
		}
		
		//create empty file
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
		
		//store the file handle
		self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	}
	return self;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
	self.error  = error;
	[self connectionDidFinishLoading:connection];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
	[self.fileHandle writeData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
	self.response = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self.fileHandle closeFile];
	self.finished = YES;
}
@end




