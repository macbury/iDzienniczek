//
//  OProgramie.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "InformacjeViewController.h"


@implementation InformacjeViewController

- (id)init {
	if (self = [super initWithNibName:@"Informacje" bundle:nil]) {
		// Initialization code
	}
	return self;
}

- (IBAction) stronaWWW:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://macbury.jogger.pl"]];
}

- (IBAction) darowizna:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://macbury.jogger.pl/files/idzienniczek.html"]];
}


/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	return YES;
}

- (void)viewDidLoad {
	self.title = @"O Programie";
	[webView setDelegate: self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://macbury.jogger.pl/files/reklama.html"]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end
