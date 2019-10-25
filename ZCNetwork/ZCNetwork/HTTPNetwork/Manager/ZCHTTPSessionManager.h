//
//  ZCHTTPSessionManager.h
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
/**
ZCPinningModeNone: App Transport Security Settings -> Allow Arbitrary Loads -> YES
ZCPinningModeOneself: App Transport Security Settings -> Exception Domains -> [domain1,domain2...]
 -> domain{ NSIncludesSubdomains:YES, NSExceptionRequiresForwardSecrecy:NO,NSExceptionAllowsInsecureHTTPLoads }
 ZCPinningModeCA: App Transport Security Settings不做任何处理
 */
typedef NS_ENUM(NSInteger,ZCPinningMode) {
    ZCPinningModeNone = 0,///<不验证无效证书（没有证书），不验证域名
    ZCPinningModeOneself = 1,///<不验证无效证书（自签证书），不验证域名
    ZCPinningModeCA = 2,///<CA认证，验证无效证书，验证域名
};

@interface ZCHTTPSessionManager : AFHTTPSessionManager
@property (nonatomic, assign) ZCPinningMode mode;///<默认None，注意：图片等三方资源如果支持https，也要加到Exception Domains中

@end
