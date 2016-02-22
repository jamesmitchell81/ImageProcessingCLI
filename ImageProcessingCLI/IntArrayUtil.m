//
//  IntArrayUtil.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 06/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import "IntArrayUtil.h"

@implementation IntArrayUtil

#pragma mark -
#pragma mark Sorting

+ (void) sort:(int *)arr ofSize:(int)size
{
    [self bubbleSort:arr ofSize:size];
}

+ (void) bubbleSort:(int *)arr ofSize:(int)size
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

//+ (int) maxFromArray:(int [])arr ofSize:(int)size
//{
//    [self bubbleSort:arr ofSize:size];
//    return arr[size];
//}

+ (int) maxFromArray:(int [])arr ofSize:(int)size
{
    int max = 0;
    for ( int i = 0; i < size; i++ )
    {
        int val = arr[i];
        if ( val > max )
        {
            max = val;
        }
    }
    
    return max;
}

//+ (int) minFromArray:(int [])arr ofSize:(int)size
//{
//    [self bubbleSort:arr ofSize:size];
//    return arr[0];
//}

+ (int) minFromArray:(int [])arr ofSize:(int)size
{
    int min = 0;
    for ( int i = 0; i < size; i++ )
    {
        int val = arr[i];
        if ( val < min )
        {
            min = val;
        }
    }
    
    return min;
}

+ (int) getMedianFromArray:(int [])arr ofSize:(int)size
{
    int middle = (int)(size / 2);
    
    [self bubbleSort:arr ofSize:size];
    
    return arr[middle];
}

+ (int*) zeroArrayOfSize:(int)size
{
    int* output = malloc(sizeof(int) * size);
    
    for ( int i = 0; i < size; i++ )
    {
        output[i] = 0;
    }
    return output;
}

@end
