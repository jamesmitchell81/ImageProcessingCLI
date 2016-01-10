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

@interface IP : NSObject

@property int width;
@property int height;
@property unsigned char *pixels;

- (void) reduceNoiseWithMedianFilter;
- (void) smoothWithSimpleAveragingFilterOfSize:(int)size;
- (int) getMedianFromArray:(int [])arr ofSize:(int)size;
- (NSImage *) reduceNoiseWithCIMedianFilterOnImage:(NSImage *)image;
- (void) thresholdWithValue:(int)value;
- (NSBitmapImageRep *) grayScaleRepresentationOfImage:(NSImage *)image;
- (void) saveImageFileFromRepresentation:(NSBitmapImageRep *)representation;

@end
