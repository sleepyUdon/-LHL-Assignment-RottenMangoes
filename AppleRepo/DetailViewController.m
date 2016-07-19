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
    
    self.movieTitle.text= self.movie.movieTitle;
    self.moviePicture.image = self.movie.moviePicture;
    
    
    
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
