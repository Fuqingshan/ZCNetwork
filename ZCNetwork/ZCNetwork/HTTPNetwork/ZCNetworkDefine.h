//
//  ZCNetworkDefine.h
//  ZCNetwork
//
//  Created by yier on 2019/10/24.
//  Copyright © 2019 yier. All rights reserved.
//

#ifndef ZCNetworkDefine_h
#define ZCNetworkDefine_h

typedef  NS_ENUM(NSInteger,ZCJSONError){
    ZCJSONErrorUnkonw = -700000,
    ZCJSONErrorResultError = -700001,
    ZCJSONErrorUploadFileEmpty = -700002///<上传文件不能为空
};

static NSString *const ZCJSONDomain = @"com.zc.jsondomain";

#endif /* ZCNetworkDefine_h */
