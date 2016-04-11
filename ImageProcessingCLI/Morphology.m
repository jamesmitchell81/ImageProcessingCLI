//
//  Morphology.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 04/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "Morphology.h"
#import "ImageRepresentation.h"
#import "StructuringElement.h"

@implementation Morphology

- (NSBitmapImageRep*) opening:(NSImage*)image ofSize:(int)size
{
    NSImage* temp = [[NSImage alloc] initWithSize:image.size];
    
    NSBitmapImageRep* eroded = [self simpleErosionOfImage:image ofSize:size];
    
    temp = [ImageRepresentation cacheImageFromRepresentation:eroded];
    
    NSBitmapImageRep* dilated = [self simpleDilationOfImage:temp ofSize:size];
    
    return dilated;
}

- (NSBitmapImageRep*) closing:(NSImage*)image ofSize:(int)size;
{
    NSImage* temp = [[NSImage alloc] initWithSize:image.size];
    
    NSBitmapImageRep* dilated = [self simpleDilationOfImage:image ofSize:size];
    
    temp = [ImageRepresentation cacheImageFromRepresentation:dilated];
    
    NSBitmapImageRep* eroded = [self simpleErosionOfImage:temp ofSize:size];
    
    return eroded;
}


- (NSBitmapImageRep*) simpleDilationOfImage:(NSImage*)image ofSize:(int)size
{
    return [self processImage:image withBackground:255 andForeground:0 andSize:size];
}


- (NSBitmapImageRep*) simpleErosionOfImage:(NSImage*)image ofSize:(int)size
{
    return [self processImage:image withBackground:0 andForeground:255 andSize:size];
}

- (NSBitmapImageRep*) processImage:(NSImage *)image
                    withBackground:(int)background
                     andForeground:(int)foreground
                           andSize:(int)size
{
    
    NSBitmapImageRep* representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *original = [representation bitmapData];
    
    NSBitmapImageRep* output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char* processed = [output bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    
    int padding = (size - 1) / 2.0;
    //    int filter[size * size];
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            int centre = x + y * width;
            BOOL hits = NO;
            
            for (int s = -padding; s < (padding + 1); s++) {
                for (int t = -padding; t < (padding + 1); t++) {
                    
                    int index = (x + s) + ((y + t) * width);
                    
                    if ( original[index] == foreground )
                    {
                        hits = YES;
                    }
                }
            }
            
            processed[centre] = background;
            if ( hits )
            {
                processed[centre] = foreground;
            }
        }
    }
    
    return output;
}

@end
