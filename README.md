
给 iOS 开发方向的同学提供方便的SCAUCS.NET 中的 Web Services 接口调用功能。

## How To Get Started

等待整理，有问题可以跟我联系: ccnyou@qq.com

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AFNetworking in your projects. See the ["Getting Started" guide for more information](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking).

### What's New

实现了同步调用 Login 的封装

## Requirements

Xcode 5.0 以上
iOS 7.0

## Usage

```objective-c

ServiceClient client = [[ServiceClient alloc] init];
NSString* session = [client userLogin:userName andPswMD5:pswMD5];
NSLog(@"%s %d session = %@", __FUNCTION__, __LINE__, session);

```

## Contact

新浪微博 ([@陈聪宁](http://weibo.com/ccnyou))

