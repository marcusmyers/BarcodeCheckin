//
//  ThirdViewController.h
//  BarcodeCheckin
//
//  Created by Mark Myers on 4/4/12.
//  Copyright (c) 2012 Napoleon Area City Schools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zbar.h"

@interface ThirdViewController : UIViewController <ZBarReaderDelegate>
{
	
    UITextView *resultText;
}


@property (nonatomic, retain) IBOutlet UITextView *resultText;
- (IBAction) scanButtonTapped;


@end
