//
//  main.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 09/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IP.h"
#import "ImageRepresentation.h"
#import "Morphology.h"

@import AppKit;

//struct Pixel { uint8_t greylevel; };

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        IP *ip = [IP alloc];
        Morphology *morph = [Morphology alloc];

//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/edittheshittysunset.jpg" stringByExpandingTildeInPath];
//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/TopdeBotton.jpg" stringByExpandingTildeInPath];
//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/cheekycow1.jpg" stringByExpandingTildeInPath];
//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/buddhasminion.jpg" stringByExpandingTildeInPath];
//        NSString *file = [@"~/Documents/School 3/-Dissertation/6b. Image Processing And Analysis/img/samples/reddit/AlexDSSF.jpg" stringByExpandingTildeInPath];
        
        NSString* file = [@"~/Desktop/Cropped.png" stringByExpandingTildeInPath];
        NSImage* image = [[NSImage alloc] initByReferencingFile:file];
        
//        image = [ip reduceNoiseWithCIMedianFilterOnImage:image];
        NSBitmapImageRep* representation = [ImageRepresentation grayScaleRepresentationOfImage:image];
//        ip.pixels = [representation bitmapData];

        NSBitmapImageRep* smoothed = [ip simpleAveragingFilterOfSize:3 onImage:image];
//        NSBitmapImageRep *smoothed = [ip smoothWithWeightedAveragingFilterOfSize:9];
//        ip.pixels = [smoothed bitmapData];
        
        NSBitmapImageRep* median =      [ip medianFilterOfSize:5 onImage:image];
        NSBitmapImageRep* max =         [ip maxFilterOfSize:9 onImage:image];
        NSBitmapImageRep* thresholded = [ip threshold:image atValue:50];
        
        image = [ImageRepresentation cacheImageFromRepresentation:thresholded];
        NSImage* newImage = [ImageRepresentation cacheImageFromRepresentation:thresholded];
        
        NSBitmapImageRep* dilate = [morph simpleDilationOfImage:newImage];
        NSBitmapImageRep* erode = [morph simpleErosionOfImage:newImage];
        
        newImage = [ImageRepresentation cacheImageFromRepresentation:erode];

        NSBitmapImageRep* difference = [ip imageDifferenceOf:newImage and:image];
//        NSBitmapImageRep* difference = [ip imageDifferenceOf:image and:newImage];
        
        NSBitmapImageRep* opened = [morph opening:image];
        NSBitmapImageRep* closed = [morph closing:image];
        
        NSImage* imageToThin = [ImageRepresentation cacheImageFromRepresentation:thresholded];
        NSBitmapImageRep* thin = [morph simpleThinning:imageToThin];


        // write file
        [ImageRepresentation saveImageFileFromRepresentation:max fileName:@"max"];
        [ImageRepresentation saveImageFileFromRepresentation:median fileName:@"median"];
        [ImageRepresentation saveImageFileFromRepresentation:thresholded fileName:@"thresholded"];
        [ImageRepresentation saveImageFileFromRepresentation:smoothed fileName:@"smoothed"];
        [ImageRepresentation saveImageFileFromRepresentation:representation fileName:@"original"];
        [ImageRepresentation saveImageFileFromRepresentation:dilate fileName:@"dilated"];
        [ImageRepresentation saveImageFileFromRepresentation:erode fileName:@"eroded"];
        [ImageRepresentation saveImageFileFromRepresentation:difference fileName:@"difference"];
        
        [ImageRepresentation saveImageFileFromRepresentation:opened fileName:@"opened"];
        [ImageRepresentation saveImageFileFromRepresentation:closed fileName:@"closed"];
        
        [ImageRepresentation saveImageFileFromRepresentation:thin fileName:@"thinned"];
        
    }
    return 0;
}









