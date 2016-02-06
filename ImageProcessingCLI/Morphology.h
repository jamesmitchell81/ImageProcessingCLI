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

- (NSBitmapImageRep*) simpleDilationOfImage:(NSImage*)image;
- (NSBitmapImageRep*) simpleErosionOfImage:(NSImage*)image;

- (NSBitmapImageRep*) process:(NSImage*)image withPolarity:(int)polarity;

- (NSBitmapImageRep*) opening:(NSImage*)image;
- (NSBitmapImageRep*) closing:(NSImage*)image;


// dilate
// erode
// thin
// skeletonise

@end
