//
//  VODUploadDemo.h
//  VODUploadDemo
//
//  Created by Leigang on 16/4/19.
//
//

#import <Foundation/Foundation.h>
#import <VODUpload/VODUploadClient.h>

@interface DemoFileInfo : UploadFileInfo
@property NSInteger percent;
@end

@interface VODUploadDemo : NSObject
- (id) initWithListener:listener;

- (void) addFile;
- (void) deleteFile;
- (void) cancelFile;
- (void) resumeFile;

- (NSMutableArray<UploadFileInfo *> *)listFiles;
- (void) clearList;

- (void) start;
- (void) stop;
- (void) pause;
- (void) resume;

- (void) setUploadAuth:(UploadFileInfo *) fileInfo;

- (void)resumeWithAuth:(NSString *)auth;

@end
