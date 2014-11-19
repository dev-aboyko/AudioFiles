//
//  AudioFile.h
//  AudioFiles
//
//  Created by Alexey Boyko on 19.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioFile : NSObject

@property NSURL* location;

- (id)initWithName:(NSString*)name Location:(NSURL*)location;

@end
