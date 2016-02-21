//
//  ViewController.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTLWeather.h"
#import "BaseViewController.h"

@interface ListCitiesViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbvListCities;
@property (nonatomic) NSMutableArray *listCities;
- (IBAction)onBtnMapClick:(id)sender;

@end

