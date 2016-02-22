//
//  CTLWeather.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "CTLWeather.h"
#import "AFHTTPSessionManager.h"
#import "MDLWeather.h"
#import <MapKit/MapKit.h>


@implementation CTLWeather

#pragma mark - Request
- (void) doRequest:(CLLocationDegrees) latitude withLongitude:(CLLocationDegrees)longitude andCompletionHandler:(WeatherResponseBlock) responseHandler {
  
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/find?lat=%f&lon=%f&cnt=50&lang=pt&units=%@&appid=44db6a862fba0b067b1930da0d769e98", latitude, longitude, unitCelsius]];
    NSLog(@"URL: %@", URL);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSMutableArray *listResponse = [self parseJSON:responseObject withLatitude:latitude withLongitude:longitude];
        listResponse = [self sortListByDistance: listResponse];
        responseHandler(listResponse);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseHandler(nil);
    }];
}

#pragma mark - Get Cities
- (void)getCities:(CLLocationDegrees) latitude withLongitude:(CLLocationDegrees)longitude completionHandler:(WeatherResponseBlock) responseHandler
{
    [[[WeatherUnitHelper alloc] init] initWeatherUnit];

    [[[ImageHelper alloc] init] getImages:^(NSMutableArray *responseData){
        [self doRequest:latitude withLongitude:longitude andCompletionHandler:responseHandler];
    }];
}


#pragma mark - Parse

-(NSMutableArray*)parseJSON:(id)responseData withLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude{
    
    WeatherUnitHelper *weatherHelper = [[WeatherUnitHelper alloc] init];
   
    NSString *weatherUnit = [weatherHelper getWeatherUnit];
    BOOL convertToFahrenheit = [weatherUnit isEqualToString:unitFahrenheit];
    
    id listResult = [responseData objectForKey:@"list"];
    NSMutableArray *listCities = [[NSMutableArray alloc] init];
    
    for (id result in listResult){
        
        MDLWeather *weather = [[MDLWeather alloc] init];
        weather.cityName = [result objectForKey:@"name"];
        
        weather.coordinates = [[MDLWeatherCoordinates alloc] init];
        id weatherCoordinates = [result objectForKey:@"coord"];
        weather.coordinates.lat = [weatherCoordinates objectForKey:@"lat"];
        weather.coordinates.lon = [weatherCoordinates objectForKey:@"lon"];
        
        weather.conditions = [[MDLWeatherConditions alloc] init];
        id weatherCondition = [result objectForKey:@"main"];
        if (convertToFahrenheit){
            weather.conditions.temperature = [weatherHelper convertToFahrenheit: [weatherCondition objectForKey:@"temp"]];
            weather.conditions.temperatureMax = [weatherHelper convertToFahrenheit: [weatherCondition objectForKey:@"temp_max"]];
            weather.conditions.temperatureMin = [weatherHelper convertToFahrenheit: [weatherCondition objectForKey:@"temp_min"]];
        } else {
            weather.conditions.temperature = [weatherCondition objectForKey:@"temp"];
            weather.conditions.temperatureMax = [weatherCondition objectForKey:@"temp_max"];
            weather.conditions.temperatureMin = [weatherCondition objectForKey:@"temp_min"];
        }
        
        weather.weather = [[MDLWeatherDetail alloc] init];
        id weatherDetailResult = [[result objectForKey:@"weather"] objectAtIndex:0];
        weather.weather.weatherDescription = [weatherDetailResult objectForKey:@"description"];
        weather.weather.icon = [weatherDetailResult objectForKey:@"icon"];
        weather.weather.code = [weatherDetailResult objectForKey:@"id"];
        weather.weather.condition = [weatherDetailResult objectForKey:@"main"];
        
        CLLocation *locationA = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocation *locationB = [[CLLocation alloc] initWithLatitude:[weather.coordinates.lat doubleValue] longitude:[weather.coordinates.lon doubleValue]];
        weather.distance = [self getDistance:locationA locationB:locationB];
        
        [listCities addObject: weather];
        
    }
    
    return listCities;
}

-(NSMutableArray*)sortListByDistance:(NSMutableArray*)list{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortedArray = [list sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    return [[NSMutableArray alloc] initWithArray:sortedArray];
}

-(NSNumber*)getDistance:(CLLocation*)locationA locationB:(CLLocation*)locationB{
    CLLocationDistance distance = [locationA distanceFromLocation:locationB];
    return [NSNumber numberWithDouble:distance/1000];
}

@end
