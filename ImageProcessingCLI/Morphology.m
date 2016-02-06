//
//  Morphology.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 04/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "Morphology.h"
#import "ImageRepresentation.h"

@implementation Morphology

// open
- (NSBitmapImageRep*) opening:(NSImage*)image
{
    NSImage* temp = [[NSImage alloc] initWithSize:image.size];
    
    NSBitmapImageRep* eroded = [self simpleErosionOfImage:image];
    
    temp = [ImageRepresentation cacheImageFromRepresentation:eroded];
    
    NSBitmapImageRep* dilated = [self simpleDilationOfImage:temp];
    
    return dilated;
}


// close
- (NSBitmapImageRep*) closing:(NSImage*)image
{
    NSImage* temp = [[NSImage alloc] initWithSize:image.size];
    
    NSBitmapImageRep* dilated = [self simpleDilationOfImage:image];
    
    temp = [ImageRepresentation cacheImageFromRepresentation:dilated];
    
    NSBitmapImageRep* eroded = [self simpleErosionOfImage:temp];
    
    return eroded;
}


- (NSBitmapImageRep*) simpleDilationOfImage:(NSImage*)image
{
    return [self process:image withPolarity:1];
}


- (NSBitmapImageRep*) simpleErosionOfImage:(NSImage*)image
{
    //    int polarity = 0;
    
    return [self process:image withPolarity:0];
}


- (NSBitmapImageRep*) process:(NSImage*)image withPolarity:(int)polarity
{
    // wrong names!
    int background, foreground;
    
    // dnot like this.
    if ( polarity == 1 )
    {
        background = 255;
        foreground = 0;
    } else {
        background = 0;
        foreground = 255;
    }
    
    NSBitmapImageRep* representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *original = [representation bitmapData];
    
    NSBitmapImageRep* output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char* processed = [output bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    
    int size = 3;
    int padding = (size - 1) / 2.0;
    //    int filter[size * size];
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            int centre = x + y * width;
            BOOL match = NO;
            
            for (int s = -padding; s < (padding + 1); s++) {
                for (int t = -padding; t < (padding + 1); t++) {
                    
                    int index = (x + s) + ((y + t) * width);
                    
                    if ( original[index] == foreground )
                    {
                        match = YES;
                    }
                }
            }
            
            processed[centre] = background;
            
            if ( match )
            {
                processed[centre] = foreground;
            }
        }
    }
    
    return output;
}




@end
