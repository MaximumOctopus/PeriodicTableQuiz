//
//  FlipsideViewController.h
//  PTQuiz
//
//  Created by Paul Freshney on 19/04/2010.
//  Copyright freshney.org 2010. All rights reserved.
//

#import "AnswersViewController.h"
#import <UIKit/UIKit.h>
#import <sqlite3.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <AnswersViewControllerDelegate, UIActionSheetDelegate> {
	
	id <FlipsideViewControllerDelegate> delegate;
	
	IBOutlet UIBarButtonItem *nextQuestion, *getHint;

	IBOutlet UILabel *navBarLabel, *labelQuestion;

	IBOutlet UIButton *bAnswer1, *bAnswer2, *bAnswer3, *bAnswer4, *bAnswer5;
	
	IBOutlet UIImageView *trophy;
	
	NSArray *myButtons;
	
	sqlite3 *db;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

- (IBAction) done;

- (IBAction) getNextQuestion;

- (IBAction) hint;

- (IBAction) answerClick:(id)sender;

- (void)setAnswer;

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (IBAction) showAnswers;

@end

@protocol FlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;

@end

