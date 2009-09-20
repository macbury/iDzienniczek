//
//  OProgramie.h
//  iDzienniczek
//
//  Created by MacBury on 08-09-01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InformacjeViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView * webView;
}
- (IBAction) stronaWWW:(id)sender;
- (IBAction) darowizna:(id)sender;
@end
