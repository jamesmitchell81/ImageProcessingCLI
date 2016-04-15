//
//  ImageAnalysis.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 22/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "ImageAnalysis.h"
#import "ImageRepresentation.h"

@implementation ImageAnalysis

// iterate over image.
// at each y
// count each x value of ...

// takes image.
// returns unsigned char.

// pixel area histogram.

// of Thresholded image.
- (int*) pixelAreaDensityOfImage:(NSImage*)image
{
    int width = image.size.width;
    int height = image.size.height;
    
//    NSLog(@"%d", width * height);
    
    NSBitmapImageRep* representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char* input = [representation bitmapData];
    
    int* output = malloc(sizeof(int) * height);
    
    for ( int y = 0; y < height; y++ )
    {
        int count = 0;

        for ( int x = 0; x < width; x++ )
        {
            int index = x + (y * width);
            int t = input[index];
            
            if ( t == 0 )
            {
                count++;
            }
        }
        
        output[y] = count;
    }
    
    return output;
}

- (NSBitmapImageRep*) histogramRepresentationOfData:(int*)data
                                          withWidth:(int)width
                                          andHeight:(int)height
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

    return [ImageRepresentation grayScaleRepresentationOfImage:outputImage];
}


@end
