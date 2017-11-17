
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
#import "TDNotificationOpenHandler.h"
#import "TDNotificationReceivedHandler.h"
#import "TDNotificationReadHandler.h"
#import "TDPersonaHandler.h"
#import "TDLinksHandler.h"
#import "TDEventsHandler.h"

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
		NSString *code = [TDConfiguration getPushCode];
        NSString *push = [[TDConstants instance] buildUrlOfType:URL_TYPE_PUSH andId:lastCode];
        NSString *device = [[TDConstants instance]buildUrlOfType:URL_TYPE_DEVICES andId:code];
        int seconds = ceil([[NSDate date] timeIntervalSince1970] - lastTimestamp);
        NSString *value = [NSString stringWithFormat:@"%d", seconds];

#if !(IN_APP_EXTENSION)
		backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
			NSLog(@"session: timeout");
			[self endBackgroundTask];
		}];
#endif
        
        [TDEventsHandler eventWithPushCode: push
                                    device: device
                                      kind: URL_KIND_SESSION
                                     value: value
                                 onSuccess: ^{
                                     [self endBackgroundTask];
                                 }
                                   onError: ^(NSString * _Nullable error) {
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

    [TDNotificationReceivedHandler notificationReceivedWithCode: code
                                                 notificationId: notification.nId
                                                        handler:^{
                                                            if (onComplete != nil) {
                                                                onComplete();
                                                            }
                                                        }];
}

+ (void)resetBadge: (TDOnSuccess _Nullable )successHandler onError: (TDOnError _Nullable )errorHandler {
#if !(IN_APP_EXTENSION)
	 [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#endif
	NSString *code = [TDConfiguration getPushCode];

    [TDNotificationReadHandler notificationReadedWithCode: code
                                                onSuccess: ^{
                                                    if (successHandler) {
                                                        successHandler();
                                                    }
                                                }
                                                  onError: ^(NSString * _Nullable error) {
                                                      if (errorHandler) {
                                                          errorHandler(error);
                                                      }
                                                  }];
}

+ (void)linkDeviceWithUserIdentifier:(NSString *)userId
                           onSuccess:(TDOnSuccess _Nullable )successHandler
                             onError:(TDOnError _Nullable )errorHandler {
	NSString *code = [TDConfiguration getPushCode];
    
    [TDLinksHandler linkWithCode: code
                          userId: userId
                       onSuccess: ^{
                           if (successHandler) {
                               successHandler();
                           }
                       }
                         onError: ^(NSString * _Nullable error) {
                             if (errorHandler) {
                                 errorHandler(error);
                             }
                         }];
}

+ (void)ModifyUserEmail:(NSString *)email
			  firstName:(NSString *)firstName
			   lastName:(NSString *)lastName
			   password:(NSString *)password
			  onSuccess:(TDOnSuccess)successHandler
				onError:(TDOnError)errorHandler {
#warning NEEDED URL
    [TDPersonaHandler personaWithUrl: @""
                               email: email
                           firstName: firstName
                            lastName: lastName
                            password: password
                           onSuccess:^{
                              if (successHandler) {
                                  successHandler();
                                  
                              }
                          }
                             onError:^(NSString * _Nullable error) {
                              if (errorHandler) {
                                  errorHandler(error);
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
