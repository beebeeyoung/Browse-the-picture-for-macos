//
//  ViewController.h
//  PicTool
//
//  Created by yanghaifeng on 2018/8/5.
//  Copyright © 2018年 yanghaifeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController


{
    NSThread* scanThread;
    NSView*   planeView;
    int       circleDegree;
    NSMutableArray*  fileSet;
}
- (IBAction)scan:(nullable id)sender;
- (IBAction)adjustPlane:(nullable id)sender;
- (IBAction)adjustPlaneEx:(nullable id)sender;
-(IBAction)rotate:(id)sender;
@property IBOutlet NSImageView* imageView;
@property IBOutlet NSButton*    nextButton;
@property IBOutlet NSButton*    planeButton;
@property IBOutlet NSTextField* nameText;
@property IBOutlet NSButton*    rotateButton;

@end

