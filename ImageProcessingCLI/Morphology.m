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

- (unsigned char*) toBinary:(unsigned char*)representation
{
    unsigned char* binary = malloc(strlen((const char*)representation));
    unsigned long length = strlen((const char*)representation);
    
//    NSLog(@"%lu", strlen((const char*)binary));
    
    for (unsigned long i = 0; i < length; i++)
    {
        NSLog(@"%d", representation[i]);
        
        if ( representation[i] == 255 )
        {
            binary[i] = 0;
        } else {
            binary[i] = 1;
        }

    }

    return binary;
}


- (NSBitmapImageRep*) simpleThinning:(NSImage*)image
{
    
    NSBitmapImageRep* representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char *original = [representation bitmapData];
    
    NSBitmapImageRep* output = [ImageRepresentation grayScaleRepresentationOfImage:image];
    unsigned char* processed = [output bitmapData];
    
    unsigned char* binary = original; //[self toBinary:processed];
    
    int width = image.size.width;
    int height = image.size.height;
    
    int size = 3;
    int padding = (size - 1) / 2.0;
    

    
    return output;
}

- (void) thinSub1:(unsigned char*)binary new:(unsigned char*)processed
{
    int width = image.size.width;
    int height = image.size.height;
    
    int size = 3;
    int padding = (size - 1) / 2.0;
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            int a = 0;
            int b = 0;
            BOOL delete = NO;
            
            int p1 = (x) + (y * width);
            int p2 = (x - 1) + (y * width);
            int p3 = (x - 1) + ((y + 1) * width);
            int p4 = (x) + ((y + 1) * width);
            int p5 = (x + 1) + ((y + 1) * width);
            int p6 = (x + 1) + (y * width);
            int p7 = (x + 1) + ((y - 1) * width);
            int p8 = (x) + ((y - 1) * width);
            int p9 = (x - 1) + ((y - 1) * width);
            
            // a)
            //            b = binary[p2] + binary[p3] + binary[p4] + binary[p5] + binary[p6] + binary[p7] + binary[p8] + binary[p9];
            //            b = (b > 0) ? b / 255 : b; // adjust for image values.
            
            if ( binary[p2] == 0 ) b++;
            if ( binary[p3] == 0 ) b++;
            if ( binary[p4] == 0 ) b++;
            if ( binary[p5] == 0 ) b++;
            if ( binary[p6] == 0 ) b++;
            if ( binary[p7] == 0 ) b++;
            if ( binary[p8] == 0 ) b++;
            if ( binary[p9] == 0 ) b++;
            BOOL deleteA = ( (b <= 6) && (b >= 2) );
            //
            //            if ( deleteA )
            //            {
            //                NSLog(@"%d", b);
            //            }
            
            // b)
            if ( (binary[p2] == 255) && (binary[p3] == 0) ) a++;
            if ( (binary[p3] == 255) && (binary[p4] == 0) ) a++;
            if ( (binary[p4] == 255) && (binary[p5] == 0) ) a++;
            if ( (binary[p5] == 255) && (binary[p6] == 0) ) a++;
            if ( (binary[p6] == 255) && (binary[p7] == 0) ) a++;
            if ( (binary[p7] == 255) && (binary[p8] == 0) ) a++;
            if ( (binary[p8] == 255) && (binary[p9] == 0) ) a++;
            BOOL deleteB = (a == 1);
            
            //            if ( deleteB )
            //            {
            if ( a != 0 && a != 1)
            {
                NSLog(@"%d", a);
            }
            
            //            }
            
            // c)
            int c = ((binary[p2] - 255) * (binary[p4] - 255) * (binary[p6] - 255));
            BOOL deleteC = ( c == 0 );
            
            // d)
            int d = ((binary[p4] - 255) * (binary[p6] - 255) * (binary[p8] - 255));
            BOOL deleteD = ( d == 0);
            
            
            if ( deleteA || deleteB || deleteC || deleteD )
            {
                processed[p1] = 255;
            }
            
            // end
        }
    }
}

- (void) thinSub2:(unsigned char*)binary new:(unsigned char*)processed
{
    int width = image.size.width;
    int height = image.size.height;
    
    int size = 3;
    int padding = (size - 1) / 2.0;
    
    for ( int y = padding; y < height - padding; y++ )
    {
        for (int x = padding; x < width - padding; x++)
        {
            int a = 0;
            int b = 0;
            BOOL delete = NO;
            
            int p1 = (x) + (y * width);
            int p2 = (x - 1) + (y * width);
            int p3 = (x - 1) + ((y + 1) * width);
            int p4 = (x) + ((y + 1) * width);
            int p5 = (x + 1) + ((y + 1) * width);
            int p6 = (x + 1) + (y * width);
            int p7 = (x + 1) + ((y - 1) * width);
            int p8 = (x) + ((y - 1) * width);
            int p9 = (x - 1) + ((y - 1) * width);
            
            // a)
            //            b = binary[p2] + binary[p3] + binary[p4] + binary[p5] + binary[p6] + binary[p7] + binary[p8] + binary[p9];
            //            b = (b > 0) ? b / 255 : b; // adjust for image values.
            
            if ( binary[p2] == 0 ) b++;
            if ( binary[p3] == 0 ) b++;
            if ( binary[p4] == 0 ) b++;
            if ( binary[p5] == 0 ) b++;
            if ( binary[p6] == 0 ) b++;
            if ( binary[p7] == 0 ) b++;
            if ( binary[p8] == 0 ) b++;
            if ( binary[p9] == 0 ) b++;
            BOOL deleteA = ( (b <= 6) && (b >= 2) );
            //
            //            if ( deleteA )
            //            {
            //                NSLog(@"%d", b);
            //            }
            
            // b)
            if ( (binary[p2] == 255) && (binary[p3] == 0) ) a++;
            if ( (binary[p3] == 255) && (binary[p4] == 0) ) a++;
            if ( (binary[p4] == 255) && (binary[p5] == 0) ) a++;
            if ( (binary[p5] == 255) && (binary[p6] == 0) ) a++;
            if ( (binary[p6] == 255) && (binary[p7] == 0) ) a++;
            if ( (binary[p7] == 255) && (binary[p8] == 0) ) a++;
            if ( (binary[p8] == 255) && (binary[p9] == 0) ) a++;
            BOOL deleteB = (a == 1);
            
            //            if ( deleteB )
            //            {
            if ( a != 0 && a != 1)
            {
                NSLog(@"%d", a);
            }
            
            //            }
            
            // c)
            BOOL deleteC = ( ( (binary[p2] - 255) * (binary[p4] - 255) * (binary[p6] - 255) ) == 0);
            
            // d)
            BOOL deleteD = ( ( (binary[p2] - 255) * (binary[p6] - 255) * (binary[p8] - 255) ) == 0);
            
            
            if ( deleteA || deleteB || deleteC || deleteD )
            {
                processed[p1] = 255;
            }
            
            // end
        }
    }
}


@end
