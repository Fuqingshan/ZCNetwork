//
//  ZCCommonCookies.m
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import "ZCCommonCookies.h"
#import "ZCHelper.h"

@implementation ZCCommonCookies

+ (NSDictionary *)commonCookies{
    NSString *idfa = [ZCHelper idfa];
    NSString *idfv = [ZCHelper idfv];
    NSString *ip = [ZCHelper ipAddress:YES];
    NSString *model = [ZCHelper deviceModel];
    NSString *platform = [ZCHelper platform];
    NSString *network = [ZCHelper networkType];
    NSString *clientVersion = [ZCHelper clientVersion];

    NSMutableDictionary *cookies = @{}.mutableCopy;
    if (idfa.length > 0) { [cookies setObject:idfa forKey:@"idfa"]; }
    if (idfv.length > 0) { [cookies setObject:idfv forKey:@"idfv"]; }
    if (ip.length > 0) { [cookies setObject:ip forKey:@"ip"]; }
    if (model.length > 0) { [cookies setObject:model forKey:@"model"]; }
    if (platform.length > 0) { [cookies setObject:platform forKey:@"platform"]; }
    if (network.length > 0) { [cookies setObject:network forKey:@"network"]; }
    if (clientVersion.length > 0) { [cookies setObject:clientVersion forKey:@"client_v"]; }
    
    return cookies;
}

+ (NSString *)cookiesWithParams:(NSDictionary *)params{
    
    if (![params isKindOfClass:[NSDictionary class]]) return @"";
    
    NSMutableString *cookieString = @"".mutableCopy;
    for (NSString *key in params.allKeys) {
        NSString *value = params[key];
        if (value.length > 0) [cookieString appendFormat:@"%@=%@; ", key,value];
    }
    return cookieString.copy;
}

@end
