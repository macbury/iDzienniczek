//
//  iDzienniczekAppDelegate.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-01.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iDzienniczekAppDelegate.h"
#import "Rok.h"
#import "Migration.h"
#define shema_version 1
@implementation iDzienniczekAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize userDataBasePath, backUpServerAddress;
@synthesize selected_rok;
@synthesize config,gradeSystem;
@synthesize dzisiaj;

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alertView == errorView){
		exit(0);
	}else{
		if (buttonIndex == 1){
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://macbury.jogger.pl/files/idzienniczek.html"]];
			[config setInteger:0 forKey:@"firstStart"];
		}else{
			[config setInteger:0 forKey:@"firstStart"];
		}
		[alertView release];
	}

}

- (void) showError:(NSString*)msg {
	errorView = [[UIAlertView alloc] initWithTitle:@"Błąd"
										  message:msg 
										 delegate:self 
								cancelButtonTitle:@"Anuluj" 
								otherButtonTitles:nil];
	[errorView show];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	self.backUpServerAddress = @"http://backup.i.pdg.pl/";
	[self loadDatabase];
	
	Migration * migrate = [[Migration alloc] initWithShemaVersion:shema_version];
	[migrate migrate];
	[migrate release];
	
	gradeSystem = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GradeSystem" ofType:@"plist"]];
	
	[self prepareDefaults];

	NSInteger temp = [config integerForKey:@"selected"];
	if (temp != -1){
		self.selected_rok = [[Rok findAll:temp] objectAtIndex:0];
		tabBarController.selectedIndex = [config integerForKey:@"selectedTab"];
	}else{
		tabBarController.selectedIndex = 3;
	}
	
	if ([config integerForKey:@"firstStart"] == 1){
		UIAlertView * info = [[UIAlertView alloc] initWithTitle:@"Dotacja"
														message:@"Puki co rozwijam aplikację za darmo jednak chciałbym ją umieścić w AppStore. Jednyną przeszkodą jaka mi stoi na drodze to brak 99$ na wykupienie konta developera." 
													   delegate:self 
											  cancelButtonTitle:@"Anuluj" 
											  otherButtonTitles:nil];
		[info addButtonWithTitle:@"Wspomóż"];
		[info show];
	}
	
	[self dzisiejszyDzienTygodnia];
	[window addSubview:[tabBarController view]];
	[window makeKeyAndVisible];
	[self refreshBadge];
}

- (NSInteger) ateistycznyFormatDniaTygodnia:(NSInteger)dzien {
	return dzien - 1;
}

- (NSString *) ocenaSlownie:(NSInteger)ocena {
	NSArray * oceny = [gradeSystem objectForKey:@"Grades"];
	return [oceny objectAtIndex:ocena-1];
}

- (NSString *) zaCoSlownie:(NSInteger)zaco {
	NSArray * za = [gradeSystem objectForKey:@"ForWhat"];
	return [za objectAtIndex:zaco];
}
	
- (void) prepareDefaults {
	config = [NSUserDefaults standardUserDefaults];
	
	NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
	
	[appDefaults setObject:[[NSNumber alloc] initWithInt:1] forKey:@"selectedTab"];
	[appDefaults setObject:[[NSNumber alloc] initWithInt:-1] forKey:@"selected"];
	[appDefaults setObject:[[NSNumber alloc] initWithInt:5] forKey:@"dni"];
	[appDefaults setObject:[[NSNumber alloc] initWithInt:5] forKey:@"przerwa"];
	[appDefaults setObject:[NSNumber numberWithInt:1] forKey:@"firstStart"];
	[appDefaults setObject:[NSNumber numberWithInt:45] forKey:@"czasTrwaniaLekcji"];
    [config registerDefaults:appDefaults];
}

- (NSInteger) dzisiejszyDzienTygodnia{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
	
	self.dzisiaj = [self ateistycznyFormatDniaTygodnia: [comps weekday]];
	return self.dzisiaj;
}

- (void) refreshBadge {
	UIViewController * praceController = [tabBarController.viewControllers objectAtIndex:2];
	
	int count = [Prace countZrobione];
	if (count == 0){
		//[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
		praceController.tabBarItem.badgeValue = nil;
	}else{
		[UIApplication sharedApplication].applicationIconBadgeNumber = count;
		praceController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
	}
}

- (void) flipViews:(UIViewController *)toView {
	[UIView beginAnimations:@"flipViews" context:nil];
	[UIView setAnimationDuration:0.50];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
	
	[[tabBarController view] removeFromSuperview];
	[window addSubview:toView.view];

	[UIView commitAnimations];
}

- (void) loadDatabase {

	BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"dziennik_db.sql"];
    self.userDataBasePath = writableDBPath;
	
	success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dziennik_db.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        [self showError: [NSString stringWithFormat:@"Z jakiegoś nieznanego powodu(fazy księżyca, zakłócena równowaga wszechświata) nie dano mi mocy skopiowania pliku bazy danych. System powiada: %@", [error localizedDescription]]];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {

	//[config writeToFile:self.userConfigPath atomically:YES];
}

- (void)tabBarController:(UITabBarController *)tbc didSelectViewController:(UIViewController *)viewController {
	[viewController setEditing:NO animated:NO];
	[config setObject:[[NSNumber alloc] initWithInt:tbc.selectedIndex] forKey:@"selectedTab"];
	[tbc.navigationController popToRootViewControllerAnimated: YES];
}

- (void)dealloc {
	[gradeSystem release];
	[tabBarController release];
	[config release];
	[window release];
	[super dealloc];
}

@end
