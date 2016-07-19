//
//  DetailViewController.m
//  AppleRepo
//
//  Created by Ken Woo on 2016-07-18.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item



- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
    
    self.movie.movieTitle = self.movieTitle.text;
    self.movie.moviePicture = self.moviePicture.image;
    
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
