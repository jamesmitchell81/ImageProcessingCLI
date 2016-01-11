//
//  IP.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 09/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "IP.h"

@implementation IP

- (void) reduceNoiseWithMedianFilter
{
    int filter[9];
    int median;
    
    unsigned char *new = malloc((self.width * self.height) * sizeof(unsigned char));
    
    for ( int y = 1; y < self.height - 1; y++ )
    {
        for (int x = 1; x < self.width - 1; x++)
        {
            int centre = x + y * self.width;
            filter[0] = self.pixels[(x - 1) + ((y - 1) * self.width)];
            filter[1] = self.pixels[(x) + ((y - 1) * self.width)];
            filter[2] = self.pixels[(x + 1) + ((y - 1) * self.width)];
            filter[3] = self.pixels[(x - 1) + ((y) * self.width)];
            filter[4] = self.pixels[x + y * self.width];
            filter[5] = self.pixels[(x + 1) + ((y) * self.width)];
            filter[6] = self.pixels[(x - 1) + ((y + 1) * self.width)];
            filter[7] = self.pixels[(x) + ((y + 1) * self.width)];
            filter[8] = self.pixels[(x + 1) + ((y + 1) * self.width)];
            
            median = [self getMedianFromArray:filter ofSize:9];

            new[centre] = median;
        }
    }
    
    *self.pixels = *new;
}


- (NSBitmapImageRep *) smoothWithSimpleAveragingFilterOfSize:(int)size
{
    
    NSBitmapImageRep *representation = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *original = [representation bitmapData];
    
    NSBitmapImageRep *output = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *smoothed = [output bitmapData];

    float weight = 1.0 / (float)size;
    int padding = ((float)size / 3.0) / 2.0;
    
    for ( int y = padding; y < self.height - padding; y++ ) {
        for (int x = padding; x < self.width - padding; x++) {
            
            int centre = x + y * self.width;
            int val = 0;
            
            for (int s = -padding; s < (padding + 1); s++) {
                for (int t = -padding; t < (padding + 1); t++) {
                    
                    int index = (x + s) + ((y + t) * self.width);
                    val += original[index] * weight;

                }
            }

            if ( val > 255 ) val = 255;
            smoothed[centre] = val;
        }
    }
    
    return output;
}

- (void) bubbleSort:(int *)arr ofSize:(int)size
{
    
    BOOL swap;
    int temp;
    
    do {
        swap = NO;
        
        for ( int i = 0; i < (size - 1); i++ )
        {
            if ( arr[i] > arr[i + 1] )
            {
                temp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = temp;
                swap = YES;
            }
        }
    } while (swap);
    
    
}

- (int) maxFromArray:(int [])arr ofSize:(int)size
{
    [self bubbleSort:arr ofSize:size];
    return arr[size];
}

- (int) minFromArray:(int [])arr ofSize:(int)size
{
    [self bubbleSort:arr ofSize:size];
    return arr[0];
}

- (int) getMedianFromArray:(int [])arr ofSize:(int)size
{
    int middle = (int)(size / 2);

    [self bubbleSort:arr ofSize:size];
    
    return arr[middle];
}

- (NSImage *) reduceNoiseWithCIMedianFilterOnImage:(NSImage *)image
{
    
    CIFilter *filter = [CIFilter filterWithName:@"CINoiseReduction"];
    
    [filter setValue:[NSNumber numberWithFloat:0.10] forKey:@"inputNoiseLevel"];
    
     // http://stackoverflow.com/questions/10764249/get-nsimage-from-cifilter-ciradialgradient
    [image lockFocus];
    [[filter valueForKey:@"inputImage"]
     drawAtPoint: NSZeroPoint
     fromRect: NSMakeRect(0, 0, self.width, self.height)
     operation:NSCompositeDestinationAtop  fraction:1.0
     ];
    [image unlockFocus];
    
    return image;
}

/*
 * 
 *
 *
 */
- (NSBitmapImageRep *) thresholdWithValue:(int)value
{
    
    NSBitmapImageRep *output = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *threshold = [output bitmapData];
    
    
    for ( int y = 0; y < self.height; y++ )
    {
        for ( int x = 0; x < self.width; x++ )
        {
            int index = x + (y * self.width);
            if ( threshold[index] < value) {
                threshold[index] = 0;
            } else {
                threshold[index] = 255;
            }
        }
    }
    
    return output;
}


- (NSBitmapImageRep *) grayScaleRepresentationOfImage:(NSImage *)image
{
    NSBitmapImageRep *representation = [[NSBitmapImageRep alloc]
                                        initWithBitmapDataPlanes: NULL
                                        pixelsWide: self.width
                                        pixelsHigh: self.height
                                        bitsPerSample: 8
                                        samplesPerPixel: 1
                                        hasAlpha: NO
                                        isPlanar: NO
                                        colorSpaceName: NSCalibratedWhiteColorSpace
                                        bytesPerRow: self.width // * 4
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
- (void) saveImageFileFromRepresentation:(NSBitmapImageRep *)representation
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


- (void) cacheImageFromRepresentation:(NSBitmapImageRep *)representation
{

    NSData *newData = [representation representationUsingType:NSPNGFileType properties:Nil];
    self.image = [[NSImage alloc] initWithData:newData];
}


@end

