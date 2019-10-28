//
//  ZCBaseAPI.m
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import "ZCBaseAPI.h"
#import "ZCJSONRequestSerializer.h"
#import "ZCJSONResponseSerializer.h"
#import "ZCCommonCookies.h"
#import "ZCNetworkDefine.h"
#import "ZCFileModel.h"

NSString * const ZCHTTPMethod_GET = @"GET";
NSString * const ZCHTTPMethod_POST = @"POST";
NSString * const ZCHTTPMethod_UPLOAD = @"UPLOAD";
NSString * const ZCHTTPMethod_DOWNLOAD = @"DOWNLOAD";

@interface ZCBaseAPI()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *manager;
@property (nonatomic, weak, readwrite) NSURLSessionTask *currentTask;

@end

@implementation ZCBaseAPI

- (void)dealloc{
//    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [self httpSessionManager];
        self.method = ZCHTTPMethod_POST;
        self.commonCookies = [ZCCommonCookies commonCookies];
    }
    return self;
}

- (void)configRequest{
    NSDictionary * headerFields_ = [self headerFields];
    
    for (NSString *key in headerFields_.allKeys) {
        id value = headerFields_[key];
        //如果value持有的对象被置空
        if (value) {
            [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    
    NSMutableDictionary *commonCookies_ = self.commonCookies.mutableCopy;
    NSDictionary * cookies = [self cookies];
    if (cookies.count > 0) {
        [commonCookies_ addEntriesFromDictionary:cookies];
    }
    
    NSString * cookiesStr = [ZCCommonCookies cookiesWithParams:commonCookies_];
   if (cookiesStr.length > 0) {
       [self.manager.requestSerializer setValue:cookiesStr forHTTPHeaderField:@"Cookie"];
   }
}

/**GET*/
- (NSURLSessionTask *)getRequest:(NSDictionary *)params
                      subscriber:(id<RACSubscriber>)subscriber{
    NSURLSessionDataTask *task = [self.manager GET:[self path]
                                        parameters:params
                                          progress:nil
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                        [subscriber sendNext:responseObject];
                                        [subscriber sendCompleted];
                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                        [subscriber sendError:error];
                                    }];
    return task;
}

/**POST*/
- (NSURLSessionTask *)postRequest:(NSDictionary *)params
                      subscriber:(id<RACSubscriber>)subscriber{
    NSURLSessionDataTask *task = [self.manager POST:[self path]
                                         parameters:params
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                        [subscriber sendNext:responseObject];
                                        [subscriber sendCompleted];
                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                        [subscriber sendError:error];
                                    }];
    return task;
}

/**UPLOAD */
- (NSURLSessionTask *)uploadRequest:(NSDictionary *)params
                             subscriber:(id<RACSubscriber>)subscriber{
    NSArray<ZCFileModel *> *files = [params objectForKey:@"file"];
    if (files.count == 0) {
        [subscriber sendError:[NSError errorWithDomain:NSLocalizedStringFromTable(@"上传的文件不能为空", @"ZCNetwork", nil) code:ZCJSONErrorUploadFileEmpty userInfo:nil]];
        return nil;
    }
    NSMutableDictionary *tParams = params.mutableCopy;
    [tParams removeObjectForKey:@"file"];
    NSURLSessionDataTask *task = [self.manager
                                  POST:[self path]
                                  parameters:tParams.copy
                                  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                    for (ZCFileModel *file in files) {
                                        if (file.fileURL) {
                                            NSError *error;
                                            [formData appendPartWithFileURL:file.fileURL name:file.name fileName:file.fileName mimeType:file.mimeType error:&error];
                                            NSLog(@"upload error with fileURL：%@\n des: %@",file.fileURL,error);
                                        }else if (file.fileData){
                                            [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
                                        }
                                    }
                                } progress:^(NSProgress * _Nonnull uploadProgress) {
                                    if (uploadProgress) {
                                        int64_t p = uploadProgress.completedUnitCount * 1.0 / uploadProgress.totalUnitCount;
                                        [subscriber sendNext:@(p)];
                                    }
                                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    [subscriber sendNext:responseObject];
                                    [subscriber sendCompleted];
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [subscriber sendError:error];
                                }];
    
    return task;
}

/**DOWNLOAD*/
- (NSURLSessionTask *)downloadRequest:(NSDictionary *)params
                             subscriber:(id<RACSubscriber>)subscriber{
    ZCFileModel *file = [params objectForKey:@"file"];
      if (!file.fileURL) {
          [subscriber sendError:[NSError errorWithDomain:NSLocalizedStringFromTable(@"下载的文件路径不能为空", @"ZCNetwork", nil) code:ZCJSONErrorUploadFileEmpty userInfo:nil]];
          return nil;
      }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self path]]];
    NSURLSessionDownloadTask *task = [self.manager
                                  downloadTaskWithRequest:request
                                  progress:^(NSProgress * _Nonnull downloadProgress) {
                                            if (downloadProgress) {
                                               int64_t p = downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount;
                                               [subscriber sendNext:@(p)];
                                           }
                                    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                        return file.fileURL;
                                    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                        if (!error) {
                                            [subscriber sendNext:filePath];
                                            [subscriber sendCompleted];
                                        }else{
                                            [subscriber sendError:error];
                                        }
                                    }];
    [task resume];
    return task;
}

#pragma mark - get & post

/** request */
- (AFHTTPSessionManager *)httpSessionManager{
    ZCHTTPSessionManager *manager_ = [[ZCHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    manager_.requestSerializer = [ZCJSONRequestSerializer serializer];
    manager_.responseSerializer = [ZCJSONResponseSerializer serializer];
    
    return manager_;
}

- (RACSignal *)request:(NSDictionary *)params{
    return [[self requestCommand] execute:params];
}

- (RACCommand *)requestCommand{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *params) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [self configRequest];
            
            NSMutableDictionary *aParams = @{}.mutableCopy;
            [aParams addEntriesFromDictionary:params];
            if (self.commonParams.count > 0) {
                [aParams addEntriesFromDictionary:self.commonParams];
            }
            
            NSArray *requestMethods = @[
            ZCHTTPMethod_GET
            ,ZCHTTPMethod_POST
            ,ZCHTTPMethod_UPLOAD
            ,ZCHTTPMethod_DOWNLOAD
            ];
            
            NSURLSessionTask * task = nil;
            NSInteger index = [requestMethods indexOfObject:self.method];
            switch (index) {
                case 0:
                    task = [self getRequest:params subscriber:subscriber];
                    break;
                case 1:
                    task = [self postRequest:params subscriber:subscriber];
                    break;
                case 2:
                    task = [self uploadRequest:params subscriber:subscriber];
                    break;
                case 3:
                    task = [self downloadRequest:params subscriber:subscriber];
                    break;
                default://NSNotFound
                    [subscriber sendError:[NSError errorWithDomain:NSLocalizedStringFromTable(@"不支持的请求方式", @"ZCNetwork", nil) code:ZCJSONErrorUnkonw userInfo:nil]];
                    break;
            }
            
            self.currentTask = task;
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    }];
}

/** timeout */
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval{
    self.manager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (NSTimeInterval)timeoutInterval{
    return self.manager.requestSerializer.timeoutInterval;
}

/** API PATH */
- (NSString *)path{
    return @"";
}

/** API Request 相关json参数 */
- (NSDictionary *)commonParams{
    return @{};
}

/** cookie 追加参数 */
- (NSDictionary *)cookies{
    return @{};
}

/** header 追加参数 */
- (NSDictionary *)headerFields{
    return @{};
}

@end
