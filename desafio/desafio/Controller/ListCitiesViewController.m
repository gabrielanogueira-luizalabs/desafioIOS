//
//  ViewController.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "ListCitiesViewController.h"

@interface ListCitiesViewController ()

@end

@implementation ListCitiesViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initTableView];
    [self setBtnWeatherUnit];
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
        
        if(responseData == nil) {
            [self showDialog:@"Ocorreu um erro ao obter os dados de previsão do tempo."];
        }
        else {
            self.listCities = responseData;
        }
        
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
    self.tbvListCities.separatorColor = [UIColor clearColor];
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
    
    WeatherUnitHelper *weatherHelper = [[WeatherUnitHelper alloc] init];
    ImageHelper *imageHelper = [[ImageHelper alloc] init];

    cell.lblCityName.text = weather.cityName;
    cell.imgWeather.image = [imageHelper getUIImage:weather.weather.icon];
    cell.lblWeatherDescription.text = [weather.weather.weatherDescription capitalizedString];

    NSString *weatherUnit = [weatherHelper getWeatherUnitDescription];
    cell.lblTemperature.text = [NSString stringWithFormat:@"%.0f%@", [weather.conditions.temperature floatValue], weatherUnit];
    cell.lblTemperatureMin.text = [NSString stringWithFormat:@"%.0f%@", [weather.conditions.temperatureMin floatValue], weatherUnit];
    cell.lblTemperatureMax.text = [NSString stringWithFormat:@"%.0f%@", [weather.conditions.temperatureMax floatValue], weatherUnit];

    cell.lblDistance.text = [NSString stringWithFormat:@"%.2fKm", [weather.distance floatValue]];
    
    return cell;
}

#pragma mark - Location

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *location = [locations lastObject];
    self.userLat = location.coordinate.latitude;
    self.userLon = location.coordinate.longitude;
    
    NSLog(@"User lat : %lf lon : %lf", self.userLat, self.userLon);
    
    if (manager){
        [manager stopUpdatingLocation];
        manager.delegate = nil;
        manager = nil;
    }
    
    [self getData];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusDenied){
        [self showDialog:@"Não é possível obter dados sem autorização de localização."];
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
    WeatherUnitHelper *weatherHelper = [[WeatherUnitHelper alloc] init];

    [weatherHelper changeWeatherUnit];
    [self setBtnWeatherUnit];
    
    self.listCities = [weatherHelper convertListToNewUnit:self.listCities];
    [self.tbvListCities reloadData];
}

-(void)setBtnWeatherUnit{
    WeatherUnitHelper *weatherHelper = [[WeatherUnitHelper alloc] init];
    [weatherHelper initWeatherUnit];
    self.btnWeatherUnit.title = [weatherHelper getWeatherUnitDescription];
}
@end
