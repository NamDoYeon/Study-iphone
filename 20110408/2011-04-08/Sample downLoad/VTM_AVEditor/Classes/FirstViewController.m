//
//  FirstViewController.m
//  VTM_AVEditor
//
//  Created by Chris Adamson on 10/16/10.
//  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreMedia/CoreMedia.h>

#define SOURCE_MOVIE_NAME @"Pando Park 12-13-08"
#define SOURCE_MOVIE_TYPE @"m4v"

@implementation FirstViewController


@synthesize sourceAsset;
@synthesize playerView;
@synthesize inLabel;
@synthesize outLabel;
@synthesize previewView;
@synthesize timeSlider;
@synthesize targetController;


-(id) initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		NSString *sourceMoviePath = [[NSBundle mainBundle] pathForResource:SOURCE_MOVIE_NAME
																	ofType:SOURCE_MOVIE_TYPE];
		NSLog (@"found source movie at %@", sourceMoviePath);
		NSURL *sourceMovieURL = [NSURL fileURLWithPath:sourceMoviePath];
//		NSURL *sourceMovieURL = [NSURL URLWithString:@"http://www.subfurther.com/video/running-start-iphone.m4v"];

		sourceAsset	= [[AVURLAsset URLAssetWithURL:sourceMovieURL
										   options:nil] 
					   retain];
	}
	return self;
	
}


- (void)dealloc {
	[sourceAsset release];
	[playerView release];
	[inLabel release];
	[outLabel release];
	[previewView release];
	[timeSlider release];
	[targetController release];
    [super dealloc];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	float durationSeconds = sourceAsset.duration.value / sourceAsset.duration.timescale;
	[timeSlider setMaximumValue: durationSeconds];
	NSLog (@"duration is %f sec", durationSeconds);
	timeSlider.value = 0;
	inSeconds = -1.0;
	outSeconds = -1.0;

	AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:sourceAsset];
	player = [[AVPlayer playerWithPlayerItem:playerItem] retain];
	
	AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
	[playerView.layer addSublayer:playerLayer];
	playerLayer.frame = playerView.layer.bounds;
	playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(NSString*) labelStringForTime: (Float64) time {
	int hours = time / 360;
	int minutes = ((int) time / 60) % 60;
	int seconds = (int) time % 60;
	return [NSString stringWithFormat:@"%0d:%02d:%02d",
			hours, minutes, seconds];
}

-(IBAction) inButtonTapped: (id) sender {
	inSeconds = timeSlider.value;
	inLabel.text = [self labelStringForTime: inSeconds];
}
-(IBAction) outButtonTapped: (id) sender {
	outSeconds = timeSlider.value;
	outLabel.text = [self labelStringForTime: outSeconds];
}
-(IBAction) cutButtonTapped: (id) sender {
	if ((inSeconds > 0) && (outSeconds > 0)) {
		if (inSeconds > outSeconds) {
			UIAlertView *youFailEditingForeverAlert =
				[[UIAlertView alloc] initWithTitle:@"Invalid edit"
										   message:@"In point is after Out point"
										  delegate:nil
								 cancelButtonTitle:@"Oops"
								 otherButtonTitles:nil];
			[youFailEditingForeverAlert show];
			[youFailEditingForeverAlert release];
			return;
		}
		
		CMTime inTime = CMTimeMakeWithSeconds(inSeconds, 600);
		CMTime outTime = CMTimeMakeWithSeconds(outSeconds, 600);
		CMTime duration = CMTimeSubtract(outTime, inTime);
		CMTimeRange editRange = CMTimeRangeMake(inTime, duration);
		NSError *editError = nil;

		[targetController.composition insertTimeRange:editRange
											  ofAsset:sourceAsset
											   atTime:targetController.composition.duration 
												error:&editError];
		if (!editError) {
			// kludge: force the other VC to load its view, so we can touch its goodies
			targetController.view;
			targetController.timeSlider.maximumValue = 
				CMTimeGetSeconds (targetController.composition.duration);
		} else {
			NSLog (@"edit error: %@", editError);
		}

		// reset edit points
		inSeconds = -1;
		outSeconds = -1;
		inLabel.text = @"-:--:--";
		outLabel.text = @"-:--:--";
	}
}
-(IBAction) timeSliderValueChanged: (id) sender {
	CMTime newTime = CMTimeMakeWithSeconds(timeSlider.value, 600);
	[player seekToTime: newTime];
	// NSLog (@"seeking to %f", CMTimeGetSeconds(newTime));
}



@end
