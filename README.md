
给 iOS 开发方向的同学提供方便的SCAUCS.NET 中的 Web Services 接口调用功能。

## How To Get Started

* 将 Classes 目录拷贝到你的工程目录下，并命名为 ServiceClient。

* 将 AFNetworking, GDataXMLNode 等目录拷贝到你工程目录下。

* 在你的工程里面新建名为 Third 的 Group, 将上述三项拉进去。

* 为你的工程添加以下 Framework：
  - libxml2.dylib
  
* 为你的工程添加头文件搜索路径(Header Search Paths)：
  - /usr/include/libxml2
  
* 为 GDataXMLNode.m 添加 -fno-objc-arc flags
  - [Build Phases] -> [Compile Sources]

* 在需要用到的地方 #import "ServiceClient.h" 即可。

有问题可以跟我联系: ccnyou@qq.com


### What's New

2014-4-1  实现了同步 commonCall 接口

2014-4-1  实现了同步 getMyCourseDetail 接口

2014-3-29 实现了同步 userLogin 接口

## Requirements

Xcode 5.0 以上

iOS SDK 7.0

## Usage

```objective-c

//获取登陆session
ServiceClient client = [[ServiceClient alloc] init];
NSString* session = [client userLogin:userName andPswMD5:pswMD5];
NSLog(@"%s %d session = %@", __FUNCTION__, __LINE__, session);

```


```objective-c

//获取课程以及通知
NSArray* arrays = [_client getMyCourseDetail:userName andSession:session];
for (NSArray* array in arrays) {
    for (NSString* str in array) {
        NSLog(@"%s %d %@", __FUNCTION__, __LINE__, str);
    }
}

```

```objective-c

//调用任意接口
NSDictionary* params = @{
                         @"strUserNumber" : @"201131000602",
                         @"strSession" : session
                         };
NSData* xmlData = [ServiceClient commonCall:@"GetMyHomeWorkDetail" andParams:params];
NSString* xmlString = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
NSLog(@"%s %d %@", __FUNCTION__, __LINE__, xmlString);

```
## Contact

新浪微博 ([@陈聪宁](http://weibo.com/ccnyou))

