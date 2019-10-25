//
//  ZCJSONRequestSerializer.m
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import "ZCJSONRequestSerializer.h"

@implementation ZCJSONRequestSerializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeoutInterval = 10.f;//设置超时时间
        [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }
    return self;
}

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error{
    NSMutableURLRequest * request = [super requestWithMethod:method
                                                    URLString:URLString
                                                   parameters:parameters
                                                        error:error];
    //此处可对request 做修改
    
    return request;
}

@end
