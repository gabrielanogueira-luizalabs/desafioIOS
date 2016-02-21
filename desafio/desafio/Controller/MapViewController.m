//
//  MapViewController.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "MapViewController.h"
#import "CTLWeather.h"

@interface MapViewController ()

@end

@implementation MapViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getLocation];
    [self setBtnWeatherUnit];
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Map

-(void)initMap{
    CTLWeather *cltWeather = [[CTLWeather alloc] init];
    NSString *weatherUnit = [cltWeather getWeatherUnitDescription];
    self.map.delegate = self;
    
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
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 10000, 10000);
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
    [self initMap];
}

#pragma mark - GetData

- (void) getData {
    
    [self performSelectorOnMainThread:@selector(showHUDSimple:) withObject:@"Aguarde..." waitUntilDone:NO];
    self.navigationController.navigationBar.userInteractionEnabled = FALSE;
    
    CTLWeather *ctlWeather = [[CTLWeather alloc] init];
    [ctlWeather getCities:self.userLat withLongitude:self.userLon completionHandler:^(NSMutableArray *responseData){
        NSLog(@"terminou %@", responseData);
        self.listCities = responseData;
        self.listViewController.listCities = responseData;
        [self performSelectorOnMainThread:@selector(dismissHUD) withObject:nil waitUntilDone:NO];
        self.navigationController.navigationBar.userInteractionEnabled = TRUE;
        [self performSelectorOnMainThread:@selector(reloadMapMarkers) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark - Bar Btn
-(void)setBtnWeatherUnit{
    CTLWeather *ctlWeather = [[CTLWeather alloc] init];
    [ctlWeather initWeatherUnit];
    self.btnWeatherUnit.title = [ctlWeather getWeatherUnitDescription];
}

- (IBAction)onBtnListClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onBtnWeatherUnitClick:(id)sender {
    CTLWeather *cltWeather = [[CTLWeather alloc] init];
    
    [cltWeather changeWeatherUnit];
    [self setBtnWeatherUnit];
    
    if ([[cltWeather getWeatherUnit] isEqualToString:unitCelsius]){
        self.listCities = [cltWeather convertListToCelsius:self.listCities];
    } else {
        self.listCities = [cltWeather convertListToFahrenheit:self.listCities];
    }
    
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
