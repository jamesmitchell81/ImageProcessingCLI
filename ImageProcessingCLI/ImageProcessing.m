//
//  IP.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 09/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "ImageProcessing.h"
#import "IntArrayUtil.h"
#import "ImageRepresentation.h"

@implementation ImageProcessing

#pragma mark -
#pragma mark Filters

- (NSBitmapImageRep*) medianFilterOfSize:(int)size onImage:(NSImage*)image;
{
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *original = [representation bitmapData];

    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *smoothed = [output bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    
    int padding = (size - 1) / 2.0;
    int filter[size * size];
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            
            int centre = x + y * width;
            int i = 0;
            
            for (int s = -padding; s < (padding + 1); s++) {
                
                for (int t = -padding; t < (padding + 1); t++) {
                    
                    int index = (x + s) + ((y + t) * width);
                    filter[i++] = original[index];
                    
                }
            }
            
            smoothed[centre] = [IntArrayUtil getMedianFromArray:filter ofSize:size * size];
        }
    }
    
    return output;
}

- (NSBitmapImageRep*) maxFilterOfSize:(int)size onImage:(NSImage*)image;
{
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *original = [representation bitmapData];
    
    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *smoothed = [output bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    
    int padding = (size - 1) / 2.0;
    int filter[size * size];
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            
            int centre = x + y * width;
            int i = 0;
            
            for (int s = -padding; s < (padding + 1); s++)
            {
                
                for (int t = -padding; t < (padding + 1); t++)
                {
                    
                    int index = (x + s) + ((y + t) * width);
                    filter[i++] = original[index];
                    
                }
            }
            
            smoothed[centre] = [IntArrayUtil maxFromArray:filter ofSize:size * size];
        }
    }
    
    return output;
}

- (NSBitmapImageRep*) minFilterOfSize:(int)size onImage:(NSImage*)image;
{
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *original = [representation bitmapData];
    
    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *smoothed = [output bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    
    int padding = (size - 1) / 2.0;
    int filter[size * size];
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            
            int centre = x + y * width;
            int i = 0;
            
            for (int s = -padding; s < (padding + 1); s++)
            {
                
                for (int t = -padding; t < (padding + 1); t++)
                {
                    int index = (x + s) + ((y + t) * width);
                    filter[i++] = original[index];
                }
            }
            
            smoothed[centre] = [IntArrayUtil minFromArray:filter ofSize:size * size];
        }
    }
    
    return output;
}


- (NSBitmapImageRep*) simpleAveragingFilterOfSize:(int)size onImage:(NSImage*)image;
{
    
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *original = [representation bitmapData];
    
    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *smoothed = [output bitmapData];

    int width = image.size.width;
    int height = image.size.height;
    
    float weight = 1.0 / (float)(size * size); // e.g. 1/(3 * 3) = 0.111
    int padding = (size - 1) / 2.0;  // pad the image
    
    // iterate over each pixel of the image
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            
            // find the centre pixel.
            int centre = x + y * width;
            int val = 0;
            
            // iterate over the filter
            for (int s = -padding; s < (padding + 1); s++)
            {
                for (int t = -padding; t < (padding + 1); t++)
                {
                    
                    // offset the current x, y
                    int index = (x + s) + ((y + t) * width);
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

- (NSBitmapImageRep*) weightedAveragingFilterOfSize:(int)size onImage:(NSImage*)image;
{
    // create a represenation of the origional image
    NSBitmapImageRep *representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *original = [representation bitmapData];
    
    // create a representation that will store the smoothed image.
    NSBitmapImageRep *output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *smoothed = [output bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    
    int padding = (3 - 1) / 2.0;  // pad the image
    
    int weights[9] = {1, 2, 1, 2, 4, 2, 1, 2, 1};
    float filter[9];
    
    // make filter
    for (int i = 0; i < 9; i++)
    {
        filter[i] = (float)weights[i] / 16.0;
    }
    
    // iterate over each pixel of the image
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            
            // find the centre pixel.
            int centre = x + y * width;
            int val = 0;
            int i = 0;
            
            // iterate over the filter
            for (int s = -padding; s < (padding + 1); s++)
            {
                for (int t = -padding; t < (padding + 1); t++)
                {
                    // offset the current x, y
                    int index = (x + s) + ((y + t) * width);
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

#pragma mark -
#pragma mark Thresholding

- (NSBitmapImageRep*) threshold:(NSImage*)image atValue:(int)value
{
    NSBitmapImageRep *output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *threshold = [output bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    
    for ( int y = 0; y < height; y++ )
    {
        for ( int x = 0; x < width; x++ )
        {
            int index = x + (y * width);
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

// as a percentage of the image pixels.
- (int*) contrastHistogramOfImage:(NSImage*)image
{
    int range = 256;
    int* output = [IntArrayUtil zeroArrayOfSize:range];
    
    int width = image.size.width;
    int height = image.size.height;
    
    NSBitmapImageRep* representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char* data = [representation bitmapData];
    
    for ( int y = 0; y < height; y++ )
    {
        for ( int x = 0; x < width; x++ )
        {
            int index = x + (y * width);
            int val = data[index];
            
            output[val] += 1;
        }
    }
    
    return output;
}

// rename!
- (int*) normaliseConstrastHistogramData:(int*)data ofSize:(int)size
{
    int* output = [IntArrayUtil zeroArrayOfSize:size];
    int count = 0;
    
    for ( int i = 0; i < size; i++ )
    {
        count += data[i];
    }
    
    for ( int j = 0; j < size; j++ )
    {
        output[j] = ((float)data[j] / 10.0f);

    }
    
    return output;
}

// constrast streching: http://homepages.inf.ed.ac.uk/rbf/HIPR2/stretch.htm
// linear - Page 60 Princibles of Digital Image Processing.
- (NSBitmapImageRep*) automaticContrastAdjustmentOfImage:(NSImage*)image
{
    int range = 256;
    
    // create representation of image.
    NSBitmapImageRep* representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char* data = [representation bitmapData];
    
    // get the histogram values.
    int* histogram = [self contrastHistogramOfImage:image];
    
    // get the high and low of the histogram.
    int high = 255;
    int low = 0;
    
    int i = 0;
    while ( (histogram[i] == 0) && (i < range))
    {
        i++;
    }
    
    low = i;
    
    i = 255;
    while ( (histogram[i] == 0) && (i > 0) )
    {
        i--;
    }
    
    high = i;
    
    int width = image.size.width;
    int height = image.size.height;

//    f(a) = (a - a[low]) * 255 / a[high] - a[low]
    for ( int y = 0; y < height; y++ )
    {
        for ( int x = 0; x < width; x++ )
        {
            int index = x + (y * width);
            int val = (data[index] - low) * (255 / (high - low));
            
            data[index] = val;
        }
    }
    
    
    return representation;
}

// Principle of DIP Fundermentals chap.3 p.52, chap.4 p.66
- (int*) cumulativeHistogramFromData:(int*)data ofSize:(int)size
{
    int* output = [IntArrayUtil zeroArrayOfSize:size];
    
    for ( int i = 1; i < size; i++ )
    {
        output[i] = data[i - 1] + data[i];
    }
    
    return output;
}

#pragma mark -
#pragma mark Other

- (NSBitmapImageRep*) imageDifferenceOf:(NSImage*)image1 and:(NSImage*)image2
{
    NSImage* outputImage = [[NSImage alloc] initWithSize:image1.size];
    
    NSBitmapImageRep* rep1 = [ImageRepresentation grayScaleRepresentationOfImage:image1];
    NSBitmapImageRep* rep2 = [ImageRepresentation grayScaleRepresentationOfImage:image2];
    NSBitmapImageRep* output = [ImageRepresentation grayScaleRepresentationOfImage:outputImage];
 
    unsigned char *one = [rep1 bitmapData];
    unsigned char *two = [rep2 bitmapData];
    unsigned char *three = [output bitmapData];
    
    int width = image1.size.width;
    int height = image1.size.height;
    
    for ( int y = 0; y < height; y++ )
    {
        for (int x = 0; x < width; x++)
        {
            int index = x + (y * width);
            three[index] = one[index] - two[index];
        }
    }

    return output;
}

- (NSBitmapImageRep*) imageNegativeOf:(NSImage*)image
{
    NSBitmapImageRep* output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    
    unsigned char* rep = [output bitmapData];
    
    int width = image.size.width;
    int height = image.size.height;
    
    for ( int y = 0; y < height; y++ )
    {
        for ( int x = 0; x < width; x++ )
        {
            int index = x + (y * width);
            
            int val = rep[index] - 255;
            
            if ( val < 0 )
            {
                val = val * -1;
            }
            
            rep[index] = val;
        }
    }
    
    
    
    return output;
}


@end

