
#import "TDNotification.h"

#ifndef TDNOTIFICATIONDEFS

#define TDNOTIFICATIONDEFS
#define TDN_DEEP_URL @"dl"
#define TDN_MESSAGE @"body"
#define TDN_TITLE @"title"
#define TDN_ORIGIN @"org"
#define TDN_SILENT @"sil"
#define TDN_CONFIRMATION @"cfm"
#define TDN_DESTINATION @"dst"
#define TDN_D_CONTENT @"dsc"
#define TDN_NID @"id"
#define TDN_NNOT @"not"
#define TDN_CONTENT_ID @"dsc"
#define TDN_CONTENT_TYPE @"dst"
#define TDN_IMAGE @"img"
#define TDN_USER_DATA @"ctm"

#endif

@interface TDNotification ()

+ (NSDictionary *)getProperDictionary: (NSDictionary*)dict;

@end

@implementation TDNotification

- (id)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		NSDictionary *old = nil;
        
		if (dict == nil) {
			self.data = [[NSDictionary alloc]init];
		} else {
			old = dict;
			self.data = [TDNotification getProperDictionary:dict];
		}
		
		NSObject * current = [self.data objectForKey:@"aps"];
        
		if (current) {
			current = [(NSDictionary *)current objectForKey:@"alert"];
			if ([[current class] isSubclassOfClass:[NSDictionary class]]) {
				self.message = [(NSDictionary*)current objectForKey:TDN_MESSAGE];
				self.title = [(NSDictionary*)current objectForKey:TDN_TITLE];
				
			} else {
                self.message = (NSString *)current;
			}
		}
		
		self.read = false;
		self.deepLink = [dict objectForKey:TDN_DEEP_URL];
		self.timeStamp = [NSDate date];
		
        NSNumber* number = [dict objectForKey:TDN_SILENT];
		
        if (number != nil && [number integerValue] == 1) {
			self.silent = YES;
        } else {
			self.silent = NO;
		}
        
		number = [dict objectForKey:TDN_CONFIRMATION];
        
		if (number != nil && [number integerValue] == 1) {
			self.confirm = YES;
		} else {
			self.confirm = NO;
		}
        
		self.nId = [dict objectForKey:TDN_NID];
		self.nNot = [dict objectForKey:TDN_NNOT];
		self.contentId = [dict objectForKey:TDN_CONTENT_ID];
		self.contentType = [dict objectForKey:TDN_CONTENT_TYPE];
		self.image = [dict objectForKey:TDN_IMAGE];
		self.alreadySent = [dict objectForKey:@"sentReceived"];
		self.userData = [dict objectForKey:TDN_USER_DATA];
	}
	return self;
}

+ (NSDictionary *)getProperDictionary: (NSDictionary*)dict {
	NSDictionary *data = dict;
	NSDictionary *new = [dict objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
	
	if (new != nil) {
		data = new;
    } else {
		data = dict;
	}
	//message compatibility with and withour apns
	NSObject * apns =[data objectForKey:@"APNS"];
	if (apns) {
		data = (NSDictionary *)apns;
	}
	return data;
}

+ (BOOL)isTendartsNotification: (NSDictionary*)data {
	NSDictionary* dict = [TDNotification getProperDictionary:data];
	return [@"10d" isEqualToString:[dict objectForKey:TDN_ORIGIN]];
}

@end
