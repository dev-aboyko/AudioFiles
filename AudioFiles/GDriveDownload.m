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

@property (nonatomic, strong) NSString* link;
@property (nonatomic, weak) id<GDriveDownloadDelegate> delegate;
@property (nonatomic, strong) NSURL* docDirectoryURL;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;
@property (nonatomic) BOOL checkFileExists;

@end

@implementation GDriveDownload

- (id)initWithLink:(NSString*)link delegate:(id<GDriveDownloadDelegate>)delegate{
    self = [super init];
    if (self != nil)
    {
        self.link = link;
        self.delegate = delegate;
        NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        self.docDirectoryURL = [URLs objectAtIndex:0];
        self.checkFileExists = YES;
    }
    return self;
}

- (void)startDownload
{
    NSURL* URL = [NSURL URLWithString:self.link];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    self.downloadTask = [self.session downloadTaskWithURL:URL];
    [self.downloadTask resume];
}
        
- (void)forceDownload
{
    self.checkFileExists = NO;
    [self startDownload];
}

- (void)URLSession:(NSURLSession *)session
               downloadTask:(NSURLSessionDownloadTask *)downloadTask
               didWriteData:(int64_t)bytesWritten
          totalBytesWritten:(int64_t)totalBytesWritten
  totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.checkFileExists)
    {
        NSString* fileName = [[downloadTask response] suggestedFilename];
        if ([self fileExists:fileName])
        {
            NSLog(@"file exists canceling download");
            [downloadTask cancel];
        }
    }
    self.checkFileExists = NO;
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)downloadTask.response;
    if(httpResponse.statusCode != 200)
    {
        NSLog(@"%@", downloadTask.response);
        [self.delegate downloadError:self];
        return;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:[[downloadTask response] suggestedFilename]];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]])
        [fileManager removeItemAtURL:destinationURL error:nil];
    
    NSError *error;
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    if (success)
        [self.delegate downloadSuccess:destinationURL];
    else
        [self.delegate downloadError:self];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (error != nil && error.code != NSURLErrorCancelled)
        [self.delegate downloadError:self];
}

- (BOOL)fileExists:(NSString*)fileName{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:fileName];
    if([fileManager fileExistsAtPath:[destinationURL path]])
    {
        [self.delegate downloadSuccess:destinationURL];
        return YES;
    }
    return NO;
}

@end
