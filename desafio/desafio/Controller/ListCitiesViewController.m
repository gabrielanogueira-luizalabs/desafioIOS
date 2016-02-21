//
//  ViewController.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "ListCitiesViewController.h"
#import "ListCitiesTableViewCell.h"
#import "MDLWeather.h"
#import "MapViewController.h"

@interface ListCitiesViewController ()

@end

@implementation ListCitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initTableView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getData {
    
     [self performSelectorOnMainThread:@selector(showHUDSimple:) withObject:@"Aguarde..." waitUntilDone:YES];
    
    CTLWeather *net = [[CTLWeather alloc] init];
    
    [net getCities:self.userLat withLongitude:self.userLon completionHandler:^(NSMutableArray *responseData){
        NSLog(@"terminou %@", responseData);
        self.listCities = responseData;
        [self dismissHUD];
        [self.tbvListCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}


#pragma mark - TABLEVIEW

-(void)initTableView {
    self.tbvListCities.delegate = self;
    self.tbvListCities.dataSource = self;
    self.tbvListCities.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tbvListCities reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDLWeather *weather = [self.listCities objectAtIndex: indexPath.row];
    ListCitiesTableViewCell *cell;
    
    NSString *CellIdentifier = @"idCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ListCitiesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.lblCityName.text = weather.cityName;
    cell.imgWeather.image = [[[CTLWeather alloc] init] getUIImage:weather.weather.icon];
    cell.lblWeatherDescription.text = weather.weather.condition;
    cell.lblTemperature.text = [NSString stringWithFormat:@"%d", [weather.conditions.temperature intValue]];
    cell.lblTemperatureMin.text = [NSString stringWithFormat:@"%d", [weather.conditions.temperatureMin intValue]];
    cell.lblTemperatureMax.text = [NSString stringWithFormat:@"%d", [weather.conditions.temperatureMax intValue]];
    cell.lblDistance.text = [NSString stringWithFormat:@"%.2f Km", [weather.distance floatValue]];
    return cell;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.userLat = location.coordinate.latitude;
    self.userLon = location.coordinate.longitude;
    
    NSLog(@" ----------------------------- ");
    NSLog(@"User lat : %lf", self.userLat);
    NSLog(@"User lon : %lf", self.userLon);
    NSLog(@" ----------------------------- ");
    
    if (manager){
        [manager stopUpdatingLocation];
    }
    
    [self getData];
    
}
- (IBAction)onBtnMapClick:(id)sender {
    UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapView = [sboard instantiateViewControllerWithIdentifier:@"sboMap"];
    mapView.listCities = self.listCities;
    [self.navigationController pushViewController:mapView animated:YES];
}
@end
