//
//  TDAccessHandler.m
//  Tendarts
//
//  Created by Ruben Blanco on 16/11/17.
//  Copyright © 2017 10darts. All rights reserved.
//

#import "TDAccessHandler.h"
#import "TDAPIService.h"
#import "TDConfiguration.h"
#import "PushUtils.h"

@implementation TDAccessHandler

+ (void)accessWithUrl:(NSString *)aUrl {
    [TDAPIService accessWithData: nil
                             url: aUrl
                          method: REQUEST_METHOD_POST
                onSuccessHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                    [TendartsSDK logEventWithCategory: @"SDK"
                                                 type: @"Access sent"
                                           andMessage: json.description];
                }
                  onErrorHandler:^(NSDictionary *json, NSData *data, NSInteger statusCode) {
                      [TendartsSDK logEventWithCategory: @"SDK"
                                                   type: @"Error sending access"
                                             andMessage: json.description];
                      if (data != nil && data.length > 0 && statusCode == 404) {
                          NSString * token = [TDConfiguration getPushToken];
                          if (token != nil) {
                              [PushUtils savePushToken: token
                                         inSharedGroup: [TDConfiguration getSharedGroup]];
                          }
                      }
                  }];
}

@end
