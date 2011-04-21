//
//  ADFoundationDemo_4ViewController.m
//  ADFoundationDemo_4
//
//  Created by ziyi on 11-4-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ADFoundationDemo_4ViewController.h"
#import "SCListener.h"

@implementation ADFoundationDemo_4ViewController
@synthesize progress_avgPower,progress_peakPower,listener;


-(IBAction) Start:(id)sender{
	NSLog(@"Start");
	// 开始侦测
	[[SCListener sharedListener] listen];
	// 取得平均值
	[[SCListener sharedListener] averagePower];
	// 取得最大音量
	[[SCListener sharedListener] peakPower];
	
	SCListener *listener_1 = [SCListener sharedListener];
	self.listener = listener_1;
	[listener_1 release];
}
-(IBAction) Pause:(id)sender{
	NSLog(@"Pause");
	[listener pause]; // 停止
	[listener listen];
}

-(IBAction) Stop:(id)sender{
	NSLog(@"Stop");
	[listener stop];
	[listener listen];
}

-(IBAction) GetPower:(id)sender{
	NSLog(@"GetPower");
	AudioQueueLevelMeterState *levels = [listener levels];
	Float32 peak = levels[0].mPeakPower;
	Float32 avg = levels[0].mAveragePower;
	
	if (![listener isListening]) {
		return;
	}
	progress_avgPower.progress = avg;
	NSLog(@"---------%f++++++++%f-------",peak,avg);
	progress_peakPower.progress = peak;
	if (peak>=0.02) {
		[self haole];
	}
}	
	
-(void)haole{
	NSLog(@"^^^^^^^^^^^");
	NSLog(@"__________");
	NSLog(@"^^^^^^^^^^^");
}
- (void)dealloc {
    [super dealloc];
}

@end
