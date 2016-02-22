//
//  StructuringElement.h
//  ImageProcessingCLI
//
//  Created by James Mitchell on 09/02/2016.
//  Copyright © 2016 James Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StructuringElement : NSObject



// initWithRows:rows andColumns:columns

+ (instancetype) structureWithValues:(int)x0, ... NS_REQUIRES_NIL_TERMINATION;

- (void) addRowInt:(int)x0, ... NS_REQUIRES_NIL_TERMINATION;
- (void) addRowFloat:(float)x0, ... NS_REQUIRES_NIL_TERMINATION;

// getValueAtX:Y
// rotate

// make 

@end
