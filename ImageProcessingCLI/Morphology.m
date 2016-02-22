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

- (NSBitmapImageRep*) opening:(NSImage*)image
{
    NSImage* temp = [[NSImage alloc] initWithSize:image.size];
    
    NSBitmapImageRep* eroded = [self simpleErosionOfImage:image];
    
    temp = [ImageRepresentation cacheImageFromRepresentation:eroded];
    
    NSBitmapImageRep* dilated = [self simpleDilationOfImage:temp];
    
    return dilated;
}

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
    int elem[9] = {1, 1, 1, 1, 1, 1, 1, 1, 1};
    return [self processImage:image withBackground:255 andForeground:0 andStructuringElement:elem];
}


- (NSBitmapImageRep*) simpleErosionOfImage:(NSImage*)image
{
    //    int polarity = 0;
    int elem[9] = {1, 1, 1, 1, 1, 1, 1, 1, 1};
    return [self processImage:image withBackground:0 andForeground:255 andStructuringElement:elem];
}


- (NSBitmapImageRep*) processImage:(NSImage *)image
                    withBackground:(int)background
                     andForeground:(int)foreground
             andStructuringElement:(int [])element
{
    
//    StructuringElement *elem = [StructuringElement alloc];
//    
//    [elem addRow:1, 1,    1, nil];
//    [elem addRow:1, NULL, 1, nil];
    
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
