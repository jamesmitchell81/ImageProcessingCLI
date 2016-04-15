//
//  ImageAnalysis.h
//  ImageProcessingCLI
//
//  Created by James Mitchell on 22/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AppKit;

@interface ImageAnalysis : NSObject

- (int*) pixelAreaDensityOfImage:(NSImage*)image;
- (NSBitmapImageRep*) histogramRepresentationOfData:(int*)data withWidth:(int)width andHeight:(int)height;

@end
