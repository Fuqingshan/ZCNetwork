//
//  ZCBaseAPI.h
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "ZCHTTPSessionManager.h"

FOUNDATION_EXTERN NSString * const ZCHTTPMethod_GET;
FOUNDATION_EXTERN NSString * const ZCHTTPMethod_POST;
FOUNDATION_EXTERN NSString * const ZCHTTPMethod_UPLOAD;///<params中参数file为@[ZCFileModel,ZCFileModel...]
FOUNDATION_EXTERN NSString * const ZCHTTPMethod_DOWNLOAD;

@interface ZCBaseAPI : NSObject
@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;
@property (nonatomic, weak, readonly) NSURLSessionTask *currentTask;

@property (nonatomic, copy) NSString *method;///<HTTPMethod, default is GET
@property (nonatomic, copy) NSDictionary *commonCookies;///<default cookies
@property (nonatomic, assign) NSTimeInterval timeoutInterval;///< set timeout, default is 10s

/** 以下函数 子类均可根据需求进行重写 */

- (AFHTTPSessionManager *)httpSessionManager;

- (RACSignal *)request:(NSDictionary *)params;

/** API PATH */
- (NSString *)path;

/** API Request 相关固定参数 */
- (NSDictionary *)commonParams;

/** cookie 追加的cookies */
- (NSDictionary *)cookies;

/** header 追加的header，注意：headerFields如果追加了Cookie字段会被cookies覆盖 */
- (NSDictionary *)headerFields;

@end
