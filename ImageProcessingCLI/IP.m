//
//  IP.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 09/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "IP.h"

@implementation IP

#pragma mark -
#pragma mark Morph

- (NSBitmapImageRep *) simpleThinned //:(int)size
{
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *original = [representation bitmapData];
    
    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *thinned = [output bitmapData];
    
    int size = 3;
    int padding = (size - 1) / 2.0;
    int structuringElement[3][3] = {
        {0, 1, 0},
        {1, 1, 1},
        {0, 1, 0},
    };
    
    for ( int y = padding; y < self.height - padding; y++ )
    {
        for (int x = padding; x < self.width - padding; x++)
        {
            
            int centre = x + y * self.width;
            int i = 0;
            
            for (int s = -padding; s < (padding + 1); s++) {
                
                for (int t = -padding; t < (padding + 1); t++) {
                    
                    int index = (x + s) + ((y + t) * self.width);
                    
//                    filter[i++] = original[index];
                    
                    
                }
            }
            
//            smoothed[centre] = [self getMedianFromArray:filter ofSize:size];
        }
    }
    
    return output;
}


#pragma mark -
#pragma mark Filters

- (NSBitmapImageRep *) reduceNoiseWithMedianFilterOfSize:(int)size
{
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *original = [representation bitmapData];

    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *smoothed = [output bitmapData];
    
    int padding = (size - 1) / 2.0;
    int filter[size * size];
    
    for ( int y = padding; y < self.height - padding; y++ )
    {
        for (int x = padding; x < self.width - padding; x++)
        {
            
            int centre = x + y * self.width;
            int i = 0;
            
            for (int s = -padding; s < (padding + 1); s++) {
                
                for (int t = -padding; t < (padding + 1); t++) {
                    
                    int index = (x + s) + ((y + t) * self.width);
                    filter[i++] = original[index];
                    
                }
            }
            
            smoothed[centre] = [self getMedianFromArray:filter ofSize:size];
        }
    }
    
    return output;
}

- (NSBitmapImageRep *) reduceNoiseWithMaxFilterOfSize:(int)size
{
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *original = [representation bitmapData];
    
    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *smoothed = [output bitmapData];
    
    int padding = (size - 1) / 2.0;
    int filter[size * size];
    
    for ( int y = padding; y < self.height - padding; y++ )
    {
        for (int x = padding; x < self.width - padding; x++)
        {
            
            int centre = x + y * self.width;
            int i = 0;
            
            for (int s = -padding; s < (padding + 1); s++)
            {
                
                for (int t = -padding; t < (padding + 1); t++)
                {
                    
                    int index = (x + s) + ((y + t) * self.width);
                    filter[i++] = original[index];
                    
                }
            }
            
            smoothed[centre] = [self minFromArray:filter ofSize:size];
        }
    }
    
    return output;
}


- (NSBitmapImageRep *) smoothWithSimpleAveragingFilterOfSize:(int)size
{
    
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *original = [representation bitmapData];
    
    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *smoothed = [output bitmapData];

    float weight = 1.0 / (float)(size * size); // e.g. 1/(3 * 3) = 0.111
    int padding = (size - 1) / 2.0;  // pad the image
    
    // iterate over each pixel of the image
    for ( int y = padding; y < self.height - padding; y++ )
    {
        for (int x = padding; x < self.width - padding; x++)
        {
            
            // find the centre pixel.
            int centre = x + y * self.width;
            int val = 0;
            
            // iterate over the filter
            for (int s = -padding; s < (padding + 1); s++)
            {
                for (int t = -padding; t < (padding + 1); t++)
                {
                    
                    // offset the current x, y
                    int index = (x + s) + ((y + t) * self.width);
                    // add the values
                    val += original[index] * weight;

                }
            }

            // reject values over 255 to prevent
            if ( val > 255 ) val = 255;
            // apply the new value to centre of the filter
            smoothed[centre] = val;
        }
    }
    
    return output;
}

- (NSBitmapImageRep *) smoothWithWeightedAveragingFilterOfSize:(int)size
{
    
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *original = [representation bitmapData];
    
    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *smoothed = [output bitmapData];
    
    int padding = (3 - 1) / 2.0;  // pad the image
    
    int weights[9] = {1, 2, 1, 2, 4, 2, 1, 2, 1};
    float filter[9];
    
    // make filter
    for (int i = 0; i < 9; i++)
    {
        filter[i] = (float)weights[i] / 16.0;
    }
    
    // iterate over each pixel of the image
    for ( int y = padding; y < self.height - padding; y++ )
    {
        for (int x = padding; x < self.width - padding; x++)
        {
            
            // find the centre pixel.
            int centre = x + y * self.width;
            int val = 0;
            int i = 0;
            
            // iterate over the filter
            for (int s = -padding; s < (padding + 1); s++)
            {
                for (int t = -padding; t < (padding + 1); t++)
                {
                    
                    // offset the current x, y
                    int index = (x + s) + ((y + t) * self.width);
                    // add the values
                    val += original[index] * filter[i++];
                    
                }
            }
            
            // reject values over 255 to prevent
            if ( val > 255 ) val = 255;
            // apply the new value to centre of the filter
            smoothed[centre] = val;
        }
    }
    
    return output;
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

#pragma mark -
#pragma mark Thresholding

- (NSBitmapImageRep *) thresholdWithValue:(int)value
{
    
    NSBitmapImageRep *output = [self grayScaleRepresentationOfImage:self.image];
    unsigned char *threshold = [output bitmapData];
    
    
    for ( int y = 0; y < self.height; y++ )
    {
        for ( int x = 0; x < self.width; x++ )
        {
            int index = x + (y * self.width);
            if ( threshold[index] < value)
            {
                threshold[index] = 0;
            } else {
                threshold[index] = 255;
            }
        }
    }
    
    return output;
}

#pragma mark -
#pragma mark Sorting

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

#pragma mark -
#pragma mark Representations

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
                                        bytesPerRow: self.width //* 4
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
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0]
                                                           forKey:NSImageCompressionFactor];
    
    NSData *newData = [representation representationUsingType:NSPNGFileType properties:imageProps];
    self.image = [[NSImage alloc] initWithData:newData];
}


@end

