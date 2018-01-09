//
//  VODUploadDemo.m
//  VODUploadDemo
//
//  Created by Leigang on 16/4/19.
//
//

#import "VODUploadDemo.h"

NSString* testUploadAuth = @"";
NSString* testUploadAddress = @"";

static NSString* const testAccessKeyId = @"";
static NSString* const testAccessKeySecret = @"";

static NSString* const testSecretToken = @"";
static NSString* const testExpireTime = @"";

static NSString * const endpoint = @"http://oss-cn-beijing.aliyuncs.com";
static NSString * const bucketName = @"aliyunvod";

static int fileSize = 10240000;
static int pos = 0;


static VODUploadClient *uploader;

@implementation VODUploadDemo

- (void) addFile {
    NSString *name = [NSString stringWithFormat:@"%d.demo.ios.mp4", pos];
    NSString *filePath = [self createTempFile:name fileSize:fileSize];
    NSString *ossObject = [NSString stringWithFormat:@"uploadtest/%d.ios.demo.mp4", pos];

    
    VodInfo *vodInfo = [[VodInfo alloc] init];
    vodInfo.title = [NSString stringWithFormat:@"IOS标题%d", pos];
    vodInfo.desc = [NSString stringWithFormat:@"IOS描述%d", pos];
    vodInfo.cateId = @(19);
    vodInfo.coverUrl = [NSString stringWithFormat:@"http://www.taobao.com/IOS封面URL%d", pos];
    vodInfo.tags = [NSString stringWithFormat:@"IOS标签1%d, IOS标签2%d", pos, pos];
    if ([self isVodMode]) {
        vodInfo.isShowWaterMark = NO;
        vodInfo.priority = [NSNumber numberWithInt:7];
    } else {
        vodInfo.userData = [NSString stringWithFormat:@"IOS用户数据%d。", pos];
    }

    if ([self isVodMode]) {
        // 点播上传。每次上传都是独立的OSS object，所以添加文件时，不需要设置OSS的属性
        [uploader addFile:filePath vodInfo:vodInfo];
    } else {
        [uploader addFile:filePath endpoint:endpoint bucket:bucketName object:ossObject vodInfo:vodInfo];
    }
    
    NSLog(@"Add file: %@", filePath);
    pos++;
}

- (void) deleteFile {
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = [uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader deleteFile:index];
    NSLog(@"Delete file: %@", fileName);
}

- (void) cancelFile {
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = [uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader cancelFile:index];
    NSLog(@"cancelFile file: %@", fileName);

}

- (void) resumeFile {
    NSMutableArray<UploadFileInfo *> *list = [uploader listFiles];
    if ([list count] <= 0) {
        return;
    }
    
    int index = [uploader listFiles].count-1;
    NSString *fileName = [list objectAtIndex:index].filePath;
    [uploader resumeFile:index];
    NSLog(@"resumeFile file: %@", fileName);

}

- (NSMutableArray<UploadFileInfo *> *)listFiles {
    return [uploader listFiles];
}

- (void) clearList {
    [uploader clearFiles];
}

- (void) start {
    [uploader start];
}

- (void) stop {
    [uploader stop];
}

- (void) pause {
    [uploader pause];
}

- (void) resume {
    [uploader resume];
}

- (void)resumeWithAuth:(NSString *)auth {
    testUploadAuth = auth;
    [uploader resumeWithAuth:auth];
}

#pragma mark - temp_file
// create a file with size of fileSize in the fixed path, and return the file path.
- (NSString *)createTempFile : (NSString * ) fileName fileSize : (int) size {
    NSString * tempFileDirectory;
    NSString * path = NSHomeDirectory();
    tempFileDirectory = [NSString stringWithFormat:@"%@/%@/%@", path, @"tmp", fileName];
    NSFileManager * fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:tempFileDirectory]){
        return tempFileDirectory;
    }
    
    [fm createFileAtPath:tempFileDirectory contents:nil attributes:nil];
    NSFileHandle * fh = [NSFileHandle fileHandleForWritingAtPath:tempFileDirectory];
    NSMutableData * basePart = [NSMutableData dataWithCapacity:size];
    for (int i = 0; i < size/4; i++) {
        u_int32_t randomBit = arc4random();
        [basePart appendBytes:(void*)&randomBit length:4];
    }
    [fh writeData:basePart];
    [fh closeFile];
    return tempFileDirectory;
}

- (id) initWithListener:listener {
    self = [super init];
    if (self) {
        uploader = [[VODUploadClient alloc] init];
        if ([self isVodMode]) {
            // 点播上传。每次上传都是独立的鉴权，所以初始化时，不需要设置鉴权
            [uploader init:listener];
        } else if ([self isSTSMode]) {
            // OSS直接上传:STS方式，安全但是较为复杂，建议生产环境下使用。
            // 临时账号过期时，在onUploadTokenExpired事件中，用resumeWithToken更新临时账号，上传会续传。
            [uploader init:testAccessKeyId accessKeySecret:testAccessKeySecret secretToken:testSecretToken expireTime:testExpireTime listener:listener];
        } else {
            // OSS直接上传:AK方式，简单但是不够安全，建议测试环境下使用。
            [uploader init:testAccessKeyId accessKeySecret:testAccessKeySecret listener:listener];
        }
    }
    
    return self;
}

- (BOOL) isVodMode {
    return (nil != testUploadAuth && [testUploadAuth length] > 0 &&
            nil != testUploadAddress && [testUploadAddress length] > 0);
}

- (BOOL) isSTSMode {
    if (![self isVodMode]) {
        return (nil != testSecretToken && nil != testExpireTime &&
                [testSecretToken length] > 0 && [testExpireTime length] > 0);
    }
    return false;
}

- (void) setUploadAuth:(UploadFileInfo *) fileInfo {
    if ([self isVodMode]) {
        [uploader setUploadAuthAndAddress:fileInfo
                     uploadAuth:testUploadAuth
                  uploadAddress:testUploadAddress];
    }
    NSLog(@"upload started: %@ %@ %@ %@",
          fileInfo.filePath, fileInfo.endpoint, fileInfo.bucket,
          fileInfo.object);
}

@end
