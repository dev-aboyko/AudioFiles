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

- (id)initWithLocation:(NSURL *)location
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

- (void)getMetadata
{
    AVAsset* asset = [AVURLAsset URLAssetWithURL:self.location options:nil];
    for (NSString *format in asset.availableMetadataFormats)
    {
        for (AVMetadataItem *item in [asset metadataForFormat:format])
        {
            if ([[item commonKey] isEqualToString:@"title"])
                self.title = (NSString *)[item value];
            if ([[item commonKey] isEqualToString:@"artist"])
                self.artist = (NSString *)[item value];
        }
    }
}

@end
