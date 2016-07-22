//
//  Movie.h
//  AppleRepo
//
//  Created by Viviane Chan on 2016-07-18.
//  Copyright © 2016 Lighthouse Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) UIImage *moviePicture;
@property (strong,nonatomic)  NSString *movieSynopsis;
@property (strong,nonatomic)  NSURL *movieReview;

@end
