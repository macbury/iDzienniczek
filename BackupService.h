//
//  BackupService.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-17.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#define mBackup 0
#define mRestore 1

@interface BackupService : NSObject <UITextFieldDelegate, UIAlertViewDelegate> {
	UIAlertView * progressView;
	UIAlertView * passwordView;
	UIAlertView * infoView;
	NSString * info;
	NSInteger mode;
	UITextField *passwordField;
	bool restart;
	
	UITableView * rok;
}

@property (nonatomic, retain) UITableView * rok;

- (void) createBackup;
- (void) restoreBackup;
- (void) startBackupProcess;
- (void) startRestoreProcess;
@end
