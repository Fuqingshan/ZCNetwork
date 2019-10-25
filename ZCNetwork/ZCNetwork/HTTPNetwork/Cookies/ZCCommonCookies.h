//
//  ZCCommonCookies.h
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCommonCookies : NSObject

+ (NSDictionary *)commonCookies;

+ (NSString *)cookiesWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
