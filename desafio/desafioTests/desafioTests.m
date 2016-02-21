//
//  desafioTests.m
//  desafioTests
//
//  Created by Gabriela Nogueira on 2/20/16.
//  Copyright © 2016 Gabriela Nogueira. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CTLWeather.h"

@interface desafioTests : XCTestCase

@property CTLWeather *ctlWeather;
@end

@implementation desafioTests

- (void)setUp {
    [super setUp];
    self.ctlWeather = [[CTLWeather alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConvertFahrenheit {
    
    NSNumber *result = [self.ctlWeather convertToFahrenheit:[NSNumber numberWithFloat:1]];
    NSNumber *expected = [NSNumber numberWithFloat:33.8];
    
    XCTAssertEqualObjects(result, expected);
    
}

- (void)testConvertCelsius {
    
    NSNumber *result = [self.ctlWeather convertToCelsius:[NSNumber numberWithFloat:5]];
    NSNumber *expected = [NSNumber numberWithFloat:-15];
    
    XCTAssertEqualObjects(result, expected);
    
}


@end
