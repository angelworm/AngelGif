//
//  AGAppDelegate.m
//  AngelGif
//
//  Copyright (c) 2012年 中島 進. All rights reserved.
//

#import "AGAppDelegate.h"

@implementation AGAppDelegate

@synthesize movie;
@synthesize movieView;
@synthesize firstTime;
@synthesize endTime;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self openDocument:nil];
}

- (void)setTime:(long long)time_{
    QTTime time = [movie currentTime];
    time.timeValue = time_;
    [movie setCurrentTime:time];
}

- (IBAction)setMin:(id)sender {
    firstTime = [movie currentTime].timeValue;
}

- (IBAction)setMax:(id)sender {
    endTime = [movie currentTime].timeValue;
}

- (IBAction)exportGif:(id)sender {
    
    long duration = [movie duration].timeValue;
    long frame = [movie currentTime].timeValue;
    [movie stepBackward];
    frame -= [movie currentTime].timeValue;
    [movie stepForward];
    
    long long len = (endTime - firstTime);
    len = len / frame;
    
    NSLog(@"%ld/%ld/%lld",frame,[movie duration].timeScale, [movie duration].timeValue);
    NSLog(@"%d",(int)(((double)frame) / [movie currentTime].timeScale * 100 * 2));
    
    [self setTime:firstTime];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"animated.gif"];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(CFBridgingRetain([NSURL fileURLWithPath:path]),
                                                                        kUTTypeGIF,
                                                                        len/2,
                                                                        NULL);
    
    
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:
                                     [NSDictionary dictionaryWithObject:
                                      [NSNumber numberWithFloat:
                                       ((double)frame) / [movie currentTime].timeScale * 2]
                                                                 forKey:(NSString *)kCGImagePropertyGIFDelayTime]
                                                                forKey:(NSString *)kCGImagePropertyGIFDictionary];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:
                                   [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0]
                                                               forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    for(int i = 0; i < len/2; i++) {
        NSLog(@"writing %lld",[movie currentTime].timeValue);
        for (id img  in [[movie currentFrameImage] representations] ) {
            CGImageDestinationAddImage(destination, [img CGImage],
                                       (CFDictionaryRef)CFBridgingRetain(frameProperties));
        }
        [movie stepForward];
        [movie stepForward];
    }
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)CFBridgingRetain(gifProperties));
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    
}

- (IBAction)test:(id)sender {
    [self setTime:firstTime];
    [movie play];
}

- (IBAction)previousFrame:(id)sender {
    [movie stepBackward];
}

- (IBAction)nextFrame:(id)sender {
    [movie stepForward];
}
- (IBAction)moveSelectionEnd:(id)sender {
    [self setTime:endTime];
}

- (IBAction)moveSelectFirst:(id)sender {
    [self setTime:firstTime];
}
- (IBAction)openDocument:(id)sender {
    NSOpenPanel* diag = [NSOpenPanel openPanel];
    [diag setAllowsMultipleSelection:NO];
    [diag setAllowedFileTypes:@[@"mov"]];
    [diag setCanChooseDirectories:NO];
    
    if ( [diag runModal] == NSOKButton ) {
        if(![QTMovie canInitWithURL:[diag URL]])
            NSLog(@"tesecase");
        
        // Insert code here to initialize your application
        NSError *err;
        movie = [QTMovie movieWithURL:[diag URL] error:&err];
        NSLog(@"%@",[err description]);
        [movieView setMovie:movie];
    }
    
    
}
@end