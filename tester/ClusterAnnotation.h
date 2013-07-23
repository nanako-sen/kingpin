//
//  ClusterAnnotation.h
//  kingpin
//
//  Created by Anna Walser on 7/23/13.
//
//

#import <MapKit/MapKit.h>
#import "KPAnnotation.h"

@interface ClusterAnnotation : MKAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
- (void) setClusterText:(NSString *)text;

@end
