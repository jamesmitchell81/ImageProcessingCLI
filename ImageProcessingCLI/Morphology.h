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

- (NSBitmapImageRep*) opening:(NSImage*)image;
- (NSBitmapImageRep*) closing:(NSImage*)image;

- (NSBitmapImageRep*) simpleDilationOfImage:(NSImage *)image;
- (NSBitmapImageRep*) simpleErosionOfImage:(NSImage *)image;

- (NSBitmapImageRep*) processImage:(NSImage *)image
                    withBackground:(int)background
                     andForeground:(int)foreground
             andStructuringElement:(int [])element;

// dilate
// erode
// thin

@end
