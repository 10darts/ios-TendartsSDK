
#import "LocationUtils.h"
#import "TDConfiguration.h"
#import "TDConstants.h"
#import "TDCommunications.h"
#import "TDSDKExtension.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationUtils () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDate *lastUpdate;
@property ( nonatomic,strong) NSDate *lastReload;
@property (nonatomic,strong) NSTimer *cutoffTimer;
@property (nonatomic,strong) NSTimer *reloadTimer;
@property (nonatomic, strong) CLLocation *lastLocation;
@property BOOL updating;

@property NSInteger secondsInterval;
@end

static LocationUtils * _instance = nil;

@implementation LocationUtils

+ (LocationUtils *)instance {
	if (_instance == nil) {
		_instance = [[LocationUtils alloc]init];
		_instance.locationManager                = [[CLLocationManager alloc] init];
		_instance.locationManager.delegate       =_instance;
		_instance.locationManager.desiredAccuracy=kCLLocationAccuracyThreeKilometers;
		_instance.locationManager.distanceFilter = kCLDistanceFilterNone;
		_instance.secondsInterval = 120;
		_instance.updating = NO;
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

		NSDictionary *dic =[userDefaults objectForKey:@"TDCoordinate"] ;
		NSNumber *lat = [dic objectForKey:@"lat"];
		NSNumber *lon = [dic objectForKey:@"lon"];
		NSNumber *acc =[dic objectForKey:@"acc"];
		CLLocationCoordinate2D loc;
		loc.latitude = lat.doubleValue;
		loc.longitude = lon.doubleValue;
		NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:0];
		
		_instance.lastLocation = [[CLLocation alloc] initWithCoordinate:loc altitude:0 horizontalAccuracy:acc.doubleValue verticalAccuracy:0 timestamp:date ];
	}
	return _instance;
}

- (void)dealloc {
	[self.cutoffTimer invalidate];
	self.cutoffTimer = nil;
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
}

- (id)init {
	if ((self = [super init])) {
		self.locationManager = [CLLocationManager new];
		self.locationManager.delegate = self;
	}
	return self;
}

+ (NSDictionary *)getLocationData {
	LocationUtils * me = [LocationUtils instance];
	if (me.lastLocation.coordinate.latitude == 0 || me.lastLocation.coordinate.longitude == 0) {
		return nil;
	}
    
	NSArray * array = [NSArray arrayWithObjects:
					   [NSNumber numberWithDouble: me.lastLocation.coordinate.longitude],
					   [NSNumber numberWithDouble:me.lastLocation.coordinate.latitude],
					   nil];
	NSDictionary * position = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"Point", @"type",
						  array, @"coordinates",
						  nil];
	return position;
}

+ (void) startUpdating {
	LocationUtils * me = [LocationUtils instance];
	me.updating = YES;
	me.cutoffTimer = [NSTimer scheduledTimerWithTimeInterval:me.secondsInterval/2
													  target:me
													selector:@selector(cutoffTimerFired:)
													userInfo:nil
													 repeats:NO];
	[me waitForNext];
	
	if ([me.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
		[me.locationManager requestWhenInUseAuthorization];
	}

	[me.locationManager startUpdatingLocation];
}

+ (void)stopUpdating {
	LocationUtils * me = [LocationUtils instance];
	me.updating = NO;
	[me stopUpdatesKeepingMonitoring];
}

- (void)stopUpdatesKeepingMonitoring {
	[self.locationManager stopUpdatingLocation];
	[self.cutoffTimer invalidate];
	self.cutoffTimer = nil;
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
	
}

BOOL isAuthorized() {
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    return (authStatus == kCLAuthorizationStatusAuthorizedAlways
            || authStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
}

- (void)waitForNext {
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:self.secondsInterval
														target:self
													  selector:@selector(reloadFired:)
													  userInfo:nil
													   repeats:NO];
}

- (void)cutoffTimerFired:(NSTimer *)cutoffTimer {
	[self stopUpdatesKeepingMonitoring];
}

- (void)reloadFired:(NSTimer *)timer {
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
	NSLog(@"locations: reloadfired");
	[LocationUtils startUpdating];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	NSLog(@"locations: new locations arrived");
	for (CLLocation *location in locations) {
		if (location.horizontalAccuracy <= 1000 && location.horizontalAccuracy >=0) {
			self.lastLocation = location;
			[self stopUpdatesKeepingMonitoring];
			[self waitForNext];
			//save coordinates
			[self saveLocation:location];
			
			NSLog(@"locations: new location %@", location);
			
			[[NSNotificationCenter defaultCenter] postNotificationName:[LocationUtils getLocationChangedNotificationId] object:self userInfo:nil];
			return;
		} else if (!self.lastLocation || location.horizontalAccuracy < self.lastLocation.horizontalAccuracy) {
			self.lastLocation = location;
		}
	}
}

+ (NSString *)getLocationChangedNotificationId {
	return @"TDLocationChangedNotification";
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"locations: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if( newLocation.horizontalAccuracy < self.lastLocation.horizontalAccuracy && newLocation.horizontalAccuracy >=0) {
		self.lastLocation = newLocation;
		[self saveLocation:newLocation];
	}
	NSLog(@"Locations:OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
	NSLog(@"Locations:NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)saveCurrentCountryInUserDefault {
	NSLog(@"locations: save current country");
	self.locationManager                = [[CLLocationManager alloc] init];
	self.locationManager.delegate       =self;
	self.locationManager.desiredAccuracy=kCLLocationAccuracyThreeKilometers;
	self.locationManager.distanceFilter = kCLDistanceFilterNone;
	
	if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
		[self.locationManager requestWhenInUseAuthorization];
	} else {
		[self.locationManager startUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	NSLog(@"locations: changeAuthorizationStatus");
	if (isAuthorized()) {
		if (self.updating) {
			[LocationUtils startUpdating];
		}
	} else if (status == kCLAuthorizationStatusNotDetermined) {
		if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
			[self.locationManager requestWhenInUseAuthorization];
		}
	}
}

- (void)saveLocation:(CLLocation*)location {
	NSLog(@"locations: saving location");
	NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
	NSNumber *lon = [NSNumber numberWithDouble:location.coordinate.longitude];
	NSDictionary *coordinate = @{@"lat":lat, @"lon":lon, @"acc":[NSNumber numberWithDouble:location.horizontalAccuracy]};
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:coordinate forKey:@"TDCoordinate"];
	[userDefault synchronize];

	static int n_sent = 0;
	NSDate *last =[TDConfiguration getLastGeostatsSent];
	
	if (last == nil  ||n_sent++ <5 || [last timeIntervalSinceNow] < -60) {
		if( location.coordinate.latitude == 0) {
			n_sent++;
        } else {
			//send geostats
			NSString *code = [TDConfiguration getPushCode];
			NSString *url =  [[TDConstants instance] devices];
			if (code != nil) {
				NSDictionary *loc =[LocationUtils getLocationData];
				NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
									loc,@"position",
									  [NSString stringWithFormat:@"acc:%f",location.horizontalAccuracy], @"debug_info",
									  nil];
				
				NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];

				
				url = [[TDConstants instance] getDeviceUrl:code];
				[TDCommunications sendData:data toURl:url withMethod:@"PATCH"
						  onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)
				 {
					 [TDConfiguration saveLastGeostatsSent:[NSDate date]];
					 [TendartsSDK logEventWithCategory:@"DEVICE" type:@"location succesfully sent" andMessage:json.description];
				 }onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode)

				 {
					 [TendartsSDK logEventWithCategory:@"DEVICE" type:@"Error sending location" andMessage:json.description];
				}];
			}
		}
	}
	
	
	CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
	
	[reverseGeocoder reverseGeocodeLocation:location
						  completionHandler:^(NSArray *placemarks, NSError *error){
							  [userDefault setObject:[[placemarks firstObject] ISOcountryCode]
											  forKey:@"TDCurrentCountryCode"];
							  [userDefault setObject:[[placemarks firstObject] locality]
											  forKey:@"TDCurrentCity"];
							  [userDefault synchronize];
						  }];
	
}

+ (BOOL)isDiferentCountry:(NSString *)codeCountry {
	codeCountry = [codeCountry uppercaseString];
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	if ([codeCountry isEqual:[userDefault valueForKey:@"TDCurrentCountryCode"]]) {
		return NO;
	}
	
	return YES;
}

+ (NSString *)getCurrentCity {
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	
	return [user objectForKey:@"TDCurrentCity"]!=nil ? [user objectForKey:@"TDCurrentCity"] : NSLocalizedString(@"notAvailable", nil);
}

@end
