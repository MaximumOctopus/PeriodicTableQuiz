//
//  quiz.m
//  PTQuiz
//
//  Created by Paul Freshney on 18/09/2011.
//  Copyright 2011 freshney.org. All rights reserved.
//

#import "quiz.h"
#import <sqlite3.h>

const int lastQuestionID = 792;
const int easyQuestions  = 693;
const int hardQuestions  = 145;

int gameType = 1;

int hintCount, currentQuestion, currentAnswer, oldAnswer, correctAnswer, maxQuestions, totalCorrect, maxButton;

BOOL allowHint;

@implementation quiz

// ======================================================================================================================
// ======================================================================================================================
// == Window Delegate Code ==============================================================================================
// ======================================================================================================================
// ======================================================================================================================

- (BOOL)windowShouldClose:(id)sender {
	
	[[NSApplication sharedApplication] terminate:NULL];
	
	return TRUE;
}

// ======================================================================================================================
// ======================================================================================================================
// == Application Delegate Code =========================================================================================
// ======================================================================================================================
// ======================================================================================================================

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	myButtons = [[NSArray alloc] initWithObjects:bAnswer1, bAnswer2, bAnswer3, bAnswer4, bAnswer5, nil];
	
	[tabView selectTabViewItemAtIndex:0];
}

// ==================================================================================================
// == Global ========================================================================================
// ==================================================================================================

// ==================================================================================================
// == Game Selection Screen =========================================================================
// ==================================================================================================

- (IBAction)newQuiz:(id)sender {
	
	[tabView selectTabViewItemAtIndex:1];
	
	[self setupGame:[sender tag]];
}

- (IBAction)changeDifficulty:(id)sender {
	
	switch ([sender tag])
	{
		case 1:
			[difficultyHard setState:NSOffState];
			break;
		case 2:
			[difficultyEasy setState:NSOffState];
			break;
	}
	
	gameType = [sender tag];
}

// ==================================================================================================
// == In-Game Screen ================================================================================
// ==================================================================================================

- (void)setupGame:(int)xGameLength {

	allowHint = YES;
	
	currentQuestion = 0;
	
	totalCorrect = 0;
	currentAnswer = 0;
	oldAnswer = 0;
	
	switch (xGameLength)
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
			maxQuestions = 60;
			hintCount = 3;
			break;
		case 7:
			maxQuestions = 75;
			hintCount = 4;
			break;
		case 8:
			maxQuestions = 100;
			hintCount = 5;
			break;
	}
	
	[bAnswer1 setState:NSOffState];
	[bAnswer2 setState:NSOffState];
	[bAnswer3 setState:NSOffState];
	[bAnswer4 setState:NSOffState];
	[bAnswer5 setState:NSOffState];

	[self getNextQuestion:NULL];
}

// ==================================================================================================================
// ==================================================================================================================
// == In Game Screen ================================================================================================
// ==================================================================================================================
// ==================================================================================================================

- (IBAction) getNextQuestion:(id)sender {
	
	if (hintCount != 0)
	{
		[getHint setEnabled:YES];
	}
	else
	{
		[getHint setEnabled:NO];
	}

	if (maxQuestions == 0)
	{
	}
	else
	{
		
		if (currentAnswer != 0)
		{
			if (currentAnswer == correctAnswer)
			{
				totalCorrect++;
			}
		}
		
		if (currentQuestion == maxQuestions)
		{			
			[self endGame];
		}
		else
		{
			[bAnswer1 setState:NSOffState];
			[bAnswer2 setState:NSOffState];
			[bAnswer3 setState:NSOffState];
			[bAnswer4 setState:NSOffState];
			[bAnswer5 setState:NSOffState];			
			
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
			
			
			if (gameType == 1) // easy
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
			else				// hard
			{
			}
			
			// ======================================================================================================
			// ======================================================================================================				
			
			if (dbrc == SQLITE_ROW)
			{
				NSString *question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 2)];
				NSString *answer1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 4)];
				NSString *answer2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 5)];
				NSString *answer3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 6)];
				NSString *answer4 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 7)];
				NSString *answer5 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 8)];
				
				NSUInteger imageID = sqlite3_column_int(dbps, 3);

				NSLog(@"image: %d", imageID);
				
				if (imageID != 0)
				{
					[questionImage setHidden:NO];
					
					[questionImage setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%d.jpg", imageID]]];
				}
				else
				{
					[questionImage setHidden:YES];
				}

				int answerSlot[] = {-1, -1, -1, -1, -1};
				
				maxButton = [myButtons count];
				
				[bAnswer1 setHidden:NO];
				[bAnswer2 setHidden:NO];
				[bAnswer3 setHidden:NO];
				
				oldAnswer = 0;
				
				// ======================================================================================================
				// ======================================================================================================
				
				NSButton *button4 = (NSButton *)[myButtons objectAtIndex: 3];
				NSButton *button5 = (NSButton *)[myButtons objectAtIndex: 4];		
				
				if ([answer5 isEqualToString:@""])
				{
					answerSlot[4] = 1;
					
					maxButton = 4;
					
					[button5 setHidden:YES];
				}
				else
				{				
					[button5 setHidden:NO];
				}				
				
				if ([answer4 isEqualToString:@""])
				{
					answerSlot[3] = 1;
					
					maxButton = 3;
					
					[button4 setHidden:YES];
					
				}
				else
				{				
					[button4 setHidden:NO];
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
					
					NSButton *thisButton = (NSButton *)[myButtons objectAtIndex: t];
					
					switch (answerText)
					{
						case 0:
							[thisButton setTitle:answer1];

							correctAnswer = t + 1;

							break;
							
						case 1:
							[thisButton setTitle:answer2];
							break;
							
						case 2:
							[thisButton setTitle:answer3];
							break;
							
						case 3:
							[thisButton setTitle:answer4];
							break;
							
						case 4:
							[thisButton setTitle:answer5];
							break;
					}
					
					answerSlot[answerText] = 1;			
				}
				
				[labelQuestion setStringValue:question];
				
				currentQuestion++;
				
				[navBarLabel setStringValue:[NSString stringWithFormat:@"%d of %d", currentQuestion, maxQuestions]];
				
				[nextQuestion setEnabled:NO];
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
				[bAnswer1 setState:NSOffState];
				 break;
			case 2:
				[bAnswer2 setState:NSOffState];
				break;
			case 3:
				[bAnswer3 setState:NSOffState];
				break;
			case 4:
				[bAnswer4 setState:NSOffState];
				break;
			case 5:
				[bAnswer5 setState:NSOffState];
				break;
		}
	}
	
	oldAnswer = currentAnswer;
	
	[nextQuestion setEnabled:YES];
}

- (IBAction) hint:(id)sender {
	
	hintCount--;
	
	[getHint setEnabled:NO];
	
	int hx = 2;
	
	while (hx != 0)
	{
		int t = arc4random() % maxButton;
		
		NSButton *thisButton = (NSButton *)[myButtons objectAtIndex: t];
		
		if (([thisButton isHidden] == NO) && (currentAnswer != (t+1)))
		{
			[thisButton setHidden:YES];
			
			hx--;
		}
	}
}

- (IBAction) answerClick:(id)sender {
	
	currentAnswer = [sender tag];
	
	[self setAnswer];
}

// ==================================================================================================================
// ==================================================================================================================
// == Game Over Screen ==============================================================================================
// ==================================================================================================================
// ==================================================================================================================

- (void) endGame {
	
	[tabView selectTabViewItemAtIndex:2];
	
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
		case 20:
		{
			if (totalCorrect>15)
			{
				if (totalCorrect>17)
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
		case 30:
		{
			if (totalCorrect>23)
			{
				if (totalCorrect>26)
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
		case 40:
		{
			if (totalCorrect>34)
			{
				if (totalCorrect>37)
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
			if (totalCorrect>44)
			{
				if (totalCorrect>47)
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
		case 60:
		{
			if (totalCorrect>52)
			{
				if (totalCorrect>56)
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
			if (totalCorrect>64)
			{
				if (totalCorrect>70)
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
			if (totalCorrect>79)
			{
				if (totalCorrect>94)
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
			[questionImage setImage:[NSImage imageNamed:@"trophy_bronze.png"]];
			[finishText setStringValue:[NSString stringWithFormat:@"You scored %d out of %d.", totalCorrect, maxQuestions]];
			break;
		case 1:
			[questionImage setImage:[NSImage imageNamed:@"trophy_silver.png"]];
			[finishText setStringValue:[NSString stringWithFormat:@"Well done!\n\nYou scored %d out of %d.", totalCorrect, maxQuestions]];
			break;
		case 2:
			[questionImage setImage:[NSImage imageNamed:@"trophy_gold.png"]];
			[finishText setStringValue:[NSString stringWithFormat:@"Congratulations!\n\nYou scored %d out of %d.", totalCorrect, maxQuestions]];
			break;
	}
	
	maxQuestions = 0;	
}

- (IBAction) backToMenuClick:(id)sender {
	
	[tabView selectTabViewItemAtIndex:0];
	
}


@end