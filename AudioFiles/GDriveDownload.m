//
//  GDriveDownload.m
//  AudioFiles
//
//  Created by Alexey Boyko on 19.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import "GDriveDownload.h"
#import "ViewController.h"

@interface GDriveDownload ()

@property (nonatomic, strong) NSString* downloadID;
@property (nonatomic, weak) id<GDriveDownloadDelegate> delegate;
@property (nonatomic, strong) NSURL* docDirectoryURL;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;

@end

@implementation GDriveDownload

- (id)initWithDownloadID:(NSString*)downloadID delegate:(id<GDriveDownloadDelegate>)delegate{
    self = [super init];
    if (self != nil)
    {
        self.downloadID = downloadID;
        self.delegate = delegate;
        NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        self.docDirectoryURL = [URLs objectAtIndex:0];
    }
    return self;
}

- (void)startDownload{
    if ([self fileExists])
        return;
    NSString* string = [NSString stringWithFormat:@"https://drive.google.com/uc?export=download&confirm=no_antivirus&id=%@", self.downloadID];
    NSURL* URL = [NSURL URLWithString:string];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    self.downloadTask = [self.session downloadTaskWithURL:URL];
    [self.downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:self.downloadID];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]])
        [fileManager removeItemAtURL:destinationURL error:nil];
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    if (success)
        [self.delegate downloadSuccess:destinationURL];
    else
        [self.delegate downloadError:self];
}

- (BOOL)fileExists
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:self.downloadID];
    [self.delegate downloadSuccess:destinationURL];
    return [fileManager fileExistsAtPath:[destinationURL path]];
}

@end
