//
//  ImageRepresentation.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 06/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "ImageRepresentation.h"

@implementation ImageRepresentation

@synthesize subject;
@synthesize original;
@synthesize filtered;
@synthesize thresholded;
@synthesize current;

- (void) setOriginal:(NSImage *)image
{
    original = [[NSImage alloc] init];
    [original addRepresentation:[ImageRepresentation grayScaleRepresentationOfImage:image]];
}

- (void) setCurrent:(NSImage *)image
{
    current = [[NSImage alloc] init];
    [current addRepresentation:[ImageRepresentation grayScaleRepresentationOfImage:image]];
}

- (void) setSubject:(NSImage*)image
{
    subject = [[NSImage alloc] init];
    [subject addRepresentation:[ImageRepresentation grayScaleRepresentationOfImage:image]];
}

- (void) setThresholded:(NSImage *)image
{
    thresholded = [[NSImage alloc] init];
    [thresholded addRepresentation:[ImageRepresentation grayScaleRepresentationOfImage:image]];
}

- (void) resetSubject
{
    subject = [[NSImage alloc] init];
    [subject addRepresentation:[ImageRepresentation grayScaleRepresentationOfImage:original]];
}

+ (NSBitmapImageRep *) grayScaleRepresentationOfImage:(NSImage *)image
{
    return [self grayScaleRepresentationOfImage:image withPadding:0];
}

+ (NSBitmapImageRep*) grayScaleRepresentationOfImage:(NSImage *)image
                                         withPadding:(int)padding
{
    NSBitmapImageRep *representation = [[NSBitmapImageRep alloc]
                                        initWithBitmapDataPlanes: NULL
                                        pixelsWide: image.size.width
                                        pixelsHigh: image.size.height
                                        bitsPerSample: 8
                                        samplesPerPixel: 1
                                        hasAlpha: NO
                                        isPlanar: NO
                                        colorSpaceName: NSCalibratedWhiteColorSpace
                                        bytesPerRow: image.size.width //* 4
                                        bitsPerPixel: 8];
    
    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:representation];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:context];
    
    // REFERENCE developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Images/Images.html
        [image drawAtPoint:NSZeroPoint
                  fromRect:NSZeroRect
                 operation:NSCompositeCopy
                  fraction:1.0];

    [context flushGraphics];
    [NSGraphicsContext restoreGraphicsState];

    return representation;
}

+ (NSBitmapImageRep*) histogramRepresentationOfData:(int*)data withWidth:(int)width andHeight:(int)height
{
    
    NSImage* outputImage = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
    
    [outputImage lockFocus];
    
        [[NSColor whiteColor] setFill];
        [NSBezierPath fillRect:NSMakeRect(0, 0, width, height)];
        
        int index = 0;
        
        for ( int y = height - 1; y > 0; y-- )
        {
            int density = data[index++];
            
            NSPoint start = NSMakePoint(0, (float)y + 0.5);
            NSPoint end = NSMakePoint(density, (float)y + 0.5);
            
            NSBezierPath* path = [[NSBezierPath alloc] init];
            
            [path moveToPoint:start];
            [path lineToPoint:end];
            
            [path setLineWidth:1.0];
            [path stroke];
        }
        
    [outputImage unlockFocus];
    
    return [self grayScaleRepresentationOfImage:outputImage];
}


/*
 * Saves image to disk for my inspection.
 *
 */
+ (void) saveImageFileFromRepresentation:(NSBitmapImageRep *)representation
                                fileName:(NSString*)filename
{
    NSMutableString *saveTo = [NSMutableString stringWithString:@"~/Desktop/"];
    [saveTo appendString:filename];
    [saveTo appendString:@".png"];
    
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0]
                                                           forKey:NSImageCompressionFactor];
    
    NSData *newFile = [representation representationUsingType:NSPNGFileType
                                                   properties:imageProps];
    
    [newFile writeToFile:[saveTo stringByExpandingTildeInPath]
              atomically:NO];
}



+ (NSImage*) cacheImageFromRepresentation:(NSBitmapImageRep *)representation
{
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0]
                                                           forKey:NSImageCompressionFactor];
    
    NSData *newData = [representation representationUsingType:NSPNGFileType properties:imageProps];
    return [[NSImage alloc] initWithData:newData];
}


@end
