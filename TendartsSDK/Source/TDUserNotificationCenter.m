
#import "TendartsSDK.h"
#import "TDUserNotificationCenter.h"
#import "TDClassUtils.h"
#import "TendartsSDK.h"

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
				  withCompletionHandler:(void(^)())completionHandler {
	NSLog(@"td: didReceiveNotificationResponse");
	completionHandler();
}

#endif

@end
