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
@import AVFoundation;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* fileList;
@property (nonatomic, strong) GDriveDownload* download;
@property (nonatomic) NSUInteger idxDownloading;
@property AVAudioPlayer* player;
@property AudioFile* nowPlaying;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.fileList = nil;
    self.player = nil;
    self.nowPlaying = nil;
    NSLog(@"downloading file list");
    self.download = [[GDriveDownload alloc] initWithDownloadID:@"0BwpVZ-NgHEeRV1AwcUd0RTB0M0E" delegate:self];
    [self.download forceDownload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Download files

- (void)downloadSuccess:(NSURL*)location
{
    if (self.fileList == nil)
    {
        NSString* links = [NSString stringWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        self.fileList = [[links componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
        [self.fileList removeObject:@""];
        self.idxDownloading = 0;
    }
    else
    {
        NSString* fileName = [self.fileList objectAtIndex:self.idxDownloading];
        AudioFile* audioFile = [[AudioFile alloc]initWithName:fileName Location:location];
        [self.fileList replaceObjectAtIndex:self.idxDownloading withObject:audioFile];
        ++self.idxDownloading;
    }
    if (self.idxDownloading < self.fileList.count)
    {
        NSString* fileName = [self.fileList objectAtIndex:self.idxDownloading];
        NSLog(@"downloading %@", fileName);
        self.download = [[GDriveDownload alloc] initWithDownloadID:fileName delegate:self];
        [self.download startDownload];
    }
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
}

- (void)reloadTable
{
    [self.tableView reloadData];
}

- (void)downloadError:(GDriveDownload*)download
{
    NSLog(@"download error");
}

#pragma mark - Play

- (void)play:(AudioFile*)audioFile
{
    NSError *error;
    if (self.player != nil || audioFile == self.nowPlaying)
    {
        [self.player stop];
        self.player = nil;
    }
    else
    {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFile.location error:&error];
        [self.player prepareToPlay];
        [self.player play];
    }
}

- (void)stopPlaying{
    if (self.player != nil)
    {
        [self.player stop];
        self.player = nil;
    }
}

#pragma mark - Table view data source

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    id obj = [self.fileList objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FileIDCell"];
        cell.textLabel.text = obj;
    }
    else if ([obj isKindOfClass:[AudioFile class]])
    {
        AudioFile* audioFile = obj;
        cell = [tableView dequeueReusableCellWithIdentifier:@"AudioFileCell"];
        cell.textLabel.text = audioFile.title;
        cell.detailTextLabel.text = audioFile.artist;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    if (self.fileList != nil)
        numberOfRows = self.fileList.count;
    else
        numberOfRows = 0;
    return numberOfRows;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.fileList objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[AudioFile class]])
        [self play:obj];
    else
        [self stopPlaying];
}

@end
