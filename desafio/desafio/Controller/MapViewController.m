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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


-(void)setDefaultZoom{
    CLLocationCoordinate2D coord = [self.location coordinate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
    [self.map setRegion:adjustedRegion animated:YES];
    self.map.showsUserLocation = YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.location = location;

    if (manager){
        [manager stopUpdatingLocation];
    }
    
    [self setDefaultZoom];
}

-(void)initMap{
    for (MDLWeather *weather in self.listCities){
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = [[[CLLocation alloc] initWithLatitude:[weather.coordinates.lat doubleValue] longitude:[weather.coordinates.lon doubleValue]] coordinate];
        point.title = weather.cityName;
        point.subtitle = [NSString stringWithFormat:@"%d", [weather.conditions.temperature intValue]];
        
        [self.map addAnnotation:point];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnListClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
