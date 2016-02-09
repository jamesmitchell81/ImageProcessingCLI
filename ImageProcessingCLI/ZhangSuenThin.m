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
    
    NSBitmapImageRep* representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    original = [representation bitmapData];
    
    NSBitmapImageRep* output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    processed = [output bitmapData];
    
    done = NO;
    
    int i = 0;
    
    while ( !done )
    {
        [self subIteration1];
        [self subIteration2];
        NSLog(@"%d", i++);
    }
    
    
    return output;
}


- (void) subIteration1//:(unsigned char*)original new:(unsigned char*)processed
{
    
    done = YES;
    BOOL change = NO;
    
//    int p = 0;
//    int current[width * height];

    int size = 3;
    int padding = (size - 1) / 2.0;
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            int p1 = (x) + (y * width);
            
            if ( processed[p1] != 0 ) continue;
            
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
            if ( processed[p2] == 0 ) b++;
            if ( processed[p3] == 0 ) b++;
            if ( processed[p4] == 0 ) b++;
            if ( processed[p5] == 0 ) b++;
            if ( processed[p6] == 0 ) b++;
            if ( processed[p7] == 0 ) b++;
            if ( processed[p8] == 0 ) b++;
            if ( processed[p9] == 0 ) b++;
            BOOL deleteA = ( (b < 6) && (b > 2) );

            // b)
            if ( (processed[p2] == 255) && (processed[p3] == 0) ) a++;
            if ( (processed[p3] == 255) && (processed[p4] == 0) ) a++;
            if ( (processed[p4] == 255) && (processed[p5] == 0) ) a++;
            if ( (processed[p5] == 255) && (processed[p6] == 0) ) a++;
            if ( (processed[p6] == 255) && (processed[p7] == 0) ) a++;
            if ( (processed[p7] == 255) && (processed[p8] == 0) ) a++;
            if ( (processed[p8] == 255) && (processed[p9] == 0) ) a++;
            if ( (processed[p9] == 255) && (processed[p2] == 0) ) a++;
            BOOL deleteB = (a == 1);
            
            // c) and d) if neighbours are white.
            BOOL deleteC = ((processed[p2] == 255) || (processed[p4] == 255) || (processed[p6] == 255));
            BOOL deleteD = ((processed[p4] == 255) || (processed[p6] == 255) || (processed[p8] == 255 ));
            
            if ( deleteA && deleteB && deleteC && deleteD )
            {
                processed[p1] = 255;
                change = YES;
            }

        }
    }
    
    if ( change ) done = NO;

}


- (void) subIteration2//:(unsigned char*)original new:(unsigned char*)processed
{
    done = YES;
    
    BOOL change = NO;
    
//    int p = 0;
//    int current[width * height];
    
    int size = 3;
    int padding = (size - 1) / 2.0;
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {

            int p1 = (x) + (y * width);
            
            if ( processed[p1] != 0 ) continue;
            
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
            if ( processed[p2] == 0 ) b++;
            if ( processed[p3] == 0 ) b++;
            if ( processed[p4] == 0 ) b++;
            if ( processed[p5] == 0 ) b++;
            if ( processed[p6] == 0 ) b++;
            if ( processed[p7] == 0 ) b++;
            if ( processed[p8] == 0 ) b++;
            if ( processed[p9] == 0 ) b++;
            BOOL deleteA = ( (b < 6) && (b > 2) );

            // b) transitions between 0 -> 1 (white -> block)
            if ( (processed[p2] == 255) && (processed[p3] == 0) ) a++;
            if ( (processed[p3] == 255) && (processed[p4] == 0) ) a++;
            if ( (processed[p4] == 255) && (processed[p5] == 0) ) a++;
            if ( (processed[p5] == 255) && (processed[p6] == 0) ) a++;
            if ( (processed[p6] == 255) && (processed[p7] == 0) ) a++;
            if ( (processed[p7] == 255) && (processed[p8] == 0) ) a++;
            if ( (processed[p8] == 255) && (processed[p9] == 0) ) a++;
            if ( (processed[p9] == 255) && (processed[p2] == 0) ) a++;
            BOOL deleteB = (a == 1);
            
            // c)
            BOOL deleteC = ( (processed[p2] == 255) || (processed[p4] == 255) || (processed[p6] == 255) );
            BOOL deleteD = ( (processed[p2] == 255) || (processed[p6] == 255) || (processed[p8] == 255) );

            if ( deleteA && deleteB && deleteC && deleteD )
            {
                processed[p1] = 255;
                change = YES;
            }

        }
    }
    
    if ( change ) done = NO;

}


@end
