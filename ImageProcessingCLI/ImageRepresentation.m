//
//  ImageRepresentation.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 06/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "ImageRepresentation.h"

@implementation ImageRepresentation

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
        [image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [context flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    return representation;
}

/*
 * Saves image to disk for my inspection.
 *
 */
+ (void) saveImageFileFromRepresentation:(NSBitmapImageRep *)representation
                                fileName:(NSString*)filename
{
    //    NSString *filePath = @"~/Desktop/";
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
