
#import "TendartsSDK.h"
#import "TDUserNotificationCenter.h"
#import "TDClassUtils.h"
#import "TDSDKExtension.h"
#import "TDReplySelectedHandler.h"
#import "TDConfiguration.h"
#import "TDConstants.h"
#import "TDNotification.h"
#import "TDUIApplication.h"

#ifdef _IOS_10_FUNCTIONALITY
#import <UserNotifications/UserNotifications.h>
#endif

@implementation TDUserNotificationCenter

#ifdef _IOS_10_FUNCTIONALITY
static UNUserNotificationCenter * currentNC = nil;
#endif

+ (void)installTDUserNotifications {
#ifdef _IOS_10_FUNCTIONALITY
	//insert our custom set delegate override that will install all delegate functionality
	putMethodInTarget([TDUserNotificationCenter class], @selector(setTDDelegate:), [UNUserNotificationCenter class], @selector(setDelegate:));

	currentNC = [UNUserNotificationCenter currentNotificationCenter];
	if (currentNC.delegate == nil) {
		TendartsSDK* instance = [TendartsSDK instance];
		currentNC.delegate = (id)instance;
	}
#endif
}

#ifdef _IOS_10_FUNCTIONALITY
- (void)setTDDelegate:(id)delegate {
	NSLog(@"Set delegate: user notification center");
	Class existingDelegate =  searchAncestorImplementingProtocol([delegate class], @protocol(UNUserNotificationCenterDelegate));
	NSArray * childs = getChilds(existingDelegate);
	
	//install our methods:
	installOverrideMethod([TDUserNotificationCenter class],
						  @selector(TDUNC:willPresentNotification:withCompletionHandler:),
						  existingDelegate,
						  childs,
						  @selector(userNotificationCenter:willPresentNotification:withCompletionHandler:));
	
	installOverrideMethod([TDUserNotificationCenter class],
						  @selector(TDUNC:didReceiveNotificationResponse:withCompletionHandler:),
						  existingDelegate,
						  childs,
						  @selector(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:));
	
	//call esxisting
	if ([self respondsToSelector:@selector(setTDDelegate:)]) {
		[self setTDDelegate:delegate];
	}
}

- (void)TDUNC:(UNUserNotificationCenter *)center
				willPresentNotification:(UNNotification *)notification
				  withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
	//notify openned notification
	NSLog(@"td: willPresentNotification");
	completionHandler( UNAuthorizationOptionBadge|  UNAuthorizationOptionSound | UNAuthorizationOptionAlert);
}

//Called to let your app know which action was selected by the user for a given notification.
- (void)TDUNC:(UNUserNotificationCenter *)center
		 didReceiveNotificationResponse:(UNNotificationResponse *)response
				  withCompletionHandler:(void(^)(void))completionHandler {
	NSLog(@"td: didReceiveNotificationResponse");
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    NSArray *current = [userInfo objectForKey:@"r"];
    
    if (current) {
        for (NSDictionary *buttonDict in current) {
            if ([response.actionIdentifier isEqualToString: [buttonDict objectForKey:@"t"]]) {
                #if !(IN_APP_EXTENSION)
                if ([[buttonDict objectForKey:@"p"] containsString:@"://"]) {
                    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [buttonDict objectForKey:@"p"]] options: @{} completionHandler:^(BOOL success) {
                        // Open URL
                    }];
                    //[[UIApplication sharedApplication] openURL: [NSURL URLWithString: [buttonDict objectForKey:@"p"]]];
                }
                [TendartsSDK actionSelected: [buttonDict objectForKey:@"id"]];
                NSString *code = [TDConfiguration getPushCode];
                NSString *device = [[TDConstants instance]buildUrlOfType:URL_TYPE_DEVICES andId:code];
                [TDReplySelectedHandler replySelected: [buttonDict objectForKey:@"id"]
                                               device: device
                                            onSuccess: ^{
                                                //success
                                            }
                                              onError: ^(NSString * _Nullable error) {
                                                  //error
                                              }];
                
                TDNotification * notification = [[TDNotification alloc]initWithDictionary:userInfo];
                [TendartsSDK onNotificationOpened:notification withHandler:^{
                }];
                #endif
                break;
            }
        }
    }
    
	completionHandler();
}

#endif

@end
