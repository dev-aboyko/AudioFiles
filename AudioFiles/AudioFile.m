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
    }
    return self;
}

@end
