//
//  BaseViewController.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"
#import "JGProgressHUD.h"

@interface BaseViewController : UIViewController<CLLocationManagerDelegate>

-(void) showHUDSimple:(NSString*)txt;
-(void) dismissHUD;

@property(nonatomic) CLLocationDegrees userLat;
@property(nonatomic) CLLocationDegrees userLon;
@property(nonatomic) CLLocationManager *locationManager;

@end
