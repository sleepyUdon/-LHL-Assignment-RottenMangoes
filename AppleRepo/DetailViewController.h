//
//  DetailViewController.h
//  AppleRepo
//
//  Created by Ken Woo on 2016-07-18.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;


@property (strong, nonatomic) Movie*movie;

@property (weak, nonatomic) IBOutlet UIImageView *moviePicture;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;



@end

