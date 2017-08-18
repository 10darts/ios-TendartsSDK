//
//  PushUtils.h
//  sdk
//
//  Created by Jorge Arimany on 5/7/17.
//  Copyright © 2017 10Darts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushUtils : NSObject
+(void) savePushToken:(NSString *)token inSharedGroup:(NSString*) group;
@end
