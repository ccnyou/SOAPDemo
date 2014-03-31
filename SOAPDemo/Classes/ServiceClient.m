//
//  ServiceClient.m
//  SOAPDemo
//
//  Created by ccnyou on 14-3-28.
//  Copyright (c) 2014年 ccnyou. All rights reserved.
//

#import "ServiceClient.h"
#import "GDataXMLNode.h"

#define SERVER_URL  @"http://wcf.scaucs.net/mainservice.svc"

//暂时没用
//typedef enum {
//    MethodNameNone,
//    MethodNameUserLogin,
//    MethodNameInvalid
//}MethodName;

@interface ServiceClient () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

//都暂时没用
//@property (nonatomic, strong) NSURLConnection* connection;
//@property (nonatomic, strong) NSMutableDictionary* connDict;
//@property (nonatomic, strong) NSCondition* condition;
//@property (nonatomic, assign) MethodName methodName;

@end

@implementation ServiceClient



- (id)init
{
    if ([super init]) {
//        _connDict = [[NSMutableDictionary alloc] init];
//        _condition = [[NSCondition alloc] init];
        return self;
    }
    
    return nil;
}


- (NSString *)userLogin:(NSString *)userName andPswMD5:(NSString *)pswMD5
{
    NSString* resultString = nil;
    //构造请求
    NSMutableString* bodyString = [NSMutableString stringWithString:@"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
    [bodyString appendString:@"<s:Body><UserLogin xmlns=\"http://tempuri.org/\">"];
    [bodyString appendFormat:@"<strUserName>%@</strUserName>", userName];
    [bodyString appendFormat:@"<strPassWordMd5>%@</strPassWordMd5>", pswMD5];
    [bodyString appendString:@"</UserLogin></s:Body></s:Envelope>"];
    NSData* bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* serverUrlString = SERVER_URL;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrlString]];
    [request addValue:@"\"http://tempuri.org/IMainService/UserLogin\"" forHTTPHeaderField:@"SOAPAction"];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSAssert(error == nil, @"err = %@", error);
    
    if (data) {
        GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        GDataXMLElement* rootElement = [doc rootElement];
        GDataXMLNode* node = [rootElement childAtIndex:0];
        node = [node childAtIndex:0];
        node = [node childAtIndex:0];
        NSAssert([[node name] isEqualToString:@"UserLoginResult"], @"貌似出错了，返回数据不是 UserLoginResult");
        
        resultString = [node stringValue];
    }
    
    return resultString;
}


- (NSArray *)getMyCourseDetail:(NSString *)userName andSession:(NSString *)session
{
    NSMutableArray* resultArray = nil;
    
    //构造请求
    NSMutableString* bodyString = [NSMutableString stringWithString:@"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
    [bodyString appendString:@"<s:Body><GetMyCourseDetail xmlns=\"http://tempuri.org/\">"];
    [bodyString appendFormat:@"<strUserNumber>%@</strUserNumber>", userName];
    [bodyString appendFormat:@"<strSession>%@</strSession>", session];
    [bodyString appendString:@"</GetMyCourseDetail></s:Body></s:Envelope>"];
    NSData* bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* serverUrlString = SERVER_URL;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrlString]];
    [request addValue:@"\"http://tempuri.org/IMainService/GetMyCourseDetail\"" forHTTPHeaderField:@"SOAPAction"];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSError* error = nil;
    NSData* xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSAssert(error == nil, @"err = %@", error);
    
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    GDataXMLElement* rootElement = [doc rootElement];
    GDataXMLNode* node = [rootElement childAtIndex:0];
    node = [node childAtIndex:0];
    node = [node childAtIndex:0];
    
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSArray* array = [node children];
    for (GDataXMLElement* objNode in array) {
        NSAssert([[objNode name] isEqualToString:@"a:ArrayOfstring"], @"貌似出错了，返回数据不是一个字符串数组");
        
        NSMutableArray* strings = [[NSMutableArray alloc] initWithCapacity:5];
        NSArray* elems = [objNode children];
        for (GDataXMLElement* elem in elems) {
            [strings addObject:[elem stringValue]];
        }
        
        if ([strings count] > 0) {
            [results addObject:strings];
        }
    }
    
    resultArray = results;
    return resultArray;
}

@end
