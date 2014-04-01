//
//  ServiceClient.h
//  SOAPDemo
//
//  Created by ccnyou on 14-3-28.
//  Copyright (c) 2014年 ccnyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class ServiceClient;

@protocol ServiceClientDelegate <NSObject>

@optional
- (void)serviceClient:(ServiceClient *)client loginCompletedWithResult:(NSString *)result;
- (void)serviceClient:(ServiceClient *)client loginFailedWithError:(NSError *)error;

@end


@interface ServiceClient : NSObject

@property (nonatomic, weak) id<ServiceClientDelegate> delegate;

//同步登陆
- (NSString *)userLogin:(NSString *)userName andPswMD5:(NSString *)pswMD5;
//同步 获取课程信息以及通知
- (NSArray *)getMyCourseDetail:(NSString *)userName andSession:(NSString *)session;
//通用同步方法调用
+ (NSData *)commonCall:(NSString *)methodName andParams:(NSDictionary *)params;
//异步登陆接口
- (void)userLoginAsync:(NSString *)userName andPswMD5:(NSString *)pswMD5;

@end

