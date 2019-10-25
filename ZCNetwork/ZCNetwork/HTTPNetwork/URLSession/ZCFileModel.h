//
//  ZCFileModel.h
//  ZCNetwork
//
//  Created by yier on 2019/10/24.
//  Copyright © 2019 yier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCFileModel : NSObject
//上传文件方式，fileURL和fileData 二选一
@property(nonatomic, strong) NSURL *fileURL;///<本地文件数据保存的路径，下载时不能为空
@property(nonatomic, strong) NSData *fileData;///<本地文件数据

@property(nonatomic, copy) NSString *name;///<服务端定义，常见为"file"
@property(nonatomic, copy) NSString *fileName;///<服务端以什么格式保存，比如"xxx.png"
@property(nonatomic, copy) NSString *mimeType;

@end

/** 常见mimeType以及File extensions
 application/msword    doc
 application/pdf    pdf
 application/rtf    rtf
 application/vnd.ms-excel    xls
 application/vnd.ms-powerpoint    ppt
 application/x-rar-compressed    rar
 application/x-shockwave-flash    swf
 application/zip    zip
 audio/midi    mid midi kar
 audio/mpeg    mp3
 audio/ogg    ogg
 audio/x-m4a    m4a
 audio/x-realaudio    ra
 image/gif    gif
 image/jpeg    jpeg jpg
 image/png    png
 image/tiff    tif tiff
 image/vnd.wap.wbmp    wbmp
 image/x-icon    ico
 image/x-jng    jng
 image/x-ms-bmp    bmp
 image/svg+xml    svg svgz
 image/webp    webp
 text/css    css
 text/html    html htm shtml
 text/plain    txt
 text/xml    xml
 video/3gpp    3gpp 3gp
 video/mp4    mp4
 video/mpeg    mpeg mpg
 video/quicktime    mov
 video/webm    webm
 video/x-flv    flv
 video/x-m4v    m4v
 video/x-ms-wmv    wmv
 video/x-msvideo    avi
  */
