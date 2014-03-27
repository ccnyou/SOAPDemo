//
//  ServiceClient.m
//  SOAPDemo
//
//  Created by ccnyou on 14-3-28.
//  Copyright (c) 2014年 ccnyou. All rights reserved.
//

#import "ServiceClient.h"
#import "GDataXMLNode.h"

typedef enum {
    MethodNameNone,
    MethodNameUserLogin,
    MethodNameInvalid
}MethodName;

@interface ServiceClient () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, strong) NSMutableDictionary* connDict;
@property (nonatomic, strong) NSCondition* condition;
@property (nonatomic, assign) MethodName methodName;

@end

@implementation ServiceClient

- (id)init
{
    if ([super init]) {
        _connDict = [[NSMutableDictionary alloc] init];
        _condition = [[NSCondition alloc] init];
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
    
    NSString* serverUrlString = @"http://wcf.scaucs.net/mainservice.svc";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrlString]];
    [request addValue:@"\"http://tempuri.org/IMainService/UserLogin\"" forHTTPHeaderField:@"SOAPAction"];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request setValue:[NSString stringWithFormat:@"%d", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%s %d responseString = %@", __FUNCTION__, __LINE__, responseString);
    
    if (data) {
        GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        GDataXMLElement* rootElement = [doc rootElement];
        GDataXMLNode* node = [rootElement childAtIndex:0];
        node = [node childAtIndex:0];
        node = [node childAtIndex:0];
        resultString = [node stringValue];
        //NSLog(@"%s %d %@", __FUNCTION__, __LINE__, resultString);
    }
    
    return resultString;
}

@end
