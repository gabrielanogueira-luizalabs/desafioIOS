//
//  MDLWeather.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDLWeatherCoordinates.h"
#import "MDLWeatherConditions.h"
#import "MDLWeatherDetail.h"

@interface MDLWeather : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (strong, nonatomic) MDLWeatherCoordinates *coordinates;
@property (strong, nonatomic) MDLWeatherConditions *conditions;
@property (strong, nonatomic) MDLWeatherDetail *weather;
@property (nonatomic) NSNumber *distance;

@end
