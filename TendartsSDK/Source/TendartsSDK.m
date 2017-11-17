
#import "TendartsSDK.h"
#import <UIKit/UIKit.h>

#import "NotificationUtils.h"
#import "TDConfiguration.h"
#import "TDConstants.h"
#import "TDUIApplication.h"
#import "LocationUtils.h"
#import "TDUserNotificationCenter.h"
#import "TDNotification.h"

#import "TDDownloadDelegate.h"
#import "TDCommunications.h"
#import "TDNotificationOpenHandler.h"

@implementation TendartsSDK

static NSString * group = nil;

+ (id)initTendartsUsingLaunchOptions:(NSDictionary*)launchOptions withAPIKey: (NSString *)apiKey
andConfig: (NSDictionary*)config andSharedGroup:(NSString * _Nonnull)group {
	//todo: get configuration from parameters
	[TDConfiguration saveSharedGroup:group];
	
	if ([apiKey length] < 4) {
		if (self) {
            apiKey = [TDConfiguration getAPIKey];
		}
		if ([apiKey length] < 4) {
			NSLog(@"TendartsSDK: warning, you should pass an apiKey to initTendartsUsingLaunchOptions");
		} else if (self) {
            [TDConfiguration saveAPIKey:apiKey];
        }
    } else if (self) {
        [TDConfiguration saveAPIKey:apiKey];
	}
    
	[LocationUtils startUpdating];
	[NotificationUtils registerRemoteNotifications];

	return self;    
}

static TendartsSDK* _singleton = nil;

+ (TendartsSDK *)instance {
	@synchronized (_singleton) {
		if (_singleton == nil) {
			_singleton = [[TendartsSDK alloc]init];
		}
	}
	return _singleton;
}

static id<TendartsDelegate> _delegate = nil;
+ (void)setDelegate:(id<TendartsDelegate>)delegate {
	_delegate = delegate;
}

+ (id<TendartsDelegate>)getDelegate {
	return _delegate;
}
static NSString * lastCode = nil;
static double lastTimestamp = 0;
+ (void)onNotificationOpened:(TDNotification *)notification
                 withHandler:(TDOperationComplete)onComplete {
	//decrease badge
#if !(IN_APP_EXTENSION)
	long badge =  [UIApplication sharedApplication].applicationIconBadgeNumber -1;
	if (badge >=0) {
		[UIApplication sharedApplication].applicationIconBadgeNumber = badge;
	}
#endif
    
	id<TendartsDelegate> delegate = [TendartsSDK getDelegate];
	if (delegate != nil && [delegate respondsToSelector:@selector(onNotificationOpened:)]) {
		[delegate onNotificationOpened:notification];
	}
    
    lastCode =  notification.nId;
    lastTimestamp = [[NSDate date] timeIntervalSince1970];
    
    [TDNotificationOpenHandler notificationOpenWithNotificationId: notification.nId
                                                          handler: ^{
                                                              onComplete();
                                                          }];
}

#if !(IN_APP_EXTENSION)
static UIBackgroundTaskIdentifier backgroundTask = 0;
#endif

+ (void)endBackgroundTask {
#if !(IN_APP_EXTENSION)
  [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
			backgroundTask = UIBackgroundTaskInvalid;
#endif
}

+ (BOOL)onAppGoingToBackground {
	if (lastTimestamp != 0 && lastCode != nil) {
		int seconds = ceil([[NSDate date] timeIntervalSince1970] - lastTimestamp);
		NSString * code = [TDConfiguration getPushCode];

		NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
							[[TDConstants instance] buildUrlOfType:URL_TYPE_PUSH andId:lastCode],@"push",
							[[TDConstants instance]buildUrlOfType:URL_TYPE_DEVICES andId:code],@"device",
							URL_KIND_SESSION ,@"kind",
							  [NSString stringWithFormat:@"%d",seconds],@"value",
							  nil];
		
		NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
		
#if !(IN_APP_EXTENSION)
		backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
			NSLog(@"session: timeout");
			[self endBackgroundTask];
		}];
#endif
		
        [TDCommunications sendData:data
                             toURl:[[TDConstants instance] getEvents]
                        withMethod:@"POST"
                  onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                      [TendartsSDK logEventWithCategory:@"SDK" type:@"Session sent" andMessage:json.description];
                      NSLog(@"td: sent session");
                      [self endBackgroundTask];
                  }
                    onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                        [TendartsSDK logEventWithCategory:@"SDK" type:@"Error sending session" andMessage:json.description];
                        NSLog(@"td: error sending session");
                        [self endBackgroundTask];
                        
                    }];
        
		lastTimestamp = 0;
		lastCode = nil;
		return YES;
	}
	return NO;
}

+ (void)notifyNotificationReceived:(TDNotification *)notification {
	id<TendartsDelegate> delegate = [TendartsSDK getDelegate];
	if (delegate != nil && [delegate respondsToSelector:@selector(onNotificationReceived:)]) {
		[delegate onNotificationReceived:notification];
	}
}

+ (void)onNotificationReceived:(TDNotification *)notification
                   withHandler:(TDOperationComplete)onComplete
                    withApiKey: (NSString * _Nonnull)apiKey
                andSharedGroup: (NSString * _Nonnull)group {
	id<TendartsDelegate> delegate = [TendartsSDK getDelegate];
	if (delegate != nil && [delegate respondsToSelector:@selector(onNotificationReceived:)]) {
		[delegate onNotificationReceived:notification];
	}
	
	if (!notification.confirm) {
		if (onComplete) {
			onComplete();
		}
		return;
	}
	if (notification.alreadySent.length > 2) {
		return;//already sent
	}
	
	NSString *code = [TDConfiguration getPushCodeWithApiKey:apiKey andGroupName:group];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [[TDConstants instance] getDeviceUrl:code], @"device",
						  nil];
	
	NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
	
	NSString *url =[[TDConstants instance] getNotificationReceivedUrl:notification.nId];
	
	[TDCommunications sendData:data toURl:url withMethod:@"PATCH"
			  onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
	 {
		 [TendartsSDK logEventWithCategory:@"NOTIFICATION" type:@"notification received sent ok" andMessage:json.description];
		 NSLog(@"SDK sent received: %@", json);
		 if (onComplete != nil )
		 {
			 onComplete();
		 }
	 }
                onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
	 {
		 [TendartsSDK logEventWithCategory:@"NOTIFICATION" type:@"notification received send error" andMessage:json.description];
		 if (onComplete != nil)
		 {
			 onComplete();
		 }
		 
		 NSLog(@"SDK error sending received %@", json);
	 }];
}

+ (void)resetBadge: (TDOnSuccess _Nullable )successHandler onError: (TDOnError _Nullable )errorHandler {
#if !(IN_APP_EXTENSION)
	 [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#endif
	NSString * code = [TDConfiguration getPushCode];
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [[TDConstants instance] getDeviceUrl:code], @"device",
						  nil];
	
	NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
	
	NSString *url =[[TDConstants instance] getAllNotificationsRead];
	
	[TDCommunications sendData:data toURl:url withMethod:@"PATCH"
			  onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
	 {
		 [TendartsSDK logEventWithCategory:@"USER" type:@"all notifications read sent ok" andMessage:json.description];
		 if (successHandler)
		 {
			 successHandler();
		 }
		 NSLog(@"SDK all read ok: %@", json);
		
	 }
				onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
	 {
		 if (errorHandler)
		 {
			 errorHandler( [json description]);
		 }
		 [TendartsSDK logEventWithCategory:@"USER" type:@"all notifications read error" andMessage:json.description];
		 NSLog(@"SDK error in all read %@", json);
	 }];    
}

+ (void)linkDeviceWithUserIdentifier:(NSString *)userId onSuccess: (TDOnSuccess _Nullable )successHandler onError: (TDOnError _Nullable )errorHandler {
	NSString * code = [TDConfiguration getPushCode];
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [[TDConstants instance] getDeviceUrl:code], @"device",
						  userId,@"client_data",
						  nil];
	
	NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
	
	NSString *url =[[TDConstants instance] getLinkDevice];
	
	[TDCommunications sendData:data toURl:url withMethod:@"POST"
			  onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
	 {
		 NSString *persona = [json objectForKey:@"persona"];
		 if (persona != nil )
		 {
			 [TDConfiguration saveUserCode:persona];
		 }
		 
		 [TendartsSDK logEventWithCategory:@"USER" type:@"link device sent ok" andMessage:json.description];
		 if (successHandler)
		 {
			 successHandler();
		 }
		 
	 }
				onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
	 {
		 if (errorHandler)
		 {
			 errorHandler( [json description]);
		 }
		 [TendartsSDK logEventWithCategory:@"USER" type:@"link device send error" andMessage:json.description];
		
	 }];

}

+ (void)ModifyUserEmail:(NSString *)email
			  firstName:(NSString *)firstName
			   lastName:(NSString *)lastName
			   password:(NSString *)password
			  onSuccess: (TDOnSuccess  )successHandler
				onError: (TDOnError  )errorHandler {
	NSString * code = [TDConfiguration getPushCode];
	
	if (code.length < 3) {
		if (errorHandler) {
			errorHandler(@"device not yet registered");
		}
		return;
		
	}
	NSString * userCode = [TDConfiguration getUserCode];
	if (userCode.length < 3) {
		if (errorHandler) {
			errorHandler(@"the user should be already registered");
		}
		return;
		
	}
	
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 email, @"email",
								 nil];
	if (firstName.length > 0) {
		[dict setObject:firstName forKey:@"first_name"];
	}
	if (lastName.length > 0) {
		[dict setObject:lastName forKey:@"last_name"];
	}
	if (password.length > 0) {
		[dict setObject:password forKey:@"password"];
	}
	
	NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
	
	
	
	[TDCommunications sendData:data toURl:userCode withMethod:@"PATCH"
			  onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
	 {
		 [TendartsSDK logEventWithCategory:@"USER" type:@"modify user sent ok" andMessage:json.description];
		 if (successHandler) {
			 successHandler();
		 }
	 }
                onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
	 {
		 [TendartsSDK logEventWithCategory:@"USER" type:@"modify user send error" andMessage:json.description];
		 if (errorHandler) {
			 errorHandler( [json description]);
		 }
	 }];
}

+ (void)logEventWithCategory:(NSString *_Nullable)category type:(NSString *_Nullable)type andMessage:(NSString *_Nullable)message {
	id<TendartsDelegate> delegate = [TendartsSDK getDelegate];
	if (delegate != nil && [delegate respondsToSelector:@selector(onLogEventWithCategory:type:andMessage:)]) {
		[delegate onLogEventWithCategory:category type:type andMessage:message];
	}
}

#ifdef _IOS_10_FUNCTIONALITY
+ (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * ))contentHandler withApiKey: (NSString * )apiKey andSharedGroup:(NSString * _Nonnull)group {
	if ([TDNotification isTendartsNotification:request.content.userInfo]) {
		if (apiKey != nil && ! [apiKey containsString:@"api_key"]) {
		
			TDNotification * notification = [[TDNotification alloc]initWithDictionary:request.content.userInfo];
			
			//send received
			[TendartsSDK onNotificationReceived:notification withHandler:nil withApiKey:apiKey andSharedGroup:group];
			UNMutableNotificationContent *content = [request.content mutableCopy];
			NSMutableDictionary *info = [content.userInfo mutableCopy];
			
			if (info == nil) {
				info = [[NSMutableDictionary alloc]init];
			}

			[info setObject:@"sent" forKey:@"sentReceived"];
			content.userInfo = info;
			
			if (notification.silent) {
				
				contentHandler(content);
				return;
			}
			
			if (notification.image != nil && notification.image.length > 6) {
				NSURLComponents *components = [NSURLComponents componentsWithString:notification.image];
				components.query = nil;
				
				NSArray *parts = [components.string componentsSeparatedByString:@"."];
				if ([parts count] > 1) {
					NSString *extension = [parts lastObject];
					//dowload synchronously the image as we should call contenthandler at the end
					NSString *filePath = [NSTemporaryDirectory()stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp_%@.%@",notification.nId,extension ]];
					TDDownloadDelegate *downloadDelegate = [[TDDownloadDelegate alloc]initWithFile:filePath];
					
					NSURL *url = [NSURL URLWithString:notification.image];
					
					NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
					
					[NSURLConnection connectionWithRequest:urlRequest delegate: downloadDelegate];
					
					//iterate until download is finished
					int failsafe = 60*3; //30 secs for max waiting
					int i = 0;
					while ( i++ < failsafe && !downloadDelegate.finished )
					{
						//let the things flow half second
						[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
					}
					
					NSError *error = downloadDelegate.error;
					if (error == nil)
					{
						//image downloaded, attach it to the notification
						
						NSURL* imageUrl = [NSURL fileURLWithPath:filePath];
						id attachment = [UNNotificationAttachment attachmentWithIdentifier:notification.nId URL:imageUrl options:0 error:&error];
						if (attachment != nil) {
							NSMutableArray *attatchments = [NSMutableArray new];
							[attatchments addObject:attachment];
							UNMutableNotificationContent *mutable =  content;//[request.content mutableCopy];
							mutable.attachments = attatchments;
							contentHandler(mutable);
							return;
						}
						
						
					} else {
						NSLog(@"td: could not download image:%@",error);
					}
				}
			}//notification image
			contentHandler(content);
		} else {
			//not api key
			NSLog(@"error: please add porper api key to didReceiveNotificationRequest call");
			contentHandler(request.content);
		}
		return;

    }//tendarts notification
	contentHandler(request.content);    
}

+ (void)serviceExtensionTimeWillExpire:(UNNotificationContent *)content withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
	contentHandler(content);
}
#endif//ios 10 functionality

@end

@implementation UIApplication (Tendarts)//extension of UIApplication

+ (void)load {
	NSLog(@"UiApplication: called");
	
	NSProcessInfo *processInfo = [NSProcessInfo processInfo];
	if ([[processInfo processName] isEqualToString:@"IBDesignablesAgentCocoaTouch"]) {
		return;// do nothing in design mode, could cause strange behabiours otherwise
	}
	
	[TDUIApplication installTenddartsOnApplication:self];
}

@end
