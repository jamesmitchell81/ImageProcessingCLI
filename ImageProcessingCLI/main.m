//
//  main.m
//  ImageProcessingCLI
//
//  Created by James Mitchell on 09/01/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IntArrayUtil.h"
#import "IP.h"
#import "ImageRepresentation.h"
#import "Morphology.h"
#import "ZhangSuenThin.h"
#import "ImageAnalysis.h"

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
//        NSString* file = [@"~/Desktop/letterset.png" stringByExpandingTildeInPath];
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
        NSImage* dilated = [ImageRepresentation cacheImageFromRepresentation:dilate];
        
        NSBitmapImageRep* difference = [ip imageDifferenceOf:image and:dilated];
        NSImage* negative = [ImageRepresentation cacheImageFromRepresentation:difference];
        
        NSBitmapImageRep* negated = [ip imageNegativeOf:negative];
        NSBitmapImageRep* opened = [morph opening:image];
        NSBitmapImageRep* closed = [morph closing:image];
        
        NSImage* imageToThin = [ImageRepresentation cacheImageFromRepresentation:thresholded];
//        NSImage* imageToThin = [ImageRepresentation cacheImageFromRepresentation:negated];
        
        ZhangSuenThin* thinning = [ZhangSuenThin alloc];
        NSBitmapImageRep* thin = [thinning thinImage:imageToThin];
        
//        NSImage* thinnedImage = [ImageRepresentation cacheImageFromRepresentation:thin];
        NSImage* thinnedImage = [ImageRepresentation cacheImageFromRepresentation:thresholded];
        
        int height = thinnedImage.size.height;
        
        ImageAnalysis* ia = [ImageAnalysis alloc];
        int* areaDensity = [ia pixelAreaDensityOfImage:thinnedImage];
        int maxDensity = [IntArrayUtil maxFromArray:areaDensity ofSize:height];
        
        NSBitmapImageRep* areaDensityHistogramRep = [ImageRepresentation histogramRepresentationOfData:areaDensity
                                                                                             withWidth:maxDensity
                                                                                             andHeight:height];
        
        
        NSImage* imageForContrast = [[NSImage alloc] initByReferencingFile:file];
        int* contrast = [ip contrastHistogramOfImage:imageForContrast];
        contrast = [ip normaliseConstrastHistogramData:contrast ofSize:256];
        int maxValue = [IntArrayUtil maxFromArray:contrast ofSize:256];
        
        
        NSBitmapImageRep* contrastHistogram = [ImageRepresentation histogramRepresentationOfData:contrast
                                                                                       withWidth:maxValue
                                                                                       andHeight:256];

        NSImage* imageAutoContrast = [[NSImage alloc] initByReferencingFile:file];
        int* autoContrast = [ip automaticContrastAdjustmentOfImage:imageAutoContrast];
        
//        imageAutoContrast = [ImageRepresentation cacheImageFromRepresentation:autoContrast];
//        int* autoContrastHistogram = [ip contrastHistogramOfImage:imageAutoContrast];
//        autoContrastHistogram = [ip normaliseConstrastHistogramData:autoContrastHistogram ofSize:256];
//        
//        NSBitmapImageRep* autoContrastHistogramRep = [ImageRepresentation histogramRepresentationOfData:autoContrastHistogram
//                                                                                              withWidth:[IntArrayUtil maxFromArray:autoContrastHistogram ofSize:256]
//                                                                                              andHeight:256];
//        
//        [ImageRepresentation saveImageFileFromRepresentation:autoContrast fileName:@"AutoContrasted"];
//        [ImageRepresentation saveImageFileFromRepresentation:autoContrastHistogramRep fileName:@"AutoContrastedHistogram"];
        
        
        [ImageRepresentation saveImageFileFromRepresentation:contrastHistogram fileName:@"contrast"];
        [ImageRepresentation saveImageFileFromRepresentation:areaDensityHistogramRep fileName:@"areaDensity"];
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
        [ImageRepresentation saveImageFileFromRepresentation:negated fileName:@"negated"];
    }
    return 0;
}


void filters(NSImage* image)
{
    
}

void morph(NSImage* image)
{
    
}

void thin(NSImage* image)
{
    
}








