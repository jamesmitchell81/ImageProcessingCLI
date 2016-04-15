//
//  IP.h
//  ImageCrop
//
//  Created by James Mitchell on 09/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AppKit;
@import CoreImage;

@interface ImageProcessing: NSObject

- (NSBitmapImageRep*) medianFilterOfSize:(int)size onImage:(NSImage*)image;
- (NSBitmapImageRep*) maxFilterOfSize:(int)size onImage:(NSImage*)image;
- (NSBitmapImageRep*) minFilterOfSize:(int)size onImage:(NSImage*)image;
- (NSBitmapImageRep*) simpleAveragingFilterOfSize:(int)size onImage:(NSImage*)image;
- (NSBitmapImageRep*) weightedAveragingFilterOfSize:(int)size onImage:(NSImage*)image;
- (NSBitmapImageRep*) threshold:(NSImage*)image atValue:(int)value;
- (NSBitmapImageRep*) imageDifferenceOf:(NSImage*)image1 and:(NSImage*)image2;
- (NSBitmapImageRep*) imageNegativeOf:(NSImage*)image;

- (NSBitmapImageRep*) automaticContrastAdjustmentOfImage:(NSImage*)image;
- (int*) cumulativeHistogramFromData:(int*)data ofSize:(int)size;
- (int*) contrastHistogramOfImage:(NSImage*)image;
- (int*) normaliseConstrastHistogramData:(int*)data ofSize:(int)size;



@end
