//
//  CTLWeather.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDLWeather.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@interface CTLWeather : NSObject

typedef void (^WeatherResponseBlock)(NSMutableArray *responseData);
- (void)getCities:(CLLocationDegrees) latitude withLongitude:(CLLocationDegrees)longitude completionHandler:(WeatherResponseBlock) responseHandler;
- (void)getImages:(WeatherResponseBlock) responseHandler;
- (UIImage*) getUIImage:(NSString*)imageName;

@end
