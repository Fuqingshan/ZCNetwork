//
//  ZCJSONResponseSerializer.m
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import "ZCJSONResponseSerializer.h"
#import "ZCNetworkDefine.h"

@implementation ZCJSONResponseSerializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.acceptableContentTypes = [NSSet setWithObjects:
                               @"application/json",
                               @"text/json",
                               @"text/javascript",
                               @"text/html",
                               @"text/plain",
                               nil
                               ];
    }
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error{
    id json = [super responseObjectForResponse:response data:data error:error];
    //此处对返回数据做统一处理...
    if (*error != nil) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:NSLocalizedStringFromTable(@"对不起，服务器发生错误。请稍后再试。", @"ZCNetwork", nil)
                    forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:ZCJSONDomain
                                     code:ZCJSONErrorUnkonw
                                 userInfo:userInfo];
        return nil;
    }
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultJson = (NSDictionary *)json;
        NSString *jsonCode = [resultJson[@"code"] description];
        NSString *jsonMessage = [resultJson[@"message"] description];
        if (jsonCode.intValue != 0) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:[NSString stringWithFormat:NSLocalizedStringFromTable(@"%@", @"ZCNetwork", nil), jsonMessage]
                         forKey:NSLocalizedDescriptionKey];
            [userInfo setValue:json
                         forKey:@"data"];
            *error = [NSError errorWithDomain:ZCJSONDomain
                                         code:ZCJSONErrorResultError
                                     userInfo:userInfo];
            return nil;
        }else{
            //缓存服务器响应的cookies信息
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields]
                                                                       forURL:httpResponse.URL];
            for (NSHTTPCookie *cookie in cookies) {
                NSMutableDictionary * cookieProperties = [[cookie properties] mutableCopy];
                NSHTTPCookie *newCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:newCookie];
            }
            return resultJson;
        }
    
    }else {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:NSLocalizedStringFromTable(@"对不起，服务器发生错误。请稍后再试。", @"ZCNetwork", nil)
                    forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:ZCJSONDomain
                                     code:ZCJSONErrorUnkonw
                                userInfo:userInfo];
        return nil;
    }
    return json;
}


@end
