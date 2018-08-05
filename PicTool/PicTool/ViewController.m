//
//  ViewController.m
//  PicTool
//
//  Created by yanghaifeng on 2018/8/5.
//  Copyright © 2018年 yanghaifeng. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFiles];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *fileName = [fileSet objectAtIndex:0];
    [_nameText setStringValue:fileName];
    [_nameText setEnabled:NO];
    NSString *resourceFile = [resourcePath stringByAppendingPathComponent:fileName];
    NSImage* image = [[NSImage alloc] initWithContentsOfFile:resourceFile];
    [_imageView setImage:image];
    // Do any additional setup after loading the view.
    scanThread = nil;
    planeView = [[NSView alloc] initWithFrame:[_imageView bounds]];
    [[self view] addSubview:planeView];
    [planeView setHidden:YES];
    circleDegree = 0;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)scan:(nullable id)sender{
    NSButton* btn = (NSButton*) sender;
    NSControlStateValue state = [btn state];
    if(NSControlStateValueOn == state)
    {
        scanThread = [[NSThread alloc] initWithTarget:self selector:@selector(scanBodyEx) object:nil];
        [scanThread start];
        [_nextButton setTitle:@"on"];
    }else if (NSControlStateValueOff == state)
    {
        [scanThread cancel];
        [_nextButton setTitle:@"off"];
    }else
    {
        //
    }
    
}

- (void)scanBody{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *resourceFile,*fileName;
    int tick = 0;
    for (int i = 0; ; i++) {
        fileName = [NSString stringWithFormat:@"/8-1P2111009%02i.jpg",i%9 + 1];
        resourceFile = [resourcePath stringByAppendingString:fileName];
        //NSImage* image = [[NSImage alloc] initWithContentsOfFile:resourceFile];//big memory;
        NSImage* image = [[NSImage alloc] initByReferencingFile:resourceFile];
        
        if ([scanThread isCancelled]) {
            return;
        }else
        {
            if (tick % 25 == 0) {
                [_nameText performSelectorOnMainThread:@selector(setStringValue:) withObject:fileName waitUntilDone:NO];
                //[_imageView setImage:image];//execution on main thread is valid;
                [_imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:false];
                
            }else
            {
                i--;
            }
            usleep(2e4);
            tick++;
        }
    }
}

- (void)scanBodyEx{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *resourceFile,*fileName;
    int count = [fileSet count];
    if (count <= 0) {
        return;
    }
    int tick = 0;
    for (int i = 0; ; i++) {
        fileName = [fileSet objectAtIndex:i%count ];
        resourceFile = [[resourcePath stringByAppendingString:@"/"] stringByAppendingString:fileName];
        NSImage* image = [[NSImage alloc] initByReferencingFile:resourceFile];
        
        if ([scanThread isCancelled]) {
            return;
        }else
        {
            if (tick % 25 == 0 ) {
                if ([image isValid]) {
                    [_nameText performSelectorOnMainThread:@selector(setStringValue:) withObject:fileName waitUntilDone:NO];
                    //[_imageView setImage:image];//execution on main thread is valid;
                    [_imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:false];
                }else{
                    continue;
                }
                
            }else
            {
                i--;
            }
            usleep(2e4);
            tick++;
        }
    }
}


- (IBAction)adjustPlane:(nullable id)sender{
    NSButton* btn = (NSButton*) sender;
    NSControlStateValue state = [btn state];
    if (NSControlStateValueOn == state) {
        [btn setTitle:@"planeOn"];
        [planeView setHidden:NO];
        [_imageView setHidden:YES];
        [_nextButton setEnabled:NO];
        [_nameText setHidden:YES];
        [_rotateButton setEnabled:NO];
        NSRect mainRect = [_imageView bounds],curRect = mainRect;
        curRect.size.width /= 3;
        curRect.size.height /=3;
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *resourceFile,*fileName;
        for (int i = 0; i < 9; i++) {
            fileName = [NSString stringWithFormat:@"/8-1P2111009%02i.jpg",i%9 + 1];
            resourceFile = [resourcePath stringByAppendingString:fileName];
            //NSImage* image = [[NSImage alloc] initWithContentsOfFile:resourceFile];//big memory;
            NSImage* image = [[NSImage alloc] initByReferencingFile:resourceFile];
            curRect.origin.x = (i%3)*curRect.size.width;
            curRect.origin.y = (i/3)*curRect.size.height;
            NSImageView *imageView = [[NSImageView alloc] initWithFrame:curRect];
            [imageView setImage:image];
            [planeView addSubview:imageView];
        }
    }
    else if(NSControlStateValueOff == state){
        [btn setTitle:@"planeOff"];
        [planeView setHidden:YES];
        [_imageView setHidden:NO];
        [_nextButton setEnabled:YES];
        [_nameText setHidden:NO];
        [_rotateButton setEnabled:YES];
    }
}

- (IBAction)adjustPlaneEx:(nullable id)sender{
    NSButton* btn = (NSButton*) sender;
    NSControlStateValue state = [btn state];
    int count = [fileSet count];
    int row = sqrt(count),col = row;
    if (row*row < count) {
        col += 1;
        if (row*col < count) {
            row += 1;
        }
    }
    if (NSControlStateValueOn == state) {
        [btn setTitle:@"planeOn"];
        [planeView setHidden:NO];
        [_imageView setHidden:YES];
        [_nextButton setEnabled:NO];
        [_nameText setHidden:YES];
        [_rotateButton setEnabled:NO];
        NSRect mainRect = [_imageView bounds],curRect = mainRect;
        curRect.size.width /= col;
        curRect.size.height /=row;
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *resourceFile,*fileName;
        for (int i = 0; i < count; i++) {
            fileName = [fileSet objectAtIndex:i];
            resourceFile = [[resourcePath stringByAppendingString:@"/"] stringByAppendingString:fileName];
            //NSImage* image = [[NSImage alloc] initWithContentsOfFile:resourceFile];//big memory;
            NSImage* image = [[NSImage alloc] initByReferencingFile:resourceFile];
            curRect.origin.x = (i%col)*curRect.size.width;
            curRect.origin.y = (i/col)*curRect.size.height;
            NSImageView *imageView = [[NSImageView alloc] initWithFrame:curRect];
            [imageView setImage:image];
            [planeView addSubview:imageView];
        }
    }
    else if(NSControlStateValueOff == state){
        [btn setTitle:@"planeOff"];
        [planeView setHidden:YES];
        [_imageView setHidden:NO];
        [_nextButton setEnabled:YES];
        [_nameText setHidden:NO];
        [_rotateButton setEnabled:YES];
    }
}

-(IBAction)rotate:(id)sender {
    circleDegree -= 45;
    [_imageView setFrameCenterRotation:circleDegree];
    

}
-(IBAction)quit:(id)sender{
    NSApplication* app = [NSApplication sharedApplication];
    [app terminate:nil];
}

-(void)getFiles{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath],*fileName,*resourceFile;
    NSFileManager* fileManeger = [NSFileManager defaultManager];
    NSError* err = [[NSError alloc] init];
    fileSet = [fileManeger contentsOfDirectoryAtPath:resourcePath error:&err];
    for (int i = 0; i < [fileSet count]; i++) {
        fileName = [fileSet objectAtIndex:i];
        resourceFile = [[resourcePath stringByAppendingString:@"/"] stringByAppendingString:fileName];
        NSImage* image = [[NSImage alloc] initByReferencingFile:resourceFile];
        if (![image isValid]) {
            [fileSet removeObjectAtIndex:i];
            i--;
        }
    }
}
@end
