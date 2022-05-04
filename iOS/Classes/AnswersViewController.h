//
//  FlipsideViewController.h
//  SquareWordz3
//
//  Created by Paul Freshney on 05/11/2010.
//  Copyright freshney.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnswersViewControllerDelegate;

@interface AnswersViewController : UIViewController <UIActionSheetDelegate> {
	
	id <AnswersViewControllerDelegate> delegate;

    IBOutlet UITextView *answerList;
}

@property (nonatomic, assign) id <AnswersViewControllerDelegate> delegate;

- (IBAction) done;

@end


@protocol AnswersViewControllerDelegate

- (void) answersViewControllerDidFinish:(AnswersViewController *)controller;

@end
