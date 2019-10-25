//
//  ZCHTTPSessionManager.m
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import "ZCHTTPSessionManager.h"

@implementation ZCHTTPSessionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mode = ZCPinningModeNone;
    }
    return self;
}

- (void)setMode:(ZCPinningMode)mode{
    switch (mode) {
        case ZCPinningModeNone:
        {
            self.securityPolicy.allowInvalidCertificates = YES;
            self.securityPolicy.validatesDomainName = NO;
        }
            break;
        case ZCPinningModeOneself:
        {
            self.securityPolicy.allowInvalidCertificates = YES;
            self.securityPolicy.validatesDomainName = NO;
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            self.securityPolicy = securityPolicy;
        }
            break;
        case ZCPinningModeCA:
        {
            self.securityPolicy.allowInvalidCertificates = NO;
            self.securityPolicy.validatesDomainName = YES;
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            self.securityPolicy = securityPolicy;
        }
            break;
    }
}

@end
