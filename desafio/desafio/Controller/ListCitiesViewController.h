//
//  ViewController.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTLWeather.h"
#import "MDLWeather.h"
#import "WeatherUnitHelper.h"
#import "ImageHelper.h"
#import "BaseViewController.h"
#import "ListCitiesTableViewCell.h"
#import "MapViewController.h"

@interface ListCitiesViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbvListCities;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnWeatherUnit;

- (IBAction)onBtnMapClick:(id)sender;
- (IBAction)onBtnWeatherUnitClick:(id)sender;

@property (nonatomic) NSMutableArray *listCities;
@end

