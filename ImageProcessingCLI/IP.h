//
//  IP.h
//  ImageProcessingCLI
//
//  Created by James Mitchell on 09/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AppKit;
@import CoreImage;

//@class IntArrayUtil;


@interface IP : NSObject

- (NSBitmapImageRep*) medianFilterOfSize:(int)size onImage:(NSImage*)image;
- (NSBitmapImageRep*) maxFilterOfSize:(int)size onImage:(NSImage*)image;
- (NSBitmapImageRep*) simpleAveragingFilterOfSize:(int)size onImage:(NSImage*)image;
- (NSBitmapImageRep*) weightedAveragingFilterOfSize:(int)size onImage:(NSImage*)image;

- (NSImage*) reduceNoiseWithCIMedianFilterOnImage:(NSImage *)image;

- (NSBitmapImageRep*) threshold:(NSImage*)image atValue:(int)value;
- (int*) contrastHistogramOfImage:(NSImage*)image;

- (NSBitmapImageRep*) imageDifferenceOf:(NSImage*)image1 and:(NSImage*)image2;

- (NSBitmapImageRep*) imageNegativeOf:(NSImage*)image;

@end
