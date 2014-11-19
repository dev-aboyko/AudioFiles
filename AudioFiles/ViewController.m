//
//  ViewController.m
//  AudioFiles
//
//  Created by Alexey Boyko on 18.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import "ViewController.h"
#import "GDriveDownload.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) GDriveDownload* download;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.download = [[GDriveDownload alloc] initWithDownloadID:@"0BwpVZ-NgHEeRM2R4SGpyQnVJMG8" delegate:self];
    [self.download startDownload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadSuccess:(NSURL*)location
{
    NSLog(@"download success to %@", location);
}

- (void)downloadError:(GDriveDownload*)download
{
    NSLog(@"download error");
}

@end
