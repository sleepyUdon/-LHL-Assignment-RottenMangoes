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
@property CLLocation *currentLocation;





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
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 50;

    if ([CLLocationManager locationServicesEnabled]) {
    
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
            [self.locationManager requestWhenInUseAuthorization];
        }
    
    }
    self.currentLocation = self.locationManager.location;
//    [self.locationManager startUpdatingLocation];

    [self addTheatres];
}




- (void)addTheatres {
    NSString *baseURL = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=";
    NSString *postalCode = @"M6K2N1";
    NSString *appendURL = @"&movie=";
    NSString *appendURL1 = self.movie.movieTitle;
    NSString *endURL = [NSString stringWithFormat:@"%@%@%@%@",baseURL, postalCode,appendURL, appendURL1];
    NSString* encodedEndURl = [endURL stringByReplacingOccurrencesOfString:@" " withString:@"_"];

//    NSString *endURL = [[[baseURL stringByAppendingString:postalCode]stringByAppendingString:appendURL]stringByAppendingString:appendURL1];
    
//    NSString *endURL = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=M5V2H8&movie=Ghostbusters";

    NSLog(@"%@", encodedEndURl);

    NSURL *url = [NSURL URLWithString:encodedEndURl];
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

                NSMutableArray *annotations = [NSMutableArray array];
                
                for (NSDictionary *theatre in theatresArray) {
                    
                    
                    Theatre *marker = [[Theatre alloc] init];
                    
                    marker.coordinate = CLLocationCoordinate2DMake([theatre[@"lat"] doubleValue], [theatre[@"lng"] doubleValue]);
                    
                    marker.title = theatre[@"name"];
                    NSLog(@"%@", marker.title);
                    

                    marker.subtitle = theatre[@"address"];
                    NSLog(@"%@", marker.subtitle);

                    [annotations addObject:marker];
                   
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.mapView addAnnotations:annotations];
                    
                    
                });
                
                
            
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
        
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1,0.1));
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
        theatreView.centerOffset = CGPointMake(0, - theatreView.frame.size.height /2);

    }
    
    return theatreView;
}


- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
}
 


@end

