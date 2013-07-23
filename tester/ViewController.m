//
//  ViewController.m
//  MapTest
//
//  Created by Bryan Bonczek on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "LocationObject.h"
#import "TestLocationObject.h"
#import "ClusterAnnotation.h"

#import "KPAnnotation.h"
#import "KPTreeController.h"

static const int kNumberOfTestAnnotations = 500;

@interface ViewController ()

@property (nonatomic, strong) KPTreeController *treeController;
@property (nonatomic, strong) KPTreeController *treeController2;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.treeController = [[KPTreeController alloc] initWithMapView:self.mapView];
    self.treeController.delegate = self;
    self.treeController.animationOptions = UIViewAnimationOptionCurveEaseOut;
    [self.treeController setAnnotations:[self annotations]];
    
    self.treeController2 = [[KPTreeController alloc] initWithMapView:self.mapView];
    self.treeController2.delegate = self;
    self.treeController2.animationOptions = UIViewAnimationOptionCurveEaseOut;
    [self.treeController2 setAnnotations:[self annotations]];
    
    self.mapView.showsUserLocation = YES;
    static const  MKCoordinateSpan span = {.latitudeDelta =  0.2, .longitudeDelta =   0.2};
    MKCoordinateRegion region = {[self nycCoord], span};
    
    [_mapView setRegion:region];
    
    // add two annotations that don't get clustered
    LocationObject *nycAnnotation = [LocationObject new];
    nycAnnotation.coordinate = [self nycCoord];
    nycAnnotation.title = @"NYC!";
    
    LocationObject *sfAnnotation = [LocationObject new];
    sfAnnotation.coordinate = [self sfCoord];
    sfAnnotation.title = @"SF!";
    
    
    
    [self.mapView addAnnotation:nycAnnotation];
    [self.mapView addAnnotation:sfAnnotation];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.mapView = nil;
}

- (IBAction)resetAnnotations:(id)sender {
    [self.treeController setAnnotations:[self annotations]];
    [self.treeController2 setAnnotations:[self annotations]];
}


- (NSArray *)annotations {
    
    // build an NYC and SF cluster
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D nycCoord = [self nycCoord];
    CLLocationCoordinate2D sfCoord = [self sfCoord];
    
    for (int i=0; i< kNumberOfTestAnnotations / 2; i++) {
        
        float latAdj = ((random() % 100) / 1000.f);
        float lngAdj = ((random() % 100) / 1000.f);
        
        TestLocationObject *a1 = [[TestLocationObject alloc] init];
        a1.coordinate = CLLocationCoordinate2DMake(nycCoord.latitude + latAdj, 
                                                   nycCoord.longitude + lngAdj);
        [annotations addObject:a1];
        
        TestLocationObject *a2 = [[TestLocationObject alloc] init];
        a2.coordinate = CLLocationCoordinate2DMake(sfCoord.latitude + latAdj,
                                                   sfCoord.longitude + lngAdj);
        [annotations addObject:a2];

    }
    
    return annotations;
}

- (CLLocationCoordinate2D)nycCoord {
    return CLLocationCoordinate2DMake(40.77, -73.98);
}

- (CLLocationCoordinate2D)sfCoord {
    return CLLocationCoordinate2DMake(37.85, -122.68);
}


#pragma mark - MKMapView

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.treeController refresh:self.animationSwitch.on];
    [self.treeController2 refresh:self.animationSwitch.on];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if([view.annotation isKindOfClass:[KPAnnotation class]]){
        
        KPAnnotation *cluster = (KPAnnotation *)view.annotation;
        
        if(cluster.annotations.count > 1){

            [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(cluster.coordinate,
                                                                       cluster.radius * 2.5f,
                                                                       cluster.radius * 2.5f)
                           animated:YES];
        }
    }
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
     ClusterAnnotation *v = nil;
    
    if([annotation isKindOfClass:[KPAnnotation class]]){
    
        KPAnnotation *a = (KPAnnotation *)annotation;
        
        if([annotation isKindOfClass:[MKUserLocation class]]){
            return nil;
        }
        
        if([a isCluster]){
           
            v = (ClusterAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
            
            if(!v){
                v = [[ClusterAnnotation alloc] initWithAnnotation:a reuseIdentifier:@"cluster"];
            }
            [v setClusterText:[NSString stringWithFormat:@"%d", [a.annotations count]]];
            v.canShowCallout = NO;
            v.image = [UIImage imageNamed:@"cluster.png"];
        }
        else {
            
            v = (ClusterAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
            
            if(!v){
                v = [[ClusterAnnotation alloc] initWithAnnotation:[a.annotations anyObject]
                                                    reuseIdentifier:@"pin"];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                [button setShowsTouchWhenHighlighted:YES];
                v.rightCalloutAccessoryView = button;
            }
            
            v.image = [UIImage imageNamed:@"pinpoint.png"];
            v.canShowCallout = YES;
        }
        
        
        
    }
    else if([annotation isKindOfClass:[LocationObject class]]) {
        v = [[ClusterAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:@"nocluster"];
        v.image = [UIImage imageNamed:@"pinpoint.png"];
    }
    
    return v;
    
}

#pragma mark - KPTreeControllerDelegate

- (void)treeController:(KPTreeController *)tree configureAnnotationForDisplay:(KPAnnotation *)annotation {
    annotation.title = [NSString stringWithFormat:@"%@", annotation.title];
    annotation.subtitle = [NSString stringWithFormat:@"%.0f meters tt", annotation.radius];
}

@end
