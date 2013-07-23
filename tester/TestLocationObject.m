//
//  TestAnnotation.m
//  BBAnnotationTree2
//
//  Created by Bryan Bonczek on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestLocationObject.h"

@implementation TestLocationObject



- (NSString *)title {
    return [NSString stringWithFormat:@"Annotation Title %i", self.level];

}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: (%f, %f)", [super description], self.coordinate.longitude, self.coordinate.latitude];
}

@end
