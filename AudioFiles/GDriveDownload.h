//
//  GDriveDownload.h
//  AudioFiles
//
//  Created by Alexey Boyko on 19.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDriveDownload : NSObject <NSURLSessionDelegate>

- (id)initWithDownloadID:(NSString*)downloadID;
- (void)startDownload;

@end
