//
//  MapViewController.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self getLocation];
    [self setBtnWeatherUnit];
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Map

-(void)initMap{
    self.map.delegate = self;
    [self setMarkers];
}

-(void)setMarkers{
    WeatherUnitHelper *weatherHelper = [[WeatherUnitHelper alloc] init];
    NSString *weatherUnit = [weatherHelper getWeatherUnitDescription];
    for (MDLWeather *weather in self.listCities){
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = [[[CLLocation alloc] initWithLatitude:[weather.coordinates.lat doubleValue] longitude:[weather.coordinates.lon doubleValue]] coordinate];
        point.title = weather.cityName;
        point.subtitle = [NSString stringWithFormat:@"%d%@", [weather.conditions.temperature intValue], weatherUnit];
        
        [self.map addAnnotation:point];
    }
}

-(void)setDefaultZoom{
    CLLocationCoordinate2D coord = [self.location coordinate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 15000, 15000);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
    [self.map setRegion:adjustedRegion animated:YES];
    self.map.showsUserLocation = YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.location = location;

    if (manager){
        [manager stopUpdatingLocation];
        manager.delegate = nil;
        manager = nil;
    }
    
    [self setDefaultZoom];
    [self initMap];
}

-(void)reloadMapMarkers{
    [self.map removeAnnotations:self.map.annotations];
    [self setMarkers];
}

#pragma mark - GetData

- (void) getData {
    
    CTLWeather *ctlWeather = [[CTLWeather alloc] init];
    [ctlWeather getCities:self.userLat withLongitude:self.userLon completionHandler:^(NSMutableArray *responseData){
        self.listCities = responseData;
        self.listViewController.listCities = responseData;
        [self performSelectorOnMainThread:@selector(reloadMapMarkers) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark - Bar Btn
-(void)setBtnWeatherUnit{
    WeatherUnitHelper *weatherHelper = [[WeatherUnitHelper alloc] init];
    [weatherHelper initWeatherUnit];
    self.btnWeatherUnit.title = [weatherHelper getWeatherUnitDescription];
}

- (IBAction)onBtnListClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onBtnWeatherUnitClick:(id)sender {
    WeatherUnitHelper *weatherHelper = [[WeatherUnitHelper alloc] init];
    
    [weatherHelper changeWeatherUnit];
    [self setBtnWeatherUnit];
    
    self.listCities = [weatherHelper convertListToNewUnit:self.listCities];
    
    [self reloadMapMarkers];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    CLLocationCoordinate2D centre = [self.map centerCoordinate];
    self.location = [[CLLocation alloc]initWithLatitude:centre.latitude longitude:centre.longitude];
    self.userLat = centre.latitude;
    self.userLon = centre.longitude;
    self.listViewController.userLat = centre.latitude;
    self.listViewController.userLon = centre.longitude;
    
    [self getData];
}

@end
