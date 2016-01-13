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

@property NSImage *image;
@property int width;
@property int height;
@property unsigned char *pixels;

- (void) bubbleSort:(int *)arr ofSize:(int)size;
- (int) getMedianFromArray:(int [])arr ofSize:(int)size;
- (int) maxFromArray:(int [])arr ofSize:(int)size;
- (int) minFromArray:(int [])arr ofSize:(int)size;

- (NSBitmapImageRep *) reduceNoiseWithMedianFilterOfSize:(int)size;
- (NSBitmapImageRep *) reduceNoiseWithMaxFilterOfSize:(int)size;
- (NSBitmapImageRep *) smoothWithSimpleAveragingFilterOfSize:(int)size;
- (NSBitmapImageRep *) smoothWithWeightedAveragingFilterOfSize:(int)size;
- (NSImage *) reduceNoiseWithCIMedianFilterOnImage:(NSImage *)image;

- (NSBitmapImageRep *) thresholdWithValue:(int)value;

- (void) cacheImageFromRepresentation:(NSBitmapImageRep *)representation;

- (NSBitmapImageRep *) grayScaleRepresentationOfImage:(NSImage *)image;

- (void) saveImageFileFromRepresentation:(NSBitmapImageRep *)representation
                                fileName:(NSString*)filename;

@end
