//
//  ListCitiesTableViewCell.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCitiesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperatureMin;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperatureMax;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

@end
