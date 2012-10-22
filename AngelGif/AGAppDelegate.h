//
//  AGAppDelegate.h
//  AngelGif
//
//  Copyright (c) 2012年 中島 進. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <ImageIO/ImageIO.h>

@interface AGAppDelegate : NSObject <NSApplicationDelegate>

@property (retain) QTMovie *movie;
@property (assign) long long firstTime;
@property (assign) long long endTime;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet QTMovieView *movieView;

- (IBAction)setMin:(id)sender;
- (IBAction)setMax:(id)sender;
- (IBAction)exportGif:(id)sender;
- (IBAction)test:(id)sender;
- (IBAction)previousFrame:(id)sender;
- (IBAction)nextFrame:(id)sender;
- (IBAction)moveSelectionEnd:(id)sender;
- (IBAction)moveSelectFirst:(id)sender;
- (IBAction)openDocument:(id)sender;
@end
