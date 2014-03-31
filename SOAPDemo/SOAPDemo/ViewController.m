//
//  ViewController.m
//  SOAPDemo
//
//  Created by ccnyou on 14-3-26.
//  Copyright (c) 2014年 ccnyou. All rights reserved.
//

#import "ViewController.h"
#import "ServiceClient.h"
#import <CommonCrypto/CommonDigest.h>
#import "GDataXMLNode.h"

@interface ViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) IBOutlet UITextField* userNameTextField;
@property (nonatomic, strong) IBOutlet UITextField* pswTextField;
@property (nonatomic, strong) IBOutlet UITextView* textView;

@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, strong) ServiceClient* client;
@end

@implementation ViewController

- (void)test
{
    //NSString* xml = [NSString stringWithContentsOfFile:@"/Users/ccnyou/Desktop/data.txt" encoding:NSUTF8StringEncoding error:nil];
    NSData* xmlData = [[NSData alloc] initWithContentsOfFile:@"/Users/ccnyou/Desktop/data.txt"];
    
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    GDataXMLElement* rootElement = [doc rootElement];
    GDataXMLNode* node = [rootElement childAtIndex:0];
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, [node name]);
    
    node = [node childAtIndex:0];
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, [node name]);
    
    node = [node childAtIndex:0];
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, [node name]);
    

    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSArray* array = [node children];
    for (GDataXMLElement* objNode in array) {
        NSLog(@"%s %d %@", __FUNCTION__, __LINE__, [objNode name]);
        
        NSMutableArray* strings = [[NSMutableArray alloc] initWithCapacity:5];
        NSArray* elems = [objNode children];
        for (GDataXMLElement* elem in elems) {
            NSLog(@"%s %d %@", __FUNCTION__, __LINE__, [elem stringValue]);
            [strings addObject:[elem stringValue]];
        }
        
        if ([strings count] > 0) {
            [results addObject:strings];
        }
    }
    

}

- (void)viewDidLoad
{
    //[self test];
    
    [super viewDidLoad];
    //密码输入
    _pswTextField.secureTextEntry = YES;
    
    //来个圆角
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 5.0;
    //只读
    _textView.editable = NO;
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userName = [userDefaults objectForKey:@"UserName"];
    NSString* psw = [userDefaults objectForKey:@"Password"];
    
    if (userName.length > 0) {
        _userNameTextField.text = userName;
    }
    
    if (psw.length > 0) {
        _pswTextField.text = psw;
    }
    
    _client = [[ServiceClient alloc] init];
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

#pragma mark - Touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Action

- (IBAction)loginClick:(id)sender
{
    [self.view endEditing:YES];

    NSString* userName = _userNameTextField.text;
    NSString* psw = _pswTextField.text;
    
    if (userName.length == 0 || psw.length == 0) {
        _textView.text = @"请输入登陆信息";
        return;
    }
    
    NSString* pswMD5 = [self md5:psw];
    //记住密码
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:@"UserName"];
    [userDefaults setObject:psw forKey:@"Password"];
    [userDefaults synchronize];
    
    NSString* session = [_client userLogin:userName andPswMD5:pswMD5];
    _textView.text = session;
    //NSLog(@"%s %d", __FUNCTION__, __LINE__);
    
    //测试获取课程以及通知
    NSArray* arrays = [_client getMyCourseDetail:userName andSession:session];
    for (NSArray* array in arrays) {
        for (NSString* str in array) {
            NSLog(@"%s %d %@", __FUNCTION__, __LINE__, str);
        }
    }
}



@end
