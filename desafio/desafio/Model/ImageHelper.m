//
//  ImageHelper.m
//  desafio
//
//  Created by Gabriela Nogueira on 2/21/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import "ImageHelper.h"


@implementation ImageHelper

#pragma mark - Images

-(NSString*)getImageDirectoryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    return imageDirectoryPath;
}

-(BOOL)imageDirectoryExists{
    NSString *imageDirectoryPath = [self getImageDirectoryPath];
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    BOOL isDir;
    BOOL folderExists = [fileManager fileExistsAtPath:imageDirectoryPath isDirectory:&isDir];
    
    return folderExists;
}

-(void)getImages:(WeatherResponseBlock)responseHandler {
    
    if(![self imageDirectoryExists])
    {
        NSArray *listImages = [NSArray arrayWithObjects: @"01d", @"01n", @"02d", @"02n", @"03d", @"03n", @"04d", @"04n", @"09d", @"09n", @"10d", @"10n", @"11d", @"11n", @"13d", @"13n", @"50d", @"50n", nil];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            for (NSString *image in listImages) {
                
                NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"http://openweathermap.org/img/w/%@.png", image]];
                NSData *img = [NSData dataWithContentsOfURL:url];
                [self saveImage:img withImageName:image];
            }
            responseHandler(nil);
        });
    } else {
        responseHandler(nil);
    }
}

-(void)saveImage:(NSData*)imageData withImageName:(NSString*)imageName {
    
    NSString *imageDirectoryPath = [self getImageDirectoryPath];
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    if(![self imageDirectoryExists]){
        if(![fileManager createDirectoryAtPath:imageDirectoryPath withIntermediateDirectories:YES attributes:nil error:NULL]){
            NSLog(@"Error: Create folder failed %@", imageDirectoryPath);
        }
    }
    
    NSString *imagePath = [imageDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
    NSLog(@"pre writing to file");

    if (![imageData writeToFile:imagePath atomically:NO]) {
        NSLog(@"Failed to cache image data to disk");
    } else {
        NSLog(@"the cachedImagedPath is %@", imagePath);
    }
}

-(UIImage*)getUIImage:imageName{
    
    NSString *imagePath = [self getImageDirectoryPath];
    imagePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
