//
//  devicedetect.h
//  ImageProccessing(Kevin)
//
//  (c) Maximum Octopus Limted 2016
//  (c) Paul Alan Freshney 2016
//
//  Created : December 28th 2011
//  Updated : April 22nd 2016
//

#import <Foundation/Foundation.h>


static const NSInteger deviceIPhone4            = 0;
static const NSInteger deviceIPhone5            = 1;
static const NSInteger deviceIPhone6            = 2;
static const NSInteger deviceIPhone6plus        = 3;

static const NSInteger deviceIPadMini           = 10;
static const NSInteger deviceIPadAir            = 11;
static const NSInteger deviceIPadPro            = 12;

static const CGFloat   deviceIPhone4width       = 320;
static const CGFloat   deviceIPhone4height      = 480;
static const CGFloat   deviceIPhone5width       = 320;
static const CGFloat   deviceIPhone5height      = 568;
static const CGFloat   deviceIPhone6width       = 375;
static const CGFloat   deviceIPhone6height      = 667;
static const CGFloat   deviceIPhone6pluswidth   = 414;
static const CGFloat   deviceIPhone6plusheight  = 736;

@interface DeviceDetect : NSObject {
    
    
}

-(NSInteger)getDevice:(CGFloat)deviceWidth fromHeight:(CGFloat)deviceHeight;

@end
