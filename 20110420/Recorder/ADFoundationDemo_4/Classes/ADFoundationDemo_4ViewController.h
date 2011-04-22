//
//  ADFoundationDemo_4ViewController.h
//  ADFoundationDemo_4
//
//  Created by ziyi on 11-4-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCListener.h"
@interface ADFoundationDemo_4ViewController : UIViewController {
	IBOutlet UIProgressView *progress_avgPower,*progress_peakPower;
	SCListener *listener;
}

@property(nonatomic ,retain) IBOutlet UIProgressView *progress_avgPower;
@property(nonatomic ,retain) IBOutlet UIProgressView *progress_peakPower;
@property(nonatomic ,retain) SCListener *listener;

-(IBAction) Start:(id)sender;
-(IBAction) Pause:(id)sender;
-(IBAction) Stop:(id)sender;
-(IBAction) GetPower:(id)sender;
-(void)haole;
@end

