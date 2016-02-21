//
//  ListCitiesTableViewCell.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "ListCitiesTableViewCell.h"

@implementation ListCitiesTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews{
    [self cardSetup];
    [self imageSetup];
}

-(void)cardSetup{
    [self.viewCard setAlpha:1];
    self.viewCard.layer.masksToBounds = NO;
    self.viewCard.layer.cornerRadius = 1;
    self.viewCard.layer.shadowOffset = CGSizeMake(-.2f, -.2f);
    self.viewCard.layer.shadowRadius = 1;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.viewCard.bounds];
    self.viewCard.layer.shadowPath = path.CGPath;
    self.viewCard.layer.shadowOpacity = 0.2;
}

-(void)imageSetup {
    self.imgWeather.layer.cornerRadius = self.imgWeather.frame.size.width/2;
    self.imgWeather.clipsToBounds = YES;
    self.imgWeather.contentMode = UIViewContentModeScaleAspectFit;
}

@end
