//
//  MDLWeatherDetail.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MDLWeatherDetail : NSObject

@property (strong, nonatomic) NSString* weatherDescription;
@property (strong, nonatomic) NSString* icon;
@property (strong, nonatomic) NSString* code;
@property (strong, nonatomic) NSString* condition;

@end
