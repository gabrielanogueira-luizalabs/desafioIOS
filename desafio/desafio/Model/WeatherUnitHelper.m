//
//  WeatherUnitHelper.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "WeatherUnitHelper.h"

@implementation WeatherUnitHelper

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

-(NSMutableArray *)convertListToNewUnit:(NSMutableArray *)list{
    if ([[self getWeatherUnit] isEqualToString:unitCelsius]){
        list = [self convertListToCelsius:list];
    } else {
        list = [self convertListToFahrenheit:list];
    }
    return list;
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


@end
