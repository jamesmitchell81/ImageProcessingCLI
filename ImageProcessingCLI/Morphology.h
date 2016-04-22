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


- (NSBitmapImageRep*) openingOnImage:(NSImage*)image withNeighbourhoodSize:(int)size;
- (NSBitmapImageRep*) closingOnImage:(NSImage*)image withNeighbourhoodSize:(int)size;

- (NSBitmapImageRep*) simpleDilationOfImage:(NSImage*)image withNeighbourhoodSize:(int)size;
- (NSBitmapImageRep*) simpleErosionOfImage:(NSImage*)image withNeighbourhoodSize:(int)size;

- (NSBitmapImageRep*) processImage:(NSImage *)image
                    withBackground:(int)background
                     andForeground:(int)foreground
              andNeighbourhoodSize:(int)element;

@end
