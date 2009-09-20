//
//  SredniaViewController.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-13.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SredniaViewController.h"


@implementation SredniaViewController

@synthesize scroll;

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	self.scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	self.scroll.backgroundColor = [UIColor redColor];
	self.scroll.contentSize = CGSizeMake(1000,320);
	[self.view addSubview:scroll];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
