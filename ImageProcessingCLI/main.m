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
        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/example.jpg" stringByExpandingTildeInPath];
        NSImage *image = [[NSImage alloc] initByReferencingFile:file];

        ip.width = image.size.width;
        ip.height = image.size.height;
        
//        image = [ip reduceNoiseWithCIMedianFilterOnImage:image];
        
        NSBitmapImageRep *representation = [ip grayScaleRepresentationOfImage:image];
        
        ip.pixels = [representation bitmapData];

//        [ip thresholdWithValue:200];
        [ip reduceNoiseWithMedianFilter];
        
        // write file
        [ip saveImageFileFromRepresentation:representation];
        
    }
    return 0;
}









