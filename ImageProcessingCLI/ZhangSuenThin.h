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
    BOOL complete;
    unsigned char* output;
}

- (NSBitmapImageRep*) thinImage:(NSImage*)image;
- (void) subIteration1;
- (void) subIteration2;

@end
