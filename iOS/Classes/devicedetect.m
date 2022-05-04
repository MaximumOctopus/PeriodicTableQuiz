//
//  devicedetect.m
//
//  (c) Maximum Octopus Limted 2016
//  (c) Paul Alan Freshney 2016
//
//  Created : December 28th 2011
//  Updated : April 22nd 2016
//

#import <Foundation/Foundation.h>
#import "devicedetect.h"


@implementation DeviceDetect

-(NSInteger)getDevice:(CGFloat)deviceWidth fromHeight:(CGFloat)deviceHeight {
   
    if (deviceHeight < deviceWidth)
    {
        deviceHeight = deviceWidth;
    }
    
    if (deviceHeight > 480 && deviceHeight < 667)
    {
        NSLog(@"device iphone 5/5C/5S/SE");
        
        return deviceIPhone5;
    }
    else if (deviceHeight > 480 && deviceHeight < 736)
    {
        NSLog(@"device iPhone 6/6s");
        
        return deviceIPhone6;
    }
    else if (deviceHeight > 480)
    {
        NSLog(@"device iPhone 6 Plus/6s Plus");
        
        return deviceIPhone6plus;
    }
    else
    {
        NSLog(@"device iPhone 4/4s");
        
        return deviceIPhone4;
    }
}

@end