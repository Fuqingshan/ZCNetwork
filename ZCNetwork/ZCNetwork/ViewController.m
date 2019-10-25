//
//  ViewController.m
//  ZCNetwork
//
//  Created by yier on 2019/10/22.
//  Copyright © 2019 yier. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ZCFileModel.h"
#import "TestDownloadAPI.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (nonatomic, strong) TestDownloadAPI *api;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *dic = @{}.mutableCopy;
    for (NSInteger i = 0; i< 100;i++) {
        [dic setObject:@(i) forKey:[NSString stringWithFormat:@"key%zd",i]];
    }
    
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(NSString *key, id value) = x;
        NSLog(@"key is %@, value is %@",key ,value);
    }];
    
    NSLog(@"**********************end**********************");
    
    self.api = [[TestDownloadAPI alloc] init];
}


- (IBAction)downloadImg:(id)sender {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"1.jpg"];
    
    ZCFileModel *file = [[ZCFileModel alloc] init];
    file.fileURL = [NSURL fileURLWithPath:path];
    
    @weakify(self);
    [[self.api request:@{@"file":file}] subscribeNext:^(id  _Nullable x) {
       @strongify(self);
        NSLog(@"%@",x);
        if ([x isKindOfClass:[NSURL class]]) {
            NSData *data = [NSData dataWithContentsOfURL:x options:NSDataReadingMappedIfSafe error:nil];
            self.img.image = [UIImage imageWithData:data];
        }
    }];
}

@end
