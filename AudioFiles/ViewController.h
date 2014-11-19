//
//  ViewController.h
//  AudioFiles
//
//  Created by Alexey Boyko on 18.11.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDriveDownload.h"

@interface ViewController : UIViewController <GDriveDownloadDelegate, UITableViewDataSource, UITableViewDelegate>

@end

