//
//  AudioFile.m
//  AudioFiles
//
//  Created by Alexey Boyko on 19.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import "AudioFile.h"

@import AVFoundation;

@implementation AudioFile

- (id)initWithName:(NSString *)name Location:(NSURL *)location
{
    self = [super init];
    if (self != nil)
    {
        self.location = location;
        self.title = @"generic title";
        self.artist = @"generic artist";
        [self getMetadata];
    }
    return self;
}

-(void)getMetadata{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.location options:nil];

    NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
    NSArray *artists = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon];
    NSLog(@"titles\n%@", titles);
    NSLog(@"artists\n%@", artists);
/*
    AVMetadataItem *title = [titles objectAtIndex:0];
    AVMetadataItem *artist = [artists objectAtIndex:0];
    
    self.title = title.stringValue;
    self.artist = artist.stringValue;*/
}

@end
