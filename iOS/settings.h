//
//  settings.h
//  SquareWordz3
//
//  Created by Paul Freshney on 03/02/2010.
//  Copyright freshney.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface settings : NSObject {
	
	NSInteger sGameType;
	
	NSInteger sNumberOfQuestions;
    
    NSString *answerData;
}

@property NSInteger sGameType, sNumberOfQuestions;

@property (retain) NSString *answerData;

@end
