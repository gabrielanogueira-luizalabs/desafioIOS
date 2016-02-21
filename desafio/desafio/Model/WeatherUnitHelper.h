//
//  WeatherUnitHelper.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDLWeather.h"

#define unitCelsius @"metric"
#define unitFahrenheit @"imperial"
#define unitCelsiusDescription @"ºC"
#define unitFahrenheitDescription @"ºF"

@interface WeatherUnitHelper : NSObject

-(void)initWeatherUnit;

-(void)setWeatherUnit:(NSString*)unit;

-(NSString*)getWeatherUnit;
-(NSString*)getWeatherUnitDescription;

-(void)changeWeatherUnit;

-(NSMutableArray*)convertListToNewUnit:(NSMutableArray*)list;
-(NSNumber*)convertToCelsius:(NSNumber*)temperature;
-(NSNumber*)convertToFahrenheit:(NSNumber*)temperature;

@end
