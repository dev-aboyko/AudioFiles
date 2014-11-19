//
//  AudioFile.m
//  AudioFiles
//
//  Created by Alexey Boyko on 19.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import "AudioFile.h"

@implementation AudioFile

- (id)initWithName:(NSString *)name Location:(NSURL *)location
{
    self = [super init];
    if (self != nil)
    {
        self.location = location;
    }
    return self;
}

@end
