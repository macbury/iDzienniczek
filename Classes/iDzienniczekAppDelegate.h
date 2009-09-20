//
//  iDzienniczekAppDelegate.h
//  iDzienniczek
//
//  Created by MacBury on 08-08-01.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//


#import <UIKit/UIKit.h>

@class Rok;
@class Prace;
//@class Migration;

@interface iDzienniczekAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController * tabBarController;
	
	Rok * selected_rok;
	NSInteger dzisiaj;
	UIAlertView * errorView;
	
	NSMutableDictionary * gradeSystem;
	NSUserDefaults * config;
	
	NSString * userDataBasePath;
	NSString * backUpServerAddress;
}

- (void) loadDatabase;
- (NSInteger) dzisiejszyDzienTygodnia;
- (void) refreshBadge;
- (void) prepareDefaults;
- (void) flipViews:(UIViewController *)toView;
- (NSString *) ocenaSlownie:(NSInteger)ocena;
- (NSString *) zaCoSlownie:(NSInteger)zaco;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) NSMutableDictionary * gradeSystem;
@property (nonatomic, retain) NSUserDefaults * config;
@property (nonatomic, retain) Rok * selected_rok;

@property (nonatomic, copy) NSString * userDataBasePath;
@property (nonatomic, copy) NSString * backUpServerAddress;
@property (nonatomic, assign) NSInteger dzisiaj;

@property (nonatomic, retain) UITabBarController *tabBarController;



@end

