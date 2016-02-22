//
//  IntArrayUtil.h
//  ImageProcessingCLI
//
//  Created by James Mitchell on 06/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntArrayUtil : NSObject

+ (void) bubbleSort:(int *)arr ofSize:(int)size;
+ (int) getMedianFromArray:(int [])arr ofSize:(int)size;
+ (int) maxFromArray:(int [])arr ofSize:(int)size;
+ (int) minFromArray:(int [])arr ofSize:(int)size;
+ (int*) zeroArrayOfSize:(int)size;

@end
