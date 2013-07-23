//
//  ClusterAnnotation.m
//  kingpin
//
//  Created by Anna Walser on 7/23/13.
//
//

#import "ClusterAnnotation.h"

@interface ClusterAnnotation (){
    UILabel *label;
}

@end


@implementation ClusterAnnotation

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0,-1);
        [self addSubview:label];
    }
    return self;
}

- (void) setClusterText:(NSString *)text
{
    label.text = text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
