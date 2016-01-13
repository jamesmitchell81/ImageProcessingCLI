//
//  main.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 09/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IP.h"

@import AppKit;

//struct Pixel { uint8_t greylevel; };

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        IP *ip = [IP alloc];
// edittheshittysunset
//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/edittheshittysunset.jpg" stringByExpandingTildeInPath];
//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/TopdeBotton.jpg" stringByExpandingTildeInPath];
//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/cheekycow1.jpg" stringByExpandingTildeInPath];
        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/buddhasminion.jpg" stringByExpandingTildeInPath];
//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/AlexDSSF.jpg" stringByExpandingTildeInPath];
        
        ip.image = [[NSImage alloc] initByReferencingFile:file];

        ip.width = ip.image.size.width;
        ip.height = ip.image.size.height;
        
//        image = [ip reduceNoiseWithCIMedianFilterOnImage:image];
        NSBitmapImageRep *representation = [ip grayScaleRepresentationOfImage:ip.image];
//        ip.pixels = [representation bitmapData];

//        NSBitmapImageRep *smoothed = [ip smoothWithSimpleAveragingFilterOfSize:3];
        NSBitmapImageRep *smoothed = [ip smoothWithWeightedAveragingFilterOfSize:3];
//        ip.pixels = [smoothed bitmapData];
        
        [ip cacheImageFromRepresentation:smoothed];
        
        NSBitmapImageRep *median = [ip reduceNoiseWithMedianFilterOfSize:9];

        NSBitmapImageRep *max = [ip reduceNoiseWithMaxFilterOfSize:11];
        
//        [ip cacheImageFromRepresentation:max];

        NSBitmapImageRep *thresholded = [ip thresholdWithValue:50];
      
        // write file
        [ip saveImageFileFromRepresentation:max fileName:@"max"];
        [ip saveImageFileFromRepresentation:median fileName:@"median"];
        [ip saveImageFileFromRepresentation:thresholded fileName:@"thresholded"];
        [ip saveImageFileFromRepresentation:smoothed fileName:@"smoothed"];
        [ip saveImageFileFromRepresentation:representation fileName:@"original"];
        
    }
    return 0;
}









