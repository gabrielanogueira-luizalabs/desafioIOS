//
//  BaseViewController.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController () <JGProgressHUDDelegate> {
    JGProgressHUDStyle _style;
    JGProgressHUDInteractionType _interaction;
    JGProgressHUD *HUD;
}

@end

@implementation BaseViewController

#pragma mark - Hud
- (JGProgressHUD *)prototypeHUD {
    _style = JGProgressHUDStyleDark;
    HUD = [[JGProgressHUD alloc] initWithStyle:_style];
    
    _interaction = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.interactionType = _interaction;
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
    HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    HUD.HUDView.layer.shadowOffset = CGSizeZero;
    HUD.HUDView.layer.shadowOpacity = 0.4f;
    HUD.HUDView.layer.shadowRadius = 8.0f;
    
    HUD.delegate = self;
    
    return HUD;
}

-(void)showHUDSimple:(NSString *)txt {
    HUD = [self prototypeHUD];
    HUD.textLabel.text = txt;
    [HUD showInView:self.view];
}

-(void)dismissHUD {
    [HUD dismiss];
}

#pragma mark - Location

-(void)getLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.headingFilter = 1;
    self.locationManager.delegate = self;
    
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus != kCLAuthorizationStatusAuthorizedAlways && [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] )
        [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"locationManager didFailWithError %@", error.description);
}


@end
