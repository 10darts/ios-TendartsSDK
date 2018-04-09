
#import "TDSDKExtension.h"
#import "TDUIApplication.h"
#import "PushUtils.h"
#import "TDClassUtils.h"
#import "TDUtils.h"
#import "LocationUtils.h"
#import "TDConfiguration.h"
#import "TDConstants.h"
#import "TDUserNotificationCenter.h"
#import "TDConfiguration.h"
#import "TDAccessHandler.h"
#import "TDDownloadDelegate.h"
#import "TDAPIService.h"

@implementation TDUIApplication

// dummy selector to check if tend darts is already installed
- (void)TDAlreadyInstalled {
}

- (void)TDdidRegisterForRemoteNotificationsWithDeviceToken:(UIApplication*)application withDeviceToken:(NSData*)deviceToken {
	NSString *strData = [NSString stringWithFormat:@"%@",deviceToken];
	strData = [strData stringByReplacingOccurrencesOfString:@"<" withString:@""];
	strData = [strData stringByReplacingOccurrencesOfString:@">" withString:@""];
	strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	[PushUtils savePushToken:strData inSharedGroup: [TDConfiguration getSharedGroup]];
	
	//call parent
	if ([self respondsToSelector:@selector(TDdidRegisterForRemoteNotificationsWithDeviceToken:withDeviceToken:)]) {
		[self TDdidRegisterForRemoteNotificationsWithDeviceToken:application withDeviceToken:deviceToken];
	}
}

- (void)TDDidFailRegisterForRemoteNotification:(UIApplication*)application error:(NSError*)error {
	NSLog(@"td: did fail register for remote notification \n%@", error);
	switch (error.code) {
		case 3010:
			NSLog(@"TD: Warning, notifications don't work on simulator, use a phisical device");
			break;
		case 3000:
			if ([error.description containsString:@"no valid 'aps-env"]) {
				NSLog(@"TD: Warning you should enable push notifications in capabilities section of your app");
			}
			break;
	}
	//call parent
	if ([self respondsToSelector:@selector(TDDidFailRegisterForRemoteNotification:error:)]) {
		[self TDDidFailRegisterForRemoteNotification:application error:error];
	}
}

- (void)TDdidReceiveRemoteNotification:(UIApplication *)application withUserInfo:(NSDictionary *)userInfo {
	NSLog(@"td: did receive remote notification \n%@", userInfo);
	
	[self TDDidReceiveRemoteNotification:application UserInfo:userInfo fetchCompletionHandler:nil];
	
	//call parent
	if ([self respondsToSelector:@selector(TDdidReceiveRemoteNotification:withUserInfo:)]) {
		[self TDdidReceiveRemoteNotification:application withUserInfo:userInfo];
	}
}

/*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
 
 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/

//-notificaiton received or opened when the app is in focus
//-content-available notification received and the app is in the background
- (void)TDDidReceiveRemoteNotification:(UIApplication*)application UserInfo:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	NSLog(@"td: did receive remote notification with completion handler");
    
	BOOL runHandler = true;
	
	if ([TDNotification isTendartsNotification: userInfo] ) {
       TDNotification * notification = [[TDNotification alloc]initWithDictionary:userInfo];
        
		UIApplicationState state = 7777777;
#if !(IN_APP_EXTENSION)
		state = [UIApplication sharedApplication].applicationState;
#endif
		static int pendingResults = 0;
		
        if (notification.nativeSilent && notification.category && state != UIApplicationStateActive) {
            
            UNMutableNotificationContent* content =  [[UNMutableNotificationContent alloc] init];
            #ifdef _IOS_10_FUNCTIONALITY
            [TDUIApplication showNotificationButtonsIfNeeded: userInfo content: content];
            #endif
            content.title = notification.title;
            content.body = notification.siletMessage;
            content.userInfo = userInfo;
            content.sound = [UNNotificationSound defaultSound];
            
            UNNotificationRequest *request =[UNNotificationRequest requestWithIdentifier:notification.nId content:content trigger:[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.3 repeats:NO]];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"TD: error in silent Category notification: %@", error);
                } else {
                    NSLog(@"TD: added silent Category notification ok");
                }
            }];
            
            if (completionHandler)
                completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        
		if (state == UIApplicationStateActive) {
			if (notification.confirm) {
				runHandler = false;
				pendingResults++;
				[TendartsSDK onNotificationReceived:notification withHandler:^{
					pendingResults --;
					
					if (completionHandler && pendingResults < 1) {
						completionHandler(UIBackgroundFetchResultNewData);
					}
				} withApiKey:[TDConfiguration getAPIKey] andSharedGroup:[TDConfiguration getSharedGroup]];
			} else {
				[TendartsSDK notifyNotificationReceived:notification];
			}
			NSLog(@"td: received active: %@", userInfo);
			
			//application is active when the notification is received, create local notification
			
			if (notification.silent) {
				if (runHandler &&  completionHandler) {
					completionHandler(UIBackgroundFetchResultNewData);
				}
				return;
			}
			
			if ([TDUtils iOSVersion] >= 10.0) {
#ifdef _IOS_10_FUNCTIONALITY
				UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
				[center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
									  completionHandler:^(BOOL granted, NSError * _Nullable error)
				 {
                     dispatch_async(dispatch_get_main_queue(), ^ {
                         //td1- notify new authorization status
                     });
				 }];

				
				UNMutableNotificationContent* content =  [[UNMutableNotificationContent alloc] init];
                #ifdef _IOS_10_FUNCTIONALITY
                [TDUIApplication showNotificationButtonsIfNeeded: userInfo content: content];
                #endif
				content.title = notification.title;
				content.body = notification.message;
				content.userInfo = userInfo;
				content.sound = [UNNotificationSound defaultSound];
				//badge?
				if ([notification.image length] >4) {
					pendingResults ++;
					dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
						//download and add media
						NSArray *parts = [notification.image componentsSeparatedByString:@"."];
						if ([parts count] > 1) {
							NSString *extension = [parts lastObject];
							
							//dowload
							NSString *filePath = [NSTemporaryDirectory()stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp_%@.%@",notification.nId,extension ]];
							TDDownloadDelegate *downloadDelegate = [[TDDownloadDelegate alloc]initWithFile:filePath];
							
							NSURL *url = [NSURL URLWithString:notification.image];
							
							NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
							
							[NSURLConnection connectionWithRequest:urlRequest delegate: downloadDelegate];
							
							//iterate until download is finished
							int failsafe = 60; //30 secs for max waiting
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
								if (attachment != nil)
								{
									NSMutableArray *attatchments = [NSMutableArray new];
									[attatchments addObject:attachment];
									
									content.attachments = attatchments;
								}
								
								
							}
							else
							{
								NSLog(@"td: could not download image:%@",error);
								
							}
							
							UNNotificationRequest *request =[UNNotificationRequest requestWithIdentifier:notification.nId content:content trigger:[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.3 repeats:NO]];
							[[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
								if (error)
								{
									NSLog(@"TD: error in local notification: %@", error);
								}
								else
								{
									NSLog(@"TD: added local notification ok");
								}
							}];
							
							//call compleri
							pendingResults --;
							
							if (completionHandler && pendingResults < 1)
							{
								completionHandler(UIBackgroundFetchResultNewData);
							}

						}
					});
					
				
				}
				else
				{
					pendingResults ++;
					//no image
					UNNotificationRequest *request =[UNNotificationRequest requestWithIdentifier:notification.nId content:content trigger:[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.3 repeats:NO]];
					[[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
						if (error) {
							NSLog(@"TD: error in local notification: %@", error);
						}
						else
						{
							NSLog(@"TD: added local notification ok");
						}
						pendingResults --;
						
						if (completionHandler && pendingResults < 1) {
							completionHandler(UIBackgroundFetchResultNewData);
						}
					}];
				}
#endif
			} else {
				UILocalNotification* localNotification = [[UILocalNotification alloc] init];
				
				localNotification.alertBody = notification.message;
				localNotification.userInfo = userInfo;
				localNotification.soundName = UILocalNotificationDefaultSoundName;
				
				if ([notification.title length] > 0 && [localNotification respondsToSelector: NSSelectorFromString(@"alertTitle")]) {
					//titles are not in all os versions
					localNotification.alertTitle = notification.title;
				}
				//badge? todo
#if !(IN_APP_EXTENSION)
				[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
#endif
			}

			//not working, present a dialog:
			runHandler = false;
			pendingResults++;
			UIAlertController * alert=   [UIAlertController
										  alertControllerWithTitle:notification.title
										  message:notification.message
										  preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction* viewButton = [UIAlertAction
										 actionWithTitle:NSLocalizedString(@"View", nil)
										 style:UIAlertActionStyleDefault
										 handler:^(UIAlertAction * action)
										 {
											 if ([notification.deepLink length] > 3)
											 {
#if !(IN_APP_EXTENSION)
												 NSURL *url = [NSURL URLWithString:notification.deepLink];

												 if (url != nil && [[UIApplication sharedApplication] canOpenURL:url])
												 {
													 dispatch_async(dispatch_get_main_queue(), ^{
														 [[UIApplication sharedApplication] openURL:url];
													 });
												 }
#endif
											 }

											 //followed
											 [TendartsSDK onNotificationOpened:notification withHandler:^{
												 pendingResults --;
												 
												 if (completionHandler && pendingResults < 1)
												 {
													 completionHandler(UIBackgroundFetchResultNewData);
												 }
											 }];
											 
										 }];
			UIAlertAction* discard = [UIAlertAction
									  actionWithTitle:NSLocalizedString(@"Close", nil)
									  style:UIAlertActionStyleDefault
									  handler:^(UIAlertAction * action)
									  {
										  pendingResults --;
										  
										  if (completionHandler && pendingResults < 1)
										  {
											  completionHandler(UIBackgroundFetchResultNewData);
										  }
									  }];
			
			[alert addAction:discard];
			[alert addAction:viewButton];
			
#if !(IN_APP_EXTENSION)
			[[[[UIApplication sharedApplication] keyWindow] rootViewController]presentViewController:alert animated:YES completion:nil];
#endif
			if (runHandler &&  completionHandler) {
				completionHandler(UIBackgroundFetchResultNewData);
			}
			
		} else if (application.applicationState == UIApplicationStateBackground) {
			
			//app is in background, check content available key
			//todo send received
			NSLog(@"td: received background: %@", userInfo);
			
			runHandler = false;
			pendingResults++;
			[TendartsSDK onNotificationReceived:notification withHandler:^{
				pendingResults --;
				
				if (completionHandler && pendingResults < 1) {
					completionHandler(UIBackgroundFetchResultNewData);
				}
			} withApiKey:[TDConfiguration getAPIKey] andSharedGroup:[TDConfiguration getSharedGroup]];
			

			
		}
		else if (application.applicationState == UIApplicationStateInactive) {
			//app is transitioning from background to foreground (user taps notification)
			runHandler = false;
			pendingResults++;
			[TendartsSDK onNotificationOpened:notification withHandler:^{
				pendingResults --;
				
				if (completionHandler && pendingResults < 1) {
					completionHandler(UIBackgroundFetchResultNewData);
				}
			}];

			if ([notification.deepLink length] > 3) {
#if !(IN_APP_EXTENSION)				
				NSURL *url = [NSURL URLWithString:notification.deepLink];

				if (url != nil && [[UIApplication sharedApplication] canOpenURL:url]) {
					dispatch_async(dispatch_get_main_queue(), ^{
					[[UIApplication sharedApplication] openURL:url];
					});
				}
#endif
			}
			NSLog(@"td: opened: %@", userInfo);
		}
		
	}//if is tendarts
	else
	{
		//call parent if any
		if ([self respondsToSelector:@selector(TDDidReceiveRemoteNotification:UserInfo:fetchCompletionHandler:)]) {
			[self TDDidReceiveRemoteNotification:application UserInfo:userInfo fetchCompletionHandler:completionHandler];
		}
	}
	//td2
	if (runHandler &&  completionHandler) {
		completionHandler(UIBackgroundFetchResultNewData);
	}
}

- (void)TDDidReceiveLocalNotification:(UIApplication*)application notification:(UILocalNotification*)notification {
	NSLog(@"td: did receive local notification \n%@", notification);
		//call parent
	if ([self respondsToSelector:@selector(TDDidReceiveLocalNotification:notification:)]) {
		[self TDDidReceiveLocalNotification:application notification:notification];
	}
}

- (void)TDLocalNotification:(UIApplication*)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification*)notification completionHandler:(void(^)(void))completionHandler {
	//call parent
	if ([self respondsToSelector:@selector(TDLocalNotification:handleActionWithIdentifier:forLocalNotification:completionHandler:)]) {
		[self TDLocalNotification:application handleActionWithIdentifier:identifier forLocalNotification:notification completionHandler:completionHandler];
	}
	completionHandler();
}

- (void)TDdidRegisterUserNotificationSettings:(UIApplication*)application settings:(UIUserNotificationSettings*)notificationSettings {
	NSLog(@"td: did register user notification settings \n%@", notificationSettings);
	
	//td6
	
	//call parent
	if ([self respondsToSelector:@selector(TDdidRegisterUserNotificationSettings:settings:)]) {
		[self TDdidRegisterUserNotificationSettings:application settings:notificationSettings];
	}
}

static BOOL accessSent = false;

- (void)TDDidBecomeActive: (UIApplication*)application {
	//notify app open
	if (!accessSent) {
		NSString *code = [TDConfiguration getPushCode];
		if (code != nil) {
			accessSent = true;
            NSString *url = [[TDConstants instance] getDeviceAccessUrl: code];
            [TDAccessHandler accessWithUrl: url];
		}
	}
    [PushUtils savePushToken: [TDConfiguration getPushToken]
               inSharedGroup: [TDConfiguration getSharedGroup]];
	//todo send geodata if ellapsed time < 2 mins
	
	//call parent
	if ([self respondsToSelector:@selector(TDDidBecomeActive:)]) {
		[self TDDidBecomeActive:application];
	}
    
    [TDAPIService processQueue];
}

- (void)TDWillResignActive:(UIApplication *)application {
	[TendartsSDK onAppGoingToBackground];
	
	//call parent
	if ([self respondsToSelector:@selector(TDWillResignActive:)]) {
		[self TDWillResignActive:application];
	}
}

static Class _delegateClass = nil;
static NSArray *_delegateChilds = nil;

- (void)setTDDelegate:(id<UIApplicationDelegate>)delegate {
	NSLog(@"set delegate: called");
	
	Class tendartsDelegate = [TDUIApplication class];
	
	if (_delegateClass == nil) {
		_delegateClass = searchAncestorImplementingProtocol([delegate class], @protocol(UIApplicationDelegate));
		if (_delegateClass == nil) {
			NSLog(@"TD: no delegate");
			_delegateClass = [delegate class];
		}
		_delegateChilds = getChilds(_delegateClass);
		
		//install application did register remote notifications:
		installOverrideMethod(tendartsDelegate,
							  @selector(TDdidRegisterForRemoteNotificationsWithDeviceToken:withDeviceToken:),
							  _delegateClass,
							  _delegateChilds,
							  @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:));
		
		//install application did fail to register for remote notifications:
		installOverrideMethod(tendartsDelegate
							  , @selector(TDDidFailRegisterForRemoteNotification:error:),
							  _delegateClass,
							  _delegateChilds,
							  @selector(application:didFailToRegisterForRemoteNotificationsWithError:));
		
		//install application will resign active
		installOverrideMethod(tendartsDelegate,
							  @selector(TDWillResignActive:),
							  _delegateClass,
							  _delegateChilds,
							  @selector(applicationWillResignActive:));
		
		
		/*apple: This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
		 
		 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. */
		
		
		//install application did receive remote notification:
		installOverrideMethod(tendartsDelegate,
							  @selector(TDDidReceiveRemoteNotification:UserInfo:fetchCompletionHandler:),
							  _delegateClass,
							  _delegateChilds,
							  @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:));
		
		
		//install application did beecome active:
		installOverrideMethod(tendartsDelegate,
							  @selector(TDDidBecomeActive:),
							  _delegateClass,
							  _delegateChilds,
							  @selector(applicationDidBecomeActive:));
		
		if ([TDUtils iOSVersion] < 10) {
			installOverrideMethod(tendartsDelegate,
								  @selector(TDLocalNotification:handleActionWithIdentifier:forLocalNotification:completionHandler:),
								  _delegateClass,
								  _delegateChilds,
								  @selector(application:handleActionWithIdentifier:forLocalNotification:completionHandler:));
			
			
			installOverrideMethod(tendartsDelegate,
								  @selector(TDdidRegisterUserNotificationSettings:settings:),
								  _delegateClass,
								  _delegateChilds,
								  @selector(application:didRegisterUserNotificationSettings:));
			
			//todo: check if should be deleted as implemented fetchCompletionHanlder version
			installOverrideMethod(tendartsDelegate,
								  @selector(TDdidReceiveRemoteNotification:withUserInfo:),
								  _delegateClass,
								  _delegateChilds,
								  @selector(application:didReceiveRemoteNotification:));
			
			installOverrideMethod(tendartsDelegate,
								  @selector(TDDidReceiveLocalNotification:notification:),
								  _delegateClass,
								  _delegateChilds,
								  @selector(application:didReceiveLocalNotification:));
			
		}
	}
	//call existing
	if ([self respondsToSelector:@selector(setTDDelegate:)]) {
		[self setTDDelegate:delegate];
	}
}

#ifdef _IOS_10_FUNCTIONALITY
+ (void)showNotificationButtonsIfNeeded:(NSDictionary *)userInfo content:(UNMutableNotificationContent *)content {
    NSString *replies = [NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"category"]];
    if (!replies) {
        return;
    }
    
    NSMutableSet<UNNotificationCategory*>* notificationCategories = [self allExistingCategories];
     UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    NSArray *current = [userInfo objectForKey:@"r"];
    
    if (current) {
        NSMutableArray *actions =  [[NSMutableArray alloc] init];
        NSString *categoryIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
        
        if (notificationCategories) {
            NSMutableArray *newButtons = [NSMutableArray new];
            for (NSDictionary *buttonDict in current) {
                [newButtons addObject: [buttonDict objectForKey:@"t"]];
            }
            for(UNNotificationCategory *allExistingCategories in notificationCategories) {
                NSMutableArray *oldButtons = [NSMutableArray new];
                for(UNNotificationAction *action in allExistingCategories.actions) {
                    [oldButtons addObject: action.identifier];
                }
                NSSet *set1 = [NSSet setWithArray: newButtons];
                NSSet *set2 = [NSSet setWithArray: oldButtons];
                
                if ([set1 isEqualToSet:set2]) {
                    [center setNotificationCategories: notificationCategories];
                    break;
                }
            }
        }
        
        for (NSDictionary *buttonDict in current) {
            UNNotificationAction* action = [UNNotificationAction
                                                  actionWithIdentifier:[buttonDict objectForKey:@"t"]
                                                  title:[buttonDict objectForKey:@"t"]
                                                  options:UNNotificationActionOptionForeground];
            [actions addObject: action];
        }
        
        // Create the category with the custom actions.
        UNNotificationCategory* category = [UNNotificationCategory
                                                          categoryWithIdentifier: categoryIdentifier
                                                          actions: actions
                                                          intentIdentifiers:@[]
                                                          options:UNNotificationCategoryOptionCustomDismissAction];
        
        if (notificationCategories && notificationCategories.count > 0) {
            NSMutableSet *newCategorySet = [NSMutableSet new];
            for(UNNotificationCategory *allExistingCategories in notificationCategories) {
                    [newCategorySet addObject:allExistingCategories];
            }
            
            [newCategorySet addObject:category];
            notificationCategories = newCategorySet;
        }
        else
            notificationCategories = [[NSMutableSet alloc] initWithArray:@[category]];
        
        
        // Register the notification categories.
       
        [center setNotificationCategories: notificationCategories];
        content.categoryIdentifier = categoryIdentifier;
    }
}
#endif

#ifdef _IOS_10_FUNCTIONALITY
+ (NSMutableSet<UNNotificationCategory*>*)allExistingCategories {
    __block NSMutableSet* allNotificationCategories;
    dispatch_semaphore_t stopSignal = dispatch_semaphore_create(0);
    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    
    [notificationCenter getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> *categories) {
        
        allNotificationCategories = [categories mutableCopy];
        
        dispatch_semaphore_signal(stopSignal);
        
    }];
    
    dispatch_semaphore_wait(stopSignal, DISPATCH_TIME_FOREVER);
    
    return allNotificationCategories;
}
#endif

+ (void)installTenddartsOnApplication: (Class)application {
	//check if already installed
	if (targetHasMethod(application, @selector(TDAlreadyInstalled))) {
		NSLog(@"TD error: already installed, you may have included the library more than once");
		return;
	}
	//add dummy method
	putMethodInTarget([TDUIApplication class], @selector(TDAlreadyInstalled),
					  [application class],//OJO MIRAR
					  @selector(TDAlreadyInstalled));
	
	//insert our custom set delegate override that will install all delegate functionality
	putMethodInTarget([TDUIApplication class], @selector(setTDDelegate:), application, @selector(setDelegate:));
	
	//for ios >= 10 install UserNotifications
	if (NSClassFromString(@"UNUserNotificationCenter")) {
		[TDUserNotificationCenter installTDUserNotifications];
	}
}

@end
