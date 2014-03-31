//
//  ServiceClient.h
//  SOAPDemo
//
//  Created by ccnyou on 14-3-28.
//  Copyright (c) 2014年 ccnyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceClient : NSObject

- (NSString *)userLogin:(NSString *)userName andPswMD5:(NSString *)pswMD5;
- (NSArray *)getMyCourseDetail:(NSString *)userName andSession:(NSString *)session;

@end
