//
//  MapViewController.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "ListCitiesViewController.h"
#import "MDLWeather.h"
#import "CTLWeather.h"

@class ListCitiesViewController;

@interface MapViewController : BaseViewController<MKMapViewDelegate>

- (IBAction)onBtnListClick:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property(nonatomic) CLLocation *location;
@property(nonatomic) NSMutableArray *listCities;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnWeatherUnit;
- (IBAction)onBtnWeatherUnitClick:(id)sender;

@property(nonatomic) ListCitiesViewController *listViewController;

@end
