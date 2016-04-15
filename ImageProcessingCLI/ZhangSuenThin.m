//
//  Thinning.m
//  ImageProcessingCLI
//  Implementation of ZhangSuen Thinning Algorithm.
//
//  Created by James Mitchell on 08/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//


#import "ZhangSuenThin.h"
#import "ImageRepresentation.h"

@implementation ZhangSuenThin


- (NSBitmapImageRep*) thinImage:(NSImage*)image
{
    width = image.size.width;
    height = image.size.height;
    
    NSBitmapImageRep* outputRepresentation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    output = [outputRepresentation bitmapData];
    
    complete = NO;
    
    while ( !complete )
    {
        [self subIteration1];
        [self subIteration2];
    }
    
    return outputRepresentation;
}

- (void) subIteration1
{
    
    complete = YES;
    BOOL change = NO;
    
    int size = 3;
    int padding = (size - 1) / 2.0;
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            int p1 = (x) + (y * width); // centre
            
            if ( output[p1] != 0 ) continue;
            
            int a = 0;
            int b = 0;
            
            int p2 = (x - 1) + (y * width);
            int p3 = (x - 1) + ((y + 1) * width);
            int p4 = (x) + ((y + 1) * width);
            int p5 = (x + 1) + ((y + 1) * width);
            int p6 = (x + 1) + (y * width);
            int p7 = (x + 1) + ((y - 1) * width);
            int p8 = (x) + ((y - 1) * width);
            int p9 = (x - 1) + ((y - 1) * width);
            
            // a)
            if ( output[p2] == 0 ) b++;
            if ( output[p3] == 0 ) b++;
            if ( output[p4] == 0 ) b++;
            if ( output[p5] == 0 ) b++;
            if ( output[p6] == 0 ) b++;
            if ( output[p7] == 0 ) b++;
            if ( output[p8] == 0 ) b++;
            if ( output[p9] == 0 ) b++;
            BOOL deleteA = ( (b <= 6) && (b >= 2) );
//            BOOL deleteA = ( (b < 6) && (b > 2) );

            
            // b)
            if ( (output[p2] == 255) && (output[p3] == 0) ) a++;
            if ( (output[p3] == 255) && (output[p4] == 0) ) a++;
            if ( (output[p4] == 255) && (output[p5] == 0) ) a++;
            if ( (output[p5] == 255) && (output[p6] == 0) ) a++;
            if ( (output[p6] == 255) && (output[p7] == 0) ) a++;
            if ( (output[p7] == 255) && (output[p8] == 0) ) a++;
            if ( (output[p8] == 255) && (output[p9] == 0) ) a++;
            if ( (output[p9] == 255) && (output[p2] == 0) ) a++;
            BOOL deleteB = (a == 1);
            
            // c) and d) if neighbours are white.
            BOOL deleteC = ((output[p2] == 255) || (output[p4] == 255) || (output[p6] == 255));
            BOOL deleteD = ((output[p4] == 255) || (output[p6] == 255) || (output[p8] == 255 ));
            
            if ( deleteA && deleteB && deleteC && deleteD )
            {
                output[p1] = 255;
                change = YES;
            }

        }
    }
    
    if ( change ) complete = NO;

}


- (void) subIteration2
{
    complete = YES;
    
    BOOL change = NO;
    
    int size = 3;
    int padding = (size - 1) / 2.0;
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {

            int p1 = (x) + (y * width);
            
            if ( output[p1] != 0 ) continue;
            
            int a = 0;
            int b = 0;

            int p2 = (x - 1) + (y * width);
            int p3 = (x - 1) + ((y + 1) * width);
            int p4 = (x) + ((y + 1) * width);
            int p5 = (x + 1) + ((y + 1) * width);
            int p6 = (x + 1) + (y * width);
            int p7 = (x + 1) + ((y - 1) * width);
            int p8 = (x) + ((y - 1) * width);
            int p9 = (x - 1) + ((y - 1) * width);
            
            // a) has 3, 4, 5 neighbours
            if ( output[p2] == 0 ) b++;
            if ( output[p3] == 0 ) b++;
            if ( output[p4] == 0 ) b++;
            if ( output[p5] == 0 ) b++;
            if ( output[p6] == 0 ) b++;
            if ( output[p7] == 0 ) b++;
            if ( output[p8] == 0 ) b++;
            if ( output[p9] == 0 ) b++;
            BOOL deleteA = ( (b <= 6) && (b >= 2) );
//            BOOL deleteA = ( (b < 6) && (b > 2) );

            // b) transitions between 0 -> 1 (white -> block)
            if ( (output[p2] == 255) && (output[p3] == 0) ) a++;
            if ( (output[p3] == 255) && (output[p4] == 0) ) a++;
            if ( (output[p4] == 255) && (output[p5] == 0) ) a++;
            if ( (output[p5] == 255) && (output[p6] == 0) ) a++;
            if ( (output[p6] == 255) && (output[p7] == 0) ) a++;
            if ( (output[p7] == 255) && (output[p8] == 0) ) a++;
            if ( (output[p8] == 255) && (output[p9] == 0) ) a++;
            if ( (output[p9] == 255) && (output[p2] == 0) ) a++;
            BOOL deleteB = (a == 1);
            
            // c)
            BOOL deleteC = ( (output[p2] == 255) || (output[p4] == 255) || (output[p6] == 255) );
            BOOL deleteD = ( (output[p2] == 255) || (output[p6] == 255) || (output[p8] == 255) );

            if ( deleteA && deleteB && deleteC && deleteD )
            {
                output[p1] = 255;
                change = YES;
            }

        }
    }
    
    if ( change ) complete = NO;

}

@end
