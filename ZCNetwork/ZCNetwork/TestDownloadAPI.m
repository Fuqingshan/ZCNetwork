//
//  TestDownloadAPI.m
//  ZCNetwork
//
//  Created by yier on 2019/10/24.
//  Copyright © 2019 yier. All rights reserved.
//

#import "TestDownloadAPI.h"

@implementation TestDownloadAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mothod = ZCHTTPMethod_DOWNLOAD;
    }
    return self;
}

- (AFHTTPSessionManager *)httpSessionManager{
    ZCHTTPSessionManager *manager_ = [[ZCHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    manager_.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager_.responseSerializer = [AFImageResponseSerializer serializer];
    
    return manager_;
}

- (NSString *)path{
    return @"https://ws3.sinaimg.cn/large/006tNbRwgy1fy3rvsnzsbj30dw099mx5.jpg";
}

@end
