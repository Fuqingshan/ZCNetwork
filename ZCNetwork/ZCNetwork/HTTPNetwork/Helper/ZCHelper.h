//
//  ZCHelper.h
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCHelper : NSObject

+ (NSString *)idfa;

+ (NSString *)idfv;

+ (NSString *)platform;///<iphone or ipad

+ (NSString *)clientVersion;

+ (NSString *)deviceModel;

+ (NSString *)networkType;

/// ip address
/// @param preferIPv4 if YES, prefer ipv4
+ (NSString *)ipAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
