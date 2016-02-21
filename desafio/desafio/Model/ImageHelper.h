//
//  ImageHelper.h
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject

typedef void (^WeatherResponseBlock)(NSMutableArray *responseData);

- (UIImage*) getUIImage:(NSString*)imageName;
- (void)getImages:(WeatherResponseBlock) responseHandler;

@end
