//
//  ANearbyViewController.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ANearbyViewController : AViewController <MKMapViewDelegate> {
    
    CLLocation *lastLocation;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapViewNearby;
@property (strong, nonatomic) NSArray *users;

@end
