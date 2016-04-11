//
//  Morphology.h
//  ImageProcessingCLI
//
//  Created by James Mitchell on 04/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AppKit;

@interface Morphology : NSObject

- (NSBitmapImageRep*) opening:(NSImage*)image ofSize:(int)size;
- (NSBitmapImageRep*) closing:(NSImage*)image ofSize:(int)size;

- (NSBitmapImageRep*) simpleDilationOfImage:(NSImage*)image ofSize:(int)size;
- (NSBitmapImageRep*) simpleErosionOfImage:(NSImage*)image ofSize:(int)size;

- (NSBitmapImageRep*) processImage:(NSImage *)image
                    withBackground:(int)background
                     andForeground:(int)foreground
                           andSize:(int)element;

// dilate
// erode
// thin

@end
