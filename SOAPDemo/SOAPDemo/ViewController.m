//
//  ViewController.m
//  SOAPDemo
//
//  Created by ccnyou on 14-3-26.
//  Copyright (c) 2014年 ccnyou. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UITextField* userNameTextField;
@property (nonatomic, strong) IBOutlet UITextField* pswTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _pswTextField.secureTextEntry = YES;
    
    //NSLog(@"%s %d %@", __FUNCTION__, __LINE__, [self md5:@"223669"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UserMethods

- (NSString *)md5:(NSString *)src
{
    const char* cstr = [src UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, strlen(cstr), digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}


#pragma mark - Action

- (IBAction)loginClick:(id)sender
{
//    NSString* userName = _userNameTextField.text;
//    NSString* psw = _pswTextField.text;
//    NSString* pswMD5 = [self md5:psw];
    
    NSString* bodyString = @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    "<s:Body>"
    "<UserLogin xmlns=\"http://tempuri.org/\">"
        "<strUserName>201131000602</strUserName>"
        "<strPassWordMd5>ec40ac9437cbeb0c16ff9d67891d4db3</strPassWordMd5>"
    "</UserLogin>"
    "</s:Body>"
    "</s:Envelope>";
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"\"http://tempuri.org/IMainService/UserLogin\"" forHTTPHeaderField:@"SOAPAction"];
    manager.requestSerializer = requestSerializer;
    
    NSDictionary* requestHeaders = requestSerializer.HTTPRequestHeaders;
    for (id obj in requestHeaders) {
        NSLog(@"%s %d %@", __FUNCTION__, __LINE__, obj);
    }
    
    //AFHTTPResponseSerializer* responseSerilizer = manager.responseSerializer;
    //NSLog(@"%s %d %@, %@", __FUNCTION__, __LINE__, requestSerializer, responseSerilizer);
    
    
    
    
    //AFHTTPResponseSerializer* responseSerilizer = [AFHTTPResponseSerializer serializer];
    AFXMLParserResponseSerializer* responseSerilizer = [AFXMLParserResponseSerializer serializer];
    //NSSet* set = [responseSerilizer acceptableContentTypes];
    //set = [set setByAddingObject:@"text/xml;charset=utf-8"];
    manager.responseSerializer = responseSerilizer;
    
    [manager POST:@"http://wcf.scaucs.net/mainservice.svc" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"%s %d formData = %@", __FUNCTION__, __LINE__, formData);
        NSData* data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithHeaders:nil body:data];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s %d %@", __FUNCTION__, __LINE__, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s %d error = %@", __FUNCTION__, __LINE__, error);
    }];
    
}

@end
