//
//  ViewController.m
//  SOAPDemo
//
//  Created by ccnyou on 14-3-26.
//  Copyright (c) 2014年 ccnyou. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface ViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) IBOutlet UITextField* userNameTextField;
@property (nonatomic, strong) IBOutlet UITextField* pswTextField;
@property (nonatomic, strong) IBOutlet UITextView* textView;

@property (nonatomic, strong) NSURLConnection* connection;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _pswTextField.secureTextEntry = YES;
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userName = [userDefaults objectForKey:@"UserName"];
    NSString* psw = [userDefaults objectForKey:@"Password"];
    
    if (userName.length > 0) {
        _userNameTextField.text = userName;
    }
    
    if (psw.length > 0) {
        _pswTextField.text = psw;
    }
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
    NSString* userName = _userNameTextField.text;
    NSString* psw = _pswTextField.text;
    NSString* pswMD5 = [self md5:psw];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:@"UserName"];
    [userDefaults setObject:psw forKey:@"Password"];
    [userDefaults synchronize];
    
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
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _connection = connection;

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _textView.text = str;
    

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, error);
    NSString* errorMsg = [NSString stringWithFormat:@"错误：%@", error];
    _textView.text = errorMsg;
}

@end
