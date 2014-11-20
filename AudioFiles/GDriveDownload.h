//
//  GDriveDownload.h
//  AudioFiles
//
//  Created by Alexey Boyko on 19.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDriveDownload;

@protocol GDriveDownloadDelegate

- (void)downloadSuccess:(NSURL*)location;
- (void)downloadError:(GDriveDownload*)download;

@end

@interface GDriveDownload : NSObject <NSURLSessionDelegate>

- (id)initWithLink:(NSString*)link delegate:(id<GDriveDownloadDelegate>)delegate;
- (void)startDownload;
- (void)forceDownload;

@end
