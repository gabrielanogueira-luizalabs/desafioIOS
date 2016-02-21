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

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initTableView];
    [self setBtnWeatherUnit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tbvListCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark - GetData

- (void) getData {
    
    [self performSelectorOnMainThread:@selector(showHUDSimple:) withObject:@"Aguarde..." waitUntilDone:NO];
    self.navigationController.navigationBar.userInteractionEnabled = FALSE;

    CTLWeather *ctlWeather = [[CTLWeather alloc] init];
    [ctlWeather getCities:self.userLat withLongitude:self.userLon completionHandler:^(NSMutableArray *responseData){
        NSLog(@"terminou %@", responseData);
        self.listCities = responseData;
        [self performSelectorOnMainThread:@selector(dismissHUD) withObject:nil waitUntilDone:NO];
        self.navigationController.navigationBar.userInteractionEnabled = TRUE;
        [self.tbvListCities performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}



#pragma mark - TableView

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
    
    CTLWeather *cltWeather = [[CTLWeather alloc] init];
    NSString *weatherUnit = [cltWeather getWeatherUnitDescription];
    cell.lblCityName.text = weather.cityName;
    cell.imgWeather.image = [cltWeather getUIImage:weather.weather.icon];
    cell.lblWeatherDescription.text = [weather.weather.weatherDescription capitalizedString];
    cell.lblTemperature.text = [NSString stringWithFormat:@"%.0f%@", [weather.conditions.temperature floatValue], weatherUnit];
    cell.lblTemperatureMin.text = [NSString stringWithFormat:@"%.0f%@", [weather.conditions.temperatureMin floatValue], weatherUnit];
    cell.lblTemperatureMax.text = [NSString stringWithFormat:@"%.0f%@", [weather.conditions.temperatureMax floatValue], weatherUnit];
    cell.lblDistance.text = [NSString stringWithFormat:@"%.2f Km", [weather.distance floatValue]];
    return cell;
}

#pragma mark - Location

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
        manager.delegate = nil;
        manager = nil;
    }
    
    [self getData];
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusDenied){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Atenção"
                                                                       message:@"Não é possível obter dados sem autorização de localização  ."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Bar Btn

- (IBAction)onBtnMapClick:(id)sender {
    UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapView = [sboard instantiateViewControllerWithIdentifier:@"sboMap"];
    mapView.listCities = self.listCities;
    mapView.listViewController = self;
    [self.navigationController pushViewController:mapView animated:YES];
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
    
    [self.tbvListCities reloadData];
}

-(void)setBtnWeatherUnit{
    CTLWeather *ctlWeather = [[CTLWeather alloc] init];
    [ctlWeather initWeatherUnit];
    self.btnWeatherUnit.title = [ctlWeather getWeatherUnitDescription];
}
@end
