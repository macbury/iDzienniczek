//
//  BackupService.m
//  iDzienniczek
//
//  Created by MacBury on 08-09-17.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BackupService.h"
#import "iDzienniczekAppDelegate.h"

@implementation BackupService

@synthesize rok;

NSString* md5( NSString *str )
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
	];
} 

- (id)init {
	progressView = [[UIAlertView alloc] initWithTitle:nil
											  message:nil
											  delegate:self 
									 cancelButtonTitle:nil
									otherButtonTitles:nil];
	
	passwordView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter Password", @"")
											  message:@"   "
											 delegate:self 
									cancelButtonTitle:@"OK"
									otherButtonTitles:nil];
	passwordField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 30.0)];
	[passwordField setBackgroundColor:[UIColor whiteColor]];
	passwordField.keyboardType = UIKeyboardTypeDefault;
	passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
	[passwordField setDelegate: self];
	passwordField.secureTextEntry = YES;
	passwordField.borderStyle = UITextBorderStyleBezel;
	[passwordView addSubview:passwordField];
	

	
	infoView = [[UIAlertView alloc] initWithTitle:@"Info" 
										  message:nil 
										 delegate:nil 
								cancelButtonTitle:@"OK" 
								otherButtonTitles:nil];
	
	
	return [super init];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alertView == passwordView){
		[passwordField resignFirstResponder];
		[progressView show];
	}else{
		infoView.message = info;
		[infoView show];
	}
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
	if (alertView == progressView){
		if (mode == mBackup){
			[self startBackupProcess];
		}else{
			[self startRestoreProcess];
		}
		
	}else{
		[passwordField becomeFirstResponder];
	}
}

- (void)startRestoreProcess {
	iDzienniczekAppDelegate * mainDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString* boundary = [NSString stringWithString:@"[----SSAADASDWADASDASDASCZX----]"];
	UIDevice * device = [UIDevice currentDevice];
	
	NSMutableData* postMSG = [[NSMutableData alloc] initWithCapacity:100];
	
	[postMSG appendData:[[NSString stringWithFormat:@"--%@\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\n\n", @"serial"] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:md5(device.uniqueIdentifier)] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding]];
	
	[postMSG appendData:[[NSString stringWithFormat:@"--%@\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\n\n", @"passCode"] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:md5(passwordField.text)] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding]];
	
	[postMSG appendData:[[NSString stringWithFormat:@"--%@--\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
	
	NSMutableURLRequest* post = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://backup.i.pdg.pl/index.php?action=getDBBackup"]];
	[post addValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField: @"Content-Type"];
	[post setValue:@"iDzienniczek BackUp Service" forHTTPHeaderField:@"User-Agent"];
	[post setHTTPMethod: @"POST"];
	[post setHTTPBody:postMSG];
	
	
	NSData * restore = [NSURLConnection sendSynchronousRequest:post returningResponse:nil error:nil];
	
	if ([restore length] == 0){
		info = NSLocalizedString(@"RestoreNotFound", @"");
		restart = NO;
	}else{
		info = NSLocalizedString(@"RestoreFound", @"");
		[self.rok reloadData];
		[restore writeToFile:mainDelegate.userDataBasePath atomically:YES];
	}
	[progressView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)startBackupProcess {
	UIDevice * device = [UIDevice currentDevice];
	iDzienniczekAppDelegate * mainDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString* boundary = [NSString stringWithString:@"[----SSAADASDWADASDASDASCZX----]"];
	
	NSMutableData* postMSG = [[NSMutableData alloc] initWithCapacity:100];
	
	[postMSG appendData:[[NSString stringWithFormat:@"--%@\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\n\n", @"serial"] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:md5(device.uniqueIdentifier)] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding]];
	
	[postMSG appendData:[[NSString stringWithFormat:@"--%@\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\n\n", @"passCode"] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:md5(passwordField.text)] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding]];
	
	[postMSG appendData:[[NSString stringWithFormat:@"--%@\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n", @"database", mainDelegate.userDataBasePath] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\n\n"] dataUsingEncoding:NSASCIIStringEncoding]];
	[postMSG appendData:[NSData dataWithContentsOfFile:mainDelegate.userDataBasePath]];
	[postMSG appendData:[[NSString stringWithString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding]];	
	
	[postMSG appendData:[[NSString stringWithFormat:@"--%@--\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
	
	NSMutableURLRequest* post = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://backup.i.pdg.pl/index.php?action=createBackUp"]];
	[post addValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField: @"Content-Type"];
	[post setValue:@"iDzienniczek BackUp Service" forHTTPHeaderField:@"User-Agent"];
	[post setHTTPMethod: @"POST"];
	[post setHTTPBody:postMSG];
	
	NSData* result = [NSURLConnection sendSynchronousRequest:post returningResponse:nil error:nil];
	
	info = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
	
	[postMSG release];
	
	[progressView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) restoreBackup {
	passwordField.text = @"";
	progressView.message = NSLocalizedString(@"Restoring database backup...",@"");
	mode = mRestore;
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
	[passwordView setTransform:myTransform];
	[passwordView show];
}
		
- (void) createBackup {
	mode = mBackup;
	progressView.message = NSLocalizedString(@"Creating database backup...",@"");
	passwordField.text = @"";
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
	[passwordView setTransform:myTransform];
	[passwordView show];
}

- (void) dealloc {
	[infoView release];
	[progressView release];
	[passwordView release];
	[passwordField release];
	[super dealloc];
}

@end
