//
//  CTLWeather.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "MDLWeather.h"
#import "WeatherUnitHelper.h"
#import "ImageHelper.h"

@interface CTLWeather : NSObject

typedef void (^WeatherResponseBlock)(NSMutableArray *responseData);

- (void)getCities:(CLLocationDegrees) latitude withLongitude:(CLLocationDegrees)longitude completionHandler:(WeatherResponseBlock) responseHandler;

@end
