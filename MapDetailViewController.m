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
#import "Movie.h"


@interface MapDetailViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) BOOL shouldZoomIntoUser;
@property NSMutableArray *theatres;
@property NSMutableArray *movies;





@end


@implementation MapDetailViewController
- (void) viewWillAppear:(BOOL)animated {

}

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
    
    NSString *baseURL = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=M6K2N1&movie=";
//    NSString *appendURL =@"Ghostbusters"; //hardcoded
    NSString *appendURL = self.movie.movieTitle;
    NSLog(@"movieTitle: %@", self.movie.movieTitle);

    NSString *endURL = [baseURL stringByAppendingString:appendURL];
                            
    NSURL *url = [NSURL URLWithString:endURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"C. Request Done");

        if (!error) {
             NSLog(@"Data: %@", data);

            
            NSError *jsonError;
            
            NSDictionary * apiInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSArray *theatresArray = apiInfo[@"theatres"];

            if (!jsonError) {
                 NSLog(@"Data: %@", theatresArray);

                
                for (NSDictionary *theatre in theatresArray) {
                    
                    
                    Theatre *marker = [[Theatre alloc] init];
                    
                    marker.coordinate = CLLocationCoordinate2DMake([theatre[@"lat"] doubleValue], [theatre[@"lng"] doubleValue]);
                    
                    marker.title = theatre[@"name"];
                    NSLog(@"%@", marker.title);
                    

                    marker.subtitle = theatre[@"address"];
                    NSLog(@"%@", marker.subtitle);

                    
                    [self.mapView addAnnotation:marker];}
            
            } else {
            NSLog(@"Request error: %@", error.localizedDescription);
            }
        }
    }];
    
        NSLog(@"A. Before request starts");
        [dataTask resume];
        NSLog(@"B. After request starts");
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
        
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.5, 0.5));
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
//        [mapView viewForAnnotation:annotation];
//        theatreView.image = [annotation getPin];

    }
    
    return theatreView;
}


- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
}


@end

