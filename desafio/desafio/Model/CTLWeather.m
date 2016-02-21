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
  
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/box/city?bbox=%@&cluster=yes&appid=44db6a862fba0b067b1930da0d769e98", boundingBox]];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/find?lat=%f&lon=%f&cnt=50&lang=pt&units=%@&appid=44db6a862fba0b067b1930da0d769e98", latitude, longitude, unitCelsius]];
    NSLog(@"%@", URL);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        responseHandler([self parseJSON:responseObject withLatitude:latitude withLongitude:longitude]);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Get Cities
- (void)getCities:(CLLocationDegrees) latitude withLongitude:(CLLocationDegrees)longitude completionHandler:(WeatherResponseBlock) responseHandler
{
    [self initWeatherUnit];

    [self getImages:^(NSMutableArray *responseData){
        [self doRequest:latitude withLongitude:longitude andCompletionHandler:responseHandler];
    }];
}

#pragma mark - WeatherUnit
-(void)initWeatherUnit{
    NSString *unit = [self getWeatherUnit];
    if (unit == nil){
        [self setWeatherUnit:unitCelsius];
    }
}

-(NSString*)getWeatherUnit{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *unit = [prefs stringForKey:@"weatherUnit"];
    return unit;
}

-(NSString*)getWeatherUnitDescription{
    NSString *weatherUnit = [self getWeatherUnit];
    if ([weatherUnit isEqualToString:unitCelsius]){
        return unitCelsiusDescription;
    } else {
        return unitFahrenheitDescription;
    }
}

-(void)setWeatherUnit:(NSString*)unit{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:unit forKey:@"weatherUnit"];
}

-(void)changeWeatherUnit{
    NSString *weatherUnit = [self getWeatherUnit];
    if ([weatherUnit isEqualToString:unitFahrenheit]){
        [self setWeatherUnit:unitCelsius];
    } else {
        [self setWeatherUnit:unitFahrenheit];
    }
}

-(NSNumber*)convertToCelsius:(NSNumber*)temperature{
    
    float floatTemp = [temperature floatValue];
    floatTemp = (floatTemp - 32) / 1.8;
    
    return [NSNumber numberWithFloat:floatTemp];
}

-(NSNumber*)convertToFahrenheit:(NSNumber*)temperature{
    float floatTemp = [temperature floatValue];
    floatTemp = (floatTemp *1.8) + 32;
    
    return [NSNumber numberWithFloat:floatTemp];
}

-(NSMutableArray*)convertListToCelsius:(NSMutableArray*)list{
    for (MDLWeather *weather in list){
        weather.conditions.temperature = [self convertToCelsius: weather.conditions.temperature];
        weather.conditions.temperatureMax = [self convertToCelsius: weather.conditions.temperatureMax];
        weather.conditions.temperatureMin = [self convertToCelsius: weather.conditions.temperatureMin];
    }
    return list;
}

-(NSMutableArray*)convertListToFahrenheit:(NSMutableArray*)list{
    for(MDLWeather *weather in list){
        weather.conditions.temperature = [self convertToFahrenheit: weather.conditions.temperature];
        weather.conditions.temperatureMax = [self convertToFahrenheit: weather.conditions.temperatureMax];
        weather.conditions.temperatureMin = [self convertToFahrenheit: weather.conditions.temperatureMin];
    }
    
    return list;
}

#pragma mark - Parse

-(NSMutableArray*)parseJSON:(id)responseData withLatitude:(CLLocationDegrees)latide withLongitude:(CLLocationDegrees)longitude{
    
    BOOL convertToFahrenheit = false;
    NSString *weatherUnit = [self getWeatherUnit];
    if (![weatherUnit isEqualToString:unitCelsius]){
        convertToFahrenheit = true;
    }
    
    id listResult = [responseData objectForKey:@"list"];
    
    NSMutableArray *listCities = [[NSMutableArray alloc] init];
    for (id result in listResult){
        NSLog(@"%@", result);
        
        MDLWeather *weather = [[MDLWeather alloc] init];
        weather.cityName = [result objectForKey:@"name"];
        
        weather.coordinates = [[MDLWeatherCoordinates alloc] init];
        id weatherCoordinates = [result objectForKey:@"coord"];
        weather.coordinates.lat = [weatherCoordinates objectForKey:@"lat"];
        weather.coordinates.lon = [weatherCoordinates objectForKey:@"lon"];
        
        weather.conditions = [[MDLWeatherConditions alloc] init];
        id weatherCondition = [result objectForKey:@"main"];
        if (convertToFahrenheit){
            weather.conditions.temperature = [self convertToFahrenheit: [weatherCondition objectForKey:@"temp"]];
            weather.conditions.temperatureMax = [self convertToFahrenheit: [weatherCondition objectForKey:@"temp_max"]];
            weather.conditions.temperatureMin = [self convertToFahrenheit: [weatherCondition objectForKey:@"temp_min"]];
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
        
        
        CLLocation *locationA = [[CLLocation alloc] initWithLatitude:latide longitude:longitude];
        CLLocation *locationB = [[CLLocation alloc] initWithLatitude:[weather.coordinates.lat doubleValue] longitude:[weather.coordinates.lon doubleValue]];

        weather.distance = [self getDistance:locationA locationB:locationB];
        
        [listCities addObject: weather];
        
    }
    
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortedArray = [listCities sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    listCities = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    return listCities;
}

-(NSNumber*)getDistance:(CLLocation*)locationA locationB:(CLLocation*)locationB{
    CLLocationDistance distance = [locationA distanceFromLocation:locationB];
    return [NSNumber numberWithDouble:distance/1000];
}

#pragma mark - Images

-(void)getImages:(WeatherResponseBlock)responseHandler {
    
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    if(![fileManager fileExistsAtPath:imagePath isDirectory:&isDir])
    {
        NSArray *listImages = [NSArray arrayWithObjects:
                               @"01d",
                               @"01n",
                               @"02d",
                               @"02n",
                               @"03d",
                               @"03n",
                               @"04d",
                               @"04n",
                               @"09d",
                               @"09n",
                               @"10d",
                               @"10n",
                               @"11d",
                               @"11n",
                               @"13d",
                               @"13n",
                               @"50d",
                               @"50n", nil];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            for (NSString *image in listImages) {
                
                NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"http://openweathermap.org/img/w/%@.png", image]];
                NSData *img = [NSData dataWithContentsOfURL:url];
                [self saveImage:img withImageName:image];
            }
            responseHandler(nil);
        });
    } else {
        responseHandler(nil);
    }
    
    
}

-(void)saveImage:(NSData*)imageData withImageName:(NSString*)imageName {
//    NSData *imageData = UIImagePNGRepresentation(newImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    if(![fileManager fileExistsAtPath:imagePath isDirectory:&isDir])
        if(![fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:NULL])
            NSLog(@"Error: Create folder failed %@", imagePath);
    
    
    imagePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog((@"the cachedImagedPath is %@",imagePath));
    }
}

-(UIImage*)getUIImage:imageName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    imagePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];

    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}



@end
