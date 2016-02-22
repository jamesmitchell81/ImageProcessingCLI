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


@end
