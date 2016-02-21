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

- (void) doRequest:(CLLocationDegrees) latitude withLongitude:(CLLocationDegrees)longitude andCompletionHandler:(WeatherResponseBlock) responseHandler {
  
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/box/city?bbox=%@&cluster=yes&appid=44db6a862fba0b067b1930da0d769e98", boundingBox]];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/find?lat=%f&lon=%f&cnt=50&appid=44db6a862fba0b067b1930da0d769e98", latitude, longitude]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        responseHandler([self parseJSON:responseObject withLatitude:latitude withLongitude:longitude]);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getCities:(CLLocationDegrees) latitude withLongitude:(CLLocationDegrees)longitude completionHandler:(WeatherResponseBlock) responseHandler
{
    [self doRequest:latitude withLongitude:longitude andCompletionHandler:responseHandler];
    [self getImages:responseHandler];
}

-(NSString*)getBoundingBox:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude{
    CLLocationCoordinate2D center = { latitude, longitude };
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 50000.0, 50000.0);
    CLLocationCoordinate2D northWestCorner, southEastCorner;
    northWestCorner.latitude  = center.latitude  - (region.span.latitudeDelta  / 2.0);
    northWestCorner.longitude = center.longitude + (region.span.longitudeDelta / 2.0);
    southEastCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 2.0);
    southEastCorner.longitude = center.longitude - (region.span.longitudeDelta / 2.0);
    
    NSString *boundingBox = [NSString stringWithFormat:@"%f,%f,%f,%f", northWestCorner.latitude, southEastCorner.latitude, northWestCorner.longitude, southEastCorner.longitude];
    
    NSLog(@"%@", boundingBox);
    return boundingBox;
    
//    [lon-left,lat-bottom,lon-right,lat-top]
}

-(NSMutableArray*)parseJSON:(id)responseData withLatitude:(CLLocationDegrees)latide withLongitude:(CLLocationDegrees)longitude{
    
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
        weather.conditions.temperature = [weatherCondition objectForKey:@"temp"];
        weather.conditions.temperatureMax = [weatherCondition objectForKey:@"temp_max"];
        weather.conditions.temperatureMin = [weatherCondition objectForKey:@"temp_min"];
        
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

-(void)getImages:(WeatherResponseBlock)responseHandler {
    
    BOOL isDir;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
//    if(![fileManager fileExistsAtPath:imagePath isDirectory:&isDir])
//    {
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
        
        for (NSString *image in listImages) {
            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"http://openweathermap.org/img/w/%@.png", image]];
            NSData *img = [NSData dataWithContentsOfURL:url];
            [self saveImage:img withImageName:image];
        }
//    }
    
    responseHandler(nil);
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
