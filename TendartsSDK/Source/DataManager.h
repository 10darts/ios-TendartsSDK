//
//  DataManager.h
//  Pods
//
//  Created by Ruben Blanco on 9/11/17.
//

#import <Foundation/Foundation.h>

#import "Persona.h"
#import "Device.h"

static NSString * const kRequest = @"kRequest";
static NSString * const kQueue = @"kQueue";
static NSString * const kPersona = @"kPersona";
static NSString * const kDevice = @"kDevice";

OBJC_ROOT_CLASS

@interface DataManager

+ (void)saveObject:(NSObject *) object forKey:(NSString *) aKey;

+ (Persona *)persona;
+ (Device *)device;
+ (Device *)loadDevice;
+ (NSArray *)request;
- (NSArray *)loadRequest;
+ (void)queueStatus:(BOOL)aValue;
+ (BOOL)queueStatus;

@end

