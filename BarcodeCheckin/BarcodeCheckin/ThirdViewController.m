//
//  ThirdViewController.m
//  BarcodeCheckin
//
//  Created by Mark Myers on 4/4/12.
//  Copyright (c) 2012 Napoleon Area City Schools. All rights reserved.
//

#import "ThirdViewController.h"

@implementation ThirdViewController

@synthesize resultText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) scanButtonTapped
{
	// ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
	
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
	
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
				   config: ZBAR_CFG_ENABLE
					   to: 0];
	
    // present and release the controller
    [self presentModalViewController: reader
							animated: YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
	[info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
	
    // EXAMPLE: do something useful with the barcode data
	NSString *ticketId = symbol.data;
	
	NSString *urlString = [NSString stringWithFormat:@"http://apiprom/ppromin/%@.json", ticketId];
	//	NSLog(@"The URL: %@",urlString);
	NSURL *loadingUrl = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loadingUrl];
	[request setHTTPMethod:@"POST"];
	
	NSError *error = nil;
	NSURLResponse *theResponse = [[NSURLResponse alloc] init];
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&error];
	
	if(error) {
		// handle error
		NSLog(@"Error: %@", error);
	} else {
		NSError *jsonError = nil;
		NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
		//		NSLog(@"The response: %@",jsonDict);
		NSString *name = [jsonDict objectForKey:@"name"];
		NSString *returnStr = [[NSString alloc] init];
		
		if([jsonDict objectForKey:@"excuse"]){
			returnStr = [jsonDict objectForKey:@"excuse"];
			self.view.backgroundColor = [UIColor redColor];
		} else {
			returnStr = [NSString stringWithFormat:@"%@ has checked into post prom with ticket number: %@", name, ticketId];
		}
		resultText.text = returnStr;
	}
	
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

@end
