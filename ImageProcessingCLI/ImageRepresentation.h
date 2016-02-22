//
//  ImageRepresentation.h
//  ImageProcessingCLI
//
//  Created by James Mitchell on 06/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AppKit;

@interface ImageRepresentation : NSObject

// representation.
+ (NSImage*) cacheImageFromRepresentation:(NSBitmapImageRep *)representation;

+ (NSBitmapImageRep*) grayScaleRepresentationOfImage:(NSImage *)image;
+ (NSBitmapImageRep*) grayScaleRepresentationOfImage:(NSImage *)image
                                         withPadding:(int)padding;

+ (NSBitmapImageRep*) histogramRepresentationOfData:(int*)data withWidth:(int)width andHeight:(int)height;

+ (void) saveImageFileFromRepresentation:(NSBitmapImageRep *)representation
                                fileName:(NSString*)filename;

@end
