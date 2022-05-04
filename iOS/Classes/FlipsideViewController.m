//
//  FlipsideViewController.m
//  PTQuiz
//
//  Created by Paul Freshney on 19/04/2010.
//  Copyright freshney.org 2010. All rights reserved.
//
//
//  CREATE TABLE ptQuiz ([ptID] INT PRIMARY KEY, [ptType] INT, [ptQuestion] VARCHAR, [ptImage] VARCHAR, [ptAnswer1] VARCHAR, [ptAnswer2] VARCHAR, [ptAnswer3] VARCHAR, [ptAnswer4] VARCHAR, [ptAnswer5] VARCHAR);


#import "FlipsideViewController.h"
#import <sqlite3.h>
#import "settings.h"
#import "devicedetect.h"

const int lastQuestionID = 792;
const int easyQuestions  = 652;
const int hardQuestions  = 141;

extern settings *ptqSettings;
extern DeviceDetect *fdeviceDetect;

NSInteger hintCount, currentQuestion, currentAnswer, oldAnswer, correctAnswer, maxQuestions, totalCorrect, maxButton;

BOOL allowHint;

@implementation FlipsideViewController

@synthesize delegate;


- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth  = [UIScreen mainScreen].bounds.size.width;
    
    //UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        NSLog(@"uLFNO w:%f h:%f", screenWidth, screenHeight);
        
        [self setButtons:[fdeviceDetect getDevice:screenWidth fromHeight:screenHeight]];
    }
	
    ptqSettings.answerData = @"";
    
	allowHint       = YES;

	currentQuestion = 0;
	
	totalCorrect    = 0;
	currentAnswer   = 0;
	oldAnswer       = 0;
	
	switch (ptqSettings.sNumberOfQuestions)
	{
		case 1:
			maxQuestions = 10;
			hintCount = 1;

			break;
		case 2:
			maxQuestions = 20;
			hintCount = 1;

			break;
		case 3:
			maxQuestions = 30;
			hintCount = 2;

			break;
		case 4:
			maxQuestions = 40;
			hintCount = 2;

			break;	
		case 5:
			maxQuestions = 50;
			hintCount = 3;

			break;
		case 6:
			maxQuestions = 75;
			hintCount = 4;

			break;
		case 7:
			maxQuestions = 100;
			hintCount = 5;

			break;
	}

	myButtons = [[NSArray alloc] initWithObjects:bAnswer1, bAnswer2, bAnswer3, bAnswer4, bAnswer5, nil];

	[self getNextQuestion];
}
                
-(void) setButtons:(NSInteger)myDevice {
    
    switch (myDevice)
    {
        case deviceIPhone4:
        {
            // do nothing
            
            break;
        }
            
        case deviceIPhone5:
        {
            
            break;
        }
            
        case deviceIPhone6:
        {
            
            break;
        }
            
        case deviceIPhone6plus:
        {
            
            
            break;
        }
    }
}


// ============================================================================================
// ============================================================================================

- (IBAction)done {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really Quit?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:NULL otherButtonTitles:@"Yes", NULL];
	
	[actionSheet showInView: self.view];
	
	[actionSheet release];		
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0)
	{
		[self.delegate flipsideViewControllerDidFinish:self];
	}
}

- (IBAction) getNextQuestion {
	
	if (hintCount != 0)
	{
		getHint.enabled = YES;
	}
	else
	{
		getHint.enabled = NO;
	}

	
	if (maxQuestions == 0)
	{
        [self showAnswers];
	}
	else
	{
		if (currentAnswer != 0)
		{
			if (currentAnswer == correctAnswer)
			{
				totalCorrect++;
                
                NSLog(@"correct so far: %ld", (long)totalCorrect);
			}
            else
            {
                ptqSettings.answerData = [ptqSettings.answerData stringByAppendingString:[NSString stringWithFormat:@" [ Question %ld ]\n\n", (long)currentQuestion]];
                
                ptqSettings.answerData = [ptqSettings.answerData stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", labelQuestion.text]];
               
                UIButton *thisButtonY = (UIButton *)[myButtons objectAtIndex: currentAnswer-1];
                UIButton *thisButtonC = (UIButton *)[myButtons objectAtIndex: correctAnswer-1];
                
                ptqSettings.answerData = [ptqSettings.answerData stringByAppendingString:[NSString stringWithFormat:@"Your answer: %@\n", [[thisButtonY titleLabel] text]]];
                
                ptqSettings.answerData = [ptqSettings.answerData stringByAppendingString:[NSString stringWithFormat:@"Correct answer: %@\n\n\n", [[thisButtonC titleLabel] text]]];
            }
		}
	
		if (currentQuestion == maxQuestions)
		{
			for (int t=0; t < [myButtons count]; t++)
			{
				UIButton *thisButton = (UIButton *)[myButtons objectAtIndex: t];

                thisButton.hidden = YES;
			}
			
            getHint.enabled = NO;
            
            [nextQuestion setTitle:@"Answers"];
            
			int whichTrophy = 0;
		
			switch (maxQuestions)
			{
				case 10:
				{
					switch (totalCorrect)
					{
						case 8:
							whichTrophy = 1;
							break;
						case 9:
						case 10:
							whichTrophy = 2;
							break;
					}
					break;
				}
				case 25:
				{
					if (totalCorrect > 20)
					{
						if (totalCorrect > 22)
						{
							whichTrophy = 2;
						}
						else
						{
							whichTrophy = 1;
						}
					}
					break;
				}
				case 50:
				{
					if (totalCorrect > 49)
					{
						if (totalCorrect > 54)
						{
							whichTrophy = 2;
						}
						else
						{
							whichTrophy = 1;
						}
					}
					break;
				}
				case 75:
				{
					if (totalCorrect > 64)
					{
						if (totalCorrect > 70)
						{
							whichTrophy = 2;
						}
						else
						{
							whichTrophy = 1;
						}
					}
					break;
				}
				case 100:
				{
					if (totalCorrect > 79)
					{
						if (totalCorrect > 94)
						{
							whichTrophy = 2;
						}
						else
						{
							whichTrophy = 1;
						}
					}
					break;
				}					
			}
			
			switch (whichTrophy)
			{
				case 0:
					labelQuestion.text = [NSString stringWithFormat:@"You scored %ld out of %ld.", (long)totalCorrect, (long)maxQuestions];

					break;
				case 1:
					[trophy setImage:[UIImage imageNamed:@"trophy_silver.png"]];
					labelQuestion.text = [NSString stringWithFormat:@"Well done!\n\nYou scored %ld out of %ld.", (long)totalCorrect, (long)maxQuestions];

					break;
				case 2:
					[trophy setImage:[UIImage imageNamed:@"trophy_gold.png"]];
					labelQuestion.text = [NSString stringWithFormat:@"Congratulations!\n\nYou scored %ld out of %ld.", (long)totalCorrect, (long)maxQuestions];
					
					break;
			}
			
			trophy.hidden = NO;

			maxQuestions = 0;
		}
		else
		{
		
			// ======================================================================================================
			// ======================================================================================================

			if (db == NULL)
			{
				int dbrc;
		
				const char *path = [[[NSBundle mainBundle] pathForResource:@"ptQuiz" ofType:@"db"] UTF8String];
		
				dbrc = sqlite3_open(path, &db);

			}

			// ======================================================================================================
			// ======================================================================================================	
	
			int dbrc;
			sqlite3_stmt *dbps;

			NSString *queryNS = @"";
	
			int questionID = arc4random() % lastQuestionID;
			
			queryNS = [NSString stringWithFormat:@"SELECT ptID, ptType, ptQuestion, ptImage, ptAnswer1, ptAnswer2, ptAnswer3, ptAnswer4, ptAnswer5 FROM ptQuiz WHERE ptID=%d;", questionID];

			const char *query = [queryNS UTF8String];
			dbrc = sqlite3_prepare_v2(db, query, -1, &dbps, NULL );	
	
			dbrc = sqlite3_step(dbps);
			
			// ======================================================================================================
			// ======================================================================================================	

			
			if (ptqSettings.sGameType == 1) // easy
			{
				NSUInteger qType = sqlite3_column_int(dbps, 1);
				
				while (qType == 2)
				{
					questionID = arc4random() % lastQuestionID;
					
					queryNS = [NSString stringWithFormat:@"SELECT ptID, ptType, ptQuestion, ptImage, ptAnswer1, ptAnswer2, ptAnswer3, ptAnswer4, ptAnswer5 FROM ptQuiz WHERE ptID=%d;", questionID];
					
					const char *query = [queryNS UTF8String];
					dbrc = sqlite3_prepare_v2(db, query, -1, &dbps, NULL );	
					
					dbrc = sqlite3_step(dbps);
					
					qType = sqlite3_column_int(dbps, 1);
				}				
			}
			else							// hard
			{
			}
			
			// ======================================================================================================
			// ======================================================================================================				
	
			if (dbrc == SQLITE_ROW)
			{
			
				[bAnswer1 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				[bAnswer2 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				[bAnswer3 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				[bAnswer4 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				[bAnswer5 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
			
				NSString *question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 2)];
				NSString *answer1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 4)];
				NSString *answer2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 5)];
				NSString *answer3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 6)];
				NSString *answer4 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 7)];
				NSString *answer5 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 8)];
		
				int answerSlot[] = {-1, -1, -1, -1, -1};
		
				maxButton = [myButtons count];
		
				bAnswer1.hidden = NO;
				bAnswer2.hidden = NO;
				bAnswer3.hidden = NO;
				
				// ======================================================================================================
				// ======================================================================================================
				
				UIButton *button4 = (UIButton *)[myButtons objectAtIndex: 3];
				UIButton *button5 = (UIButton *)[myButtons objectAtIndex: 4];		
				
				if ([answer5 isEqualToString:@""])
				{
					answerSlot[4] = 1;
					
					maxButton = 4;
					
					button5.hidden = YES;
				}
				else
				{				
					button5.hidden = NO;
				}				
				
				if ([answer4 isEqualToString:@""])
				{
					answerSlot[3] = 1;
						
					maxButton = 3;
								
					button4.hidden = YES;
				
				}
				else
				{				
					button4.hidden = NO;
				}
				
				// ======================================================================================================
				// ======================================================================================================
				
				for (int t = 0; t<maxButton; t++)
				{
					int answerText = arc4random() % maxButton;

					while (answerSlot[answerText] != -1) 
					{
						answerText = arc4random() % maxButton;
					}

					UIButton *thisButton = (UIButton *)[myButtons objectAtIndex: t];
				
					switch (answerText)
					{
						case 0:
							[thisButton setTitle:answer1 forState:(UIControlState)UIControlStateNormal];
					
							correctAnswer = t + 1;
                            
                            NSLog(@"correct: %ld", (long)correctAnswer);
					
							break;
					
						case 1:
							[thisButton setTitle:answer2 forState:(UIControlState)UIControlStateNormal];
							break;
					
						case 2:
							[thisButton setTitle:answer3 forState:(UIControlState)UIControlStateNormal];
							break;
					
						case 3:
							[thisButton setTitle:answer4 forState:(UIControlState)UIControlStateNormal];
							break;
					
						case 4:
							[thisButton setTitle:answer5 forState:(UIControlState)UIControlStateNormal];
							break;
					}
				
					answerSlot[answerText] = 1;			
				}
		
				labelQuestion.text = question;
		
				currentQuestion++;

				navBarLabel.text = [NSString stringWithFormat:@"%ld of %ld", (long)currentQuestion, (long)maxQuestions];
			
				nextQuestion.enabled = NO;
			}
		}
	}
}

- (void)setAnswer {
	
	if (oldAnswer != 0)
	{
		switch (oldAnswer)
		{
			case 1:
				[bAnswer1 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				break;
			case 2:
				[bAnswer2 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				break;
			case 3:
				[bAnswer3 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				break;
			case 4:
				[bAnswer4 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				break;
			case 5:
				[bAnswer5 setBackgroundImage:[UIImage imageNamed:@"buttonoff.png"] forState:UIControlStateNormal];
				break;
		}
	}
	
	switch (currentAnswer)
	{
		case 1:
			[bAnswer1 setBackgroundImage:[UIImage imageNamed:@"buttonon1.png"] forState:UIControlStateNormal];
			break;
		case 2:
			[bAnswer2 setBackgroundImage:[UIImage imageNamed:@"buttonon2.png"] forState:UIControlStateNormal];
			break;
		case 3:
			[bAnswer3 setBackgroundImage:[UIImage imageNamed:@"buttonon3.png"] forState:UIControlStateNormal];
			break;
		case 4:
			[bAnswer4 setBackgroundImage:[UIImage imageNamed:@"buttonon4.png"] forState:UIControlStateNormal];
			break;
		case 5:
			[bAnswer5 setBackgroundImage:[UIImage imageNamed:@"buttonon5.png"] forState:UIControlStateNormal];
			break;
	}
	
	oldAnswer = currentAnswer;
	
	nextQuestion.enabled = YES;
}

- (IBAction) hint {
	
	hintCount--;
	
	getHint.enabled = NO;
	
	int hx = 2;
	
	while (hx != 0)
	{
		int t = arc4random() % maxButton;
		
		UIButton *thisButton = (UIButton *)[myButtons objectAtIndex: t];

		if ((thisButton.hidden == NO) && (currentAnswer != (t+1)))
		{
			thisButton.hidden = YES;
		
			hx--;
		}
	}
}

- (IBAction) answerClick:(id)sender {

	currentAnswer = [sender tag];
	
	[self setAnswer];
}

// ============================================================================================
// ============================================================================================

- (IBAction) showAnswers {
	
	AnswersViewController *controller = [[AnswersViewController alloc] initWithNibName:@"AnswersView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:controller animated:YES completion:nil];
	
	[controller release];
}

- (void)answersViewControllerDidFinish:(AnswersViewController *)controller {
    
    [[controller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

// ============================================================================================
// ============================================================================================


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    
    [super dealloc];
    
	[myButtons release];
}


@end