//
//  MasterViewController.m
//  AppleRepo
//
//  Created by Ken Woo on 2016-07-18.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Movie.h"
#import "CustomTableViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *movies;
@property UIImage *tmpImage;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=55gey28y6ygcr8fjy4ty87ek&page_limit=50"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSLog(@"C. Request Done");
        
        if (!error) {
            // NSLog(@"Data: %@", data);
            
            NSError *jsonError;
            
            NSDictionary *apiInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *movieArray = apiInfo[@"movies"];
            if (!jsonError) {
                
                NSMutableArray *movies = [NSMutableArray array];
                
                for (NSDictionary *movieDict in movieArray) {
                    Movie *movie = [[Movie alloc] init];

                    movie.movieTitle = movieDict[@"title"];
                    movie.movieSynopsis = movieDict [@"synopsis"];
                    
                    NSString *urlImage =  movieDict[@"posters"][@"thumbnail"];
                    NSLog(@"%@", urlImage);

                    UIImage *tmpImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]]];
                    movie.moviePicture = tmpImage;

                    [movies addObject:movie];
                }
                
                self.movies = movies;
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = [NSString stringWithFormat:@"%ld movies", movies.count];
                    [self.tableView reloadData];
                });
                
            }
            
            
        } else {
            NSLog(@"Request error: %@", error.localizedDescription);
        }
        
    }];
    
    [dataTask resume];
    
                  }
    


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

#pragma mark - Segues

/*
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([[segue identifier] isEqualToString:@"showDetail"]) {
 NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
 NSDate *object = self.objects[indexPath.row];
 DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
 [controller setDetailItem:object];
 controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
 controller.navigationItem.leftItemsSupplementBackButton = YES;
 }
 }
 */

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.row];
    
    cell.movieTitle.text = movie.movieTitle;
    cell.movieSynopsis.text = movie.movieSynopsis;
    cell.imageMovie.image = movie.moviePicture;
    
    return cell;
}



@end
