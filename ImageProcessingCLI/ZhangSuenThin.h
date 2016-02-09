//
//  Thinning.h
//  ImageProcessingCLI
//
//  Created by James Mitchell on 08/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AppKit;

@interface ZhangSuenThin : NSObject
{
    int width;
    int height;
    
    BOOL done;
    
    unsigned char* original;
    unsigned char* processed;
//
//    NSBitmapImageRep* representation;
//    NSBitmapImageRep* output;
}

- (NSBitmapImageRep*) thinImage:(NSImage*)image;

// make private.
- (void) subIteration1; //:(unsigned char*)original new:(unsigned char*)processed;
- (void) subIteration2;//:(unsigned char*)original new:(unsigned char*)processed;

@end
