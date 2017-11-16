//
//  TDDeviceHandler.m
//  Tendarts
//
//  Created by Ruben Blanco on 16/11/17.
//  Copyright © 2017 10darts. All rights reserved.
//

#import "TDDeviceHandler.h"
#import "TDAPIService.h"
#import "TDConfiguration.h"
#import "TDConstants.h"

@implementation TDDeviceHandler

+ (void) deviceToken:(NSString *)aToken
            language:(NSString *)aLanguage
             version:(NSString *)aVersion
               model:(NSString *)aModel
            platform:(NSString *)aPlatform
            location:(NSDictionary *)aLocation
               group:(NSString *)aGroup {

    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          aToken, @"token",
                          aPlatform, @"platform",
                          aLanguage,@"language",
                          aVersion,@"version",
                          aModel, @"model",
                          aLocation,@"position",
                          nil];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject: dict
                                                   options: 0
                                                     error: nil];
    
    NSString * tokenAndVersion = [aToken stringByAppendingString: aVersion];
    NSString * saved = [TDConfiguration getTokenAndVersion];
    NSString * code = [TDConfiguration getPushCode];
    
    if (code == nil || ![tokenAndVersion isEqualToString:saved]) {
        NSString * method = REQUEST_METHOD_POST;
        NSString *url =  [[TDConstants instance] devices];
        
        if (code != nil) {
            url = [[TDConstants instance] getDeviceUrl:code];
            method = REQUEST_METHOD_PATCH;
        }
        
        [TDAPIService deviceWithData: data
                                 url: url
                              method: method
                    onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                        [TendartsSDK logEventWithCategory: @"PUSH"
                                                     type: @"token_sent_ok"
                                               andMessage: json.description];
                        
                        NSString * code = [json objectForKey: @"code"];
                        if (code != nil) {
                            [TDConfiguration savePushCode: code
                                               withApiKey: [TDConfiguration getAPIKey]
                                             andGroupName: aGroup];
                            if (statusCode == 201) {
                                [TDConfiguration saveTokenAndVersion: tokenAndVersion];
                            }
                        }
                        
                        NSString *persona = [json objectForKey:@"persona"];
                        if (persona != nil) {
                            [TDConfiguration saveUserCode: persona];
                        }
                        
                    }
                      onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                          [TendartsSDK logEventWithCategory: @"PUSH"
                                                       type: @"Error sending token"
                                                 andMessage: json.description];
                      }];
    }
    
}

@end
