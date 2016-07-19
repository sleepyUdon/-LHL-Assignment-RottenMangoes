//
//  MapDetailViewController.m
//  AppleRepo
//
//  Created by Viviane Chan on 2016-07-19.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import "MapDetailViewController.h"
@import CoreLocation;
@import MapKit;
#import "Theatre.h"

@interface MapDetailViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) BOOL shouldZoomIntoUser;

@end


@implementation MapDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.


self.shouldZoomIntoUser = YES;

self.locationManager = [[CLLocationManager alloc] init];
self.locationManager.delegate = self;

self.mapView.delegate = self;
//self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//self.locationManager.distanceFilter = 50;

if ([CLLocationManager locationServicesEnabled]) {
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}

[self addTheatres];

}




- (void)addTheatres {
    NSString *jsonPath =[[NSBundle mainBundle] pathForResource:@"theatres" ofType:@"json"]; 
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSError *error = nil;
    NSDictionary *theatresDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!error) {
        
        NSArray *theatres = theatresDict [@"theatres"];
        
        for (NSDictionary *theatre in theatres) {
            
            Theatre *marker = [[Theatre alloc] init];
            
            marker.coordinate = CLLocationCoordinate2DMake([theatre[@"lat"] doubleValue], [theatre[@"lng"] doubleValue]);
            marker.title = theatre[@"name"];
            marker.subtitle = theatre[@"address"];
            
            [self.mapView addAnnotation:marker];
            
        }
    }
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization Changed to: %d", status);
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Authorized!");
        
        self.mapView.showsUserLocation = YES;
        self.mapView.showsPointsOfInterest = YES;
        
        [self.locationManager startUpdatingLocation];
        
        //[self.locationManager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"New locations: %@", locations);
    // [self.locationManager stopUpdatingLocation]
    
    CLLocation *location = [locations lastObject];
    
    if (self.shouldZoomIntoUser) {
        self.shouldZoomIntoUser = NO;
        
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1));
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location error: %@", error.localizedDescription);
}

#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *theatreView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"movieLogo"];
    if (!theatreView) {
        theatreView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"movieLogo"];
        theatreView.image = [UIImage imageNamed:@"movieLogo"];
        theatreView.frame = CGRectMake(0, 0, 50, 50);
        theatreView.centerOffset = CGPointMake(0, - theatreView.image.size.height /2);
    }
    
    return theatreView;
}


@end

