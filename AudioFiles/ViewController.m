//
//  ViewController.m
//  AudioFiles
//
//  Created by Alexey Boyko on 18.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import "ViewController.h"
#import "GDriveDownload.h"
#import "AudioFile.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* fileList;
@property (nonatomic, strong) GDriveDownload* download;
@property (nonatomic) NSUInteger idxDownloading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fileList = nil;
    self.download = [[GDriveDownload alloc] initWithDownloadID:@"0BwpVZ-NgHEeRM2R4SGpyQnVJMG8" delegate:self];
    [self.download startDownload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadSuccess:(NSURL*)location
{
    if (self.fileList == nil)
    {
        NSString* links = [NSString stringWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        self.fileList = [[links componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
        self.idxDownloading = 0;
    }
    else
    {
        NSString* fileName = [self.fileList objectAtIndex:self.idxDownloading];
        [self.fileList replaceObjectAtIndex:self.idxDownloading withObject:[[AudioFile alloc]initWithName:fileName Location:location]];
        ++self.idxDownloading;
    }
    if (self.idxDownloading < self.fileList.count)
    {
        NSString* fileName = [self.fileList objectAtIndex:self.idxDownloading];
        self.download = [[GDriveDownload alloc] initWithDownloadID:fileName delegate:self];
        [self.download startDownload];
    }
}

- (void)downloadError:(GDriveDownload*)download
{
    NSLog(@"download error");
}

@end
