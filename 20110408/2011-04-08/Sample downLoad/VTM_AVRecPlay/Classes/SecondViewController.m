    //
//  SecondViewController.m
//  VTM_AVRecPlay
//
//  Created by Chris Adamson on 10/4/10.
//  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
//

#import "SecondViewController.h"
#import "VTM_RecAndPlayConstants.h"

@implementation SecondViewController

@synthesize playbackView;
@synthesize playButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void)dealloc {
	[player release];
	[playbackView release];
	[playButton release];
	[playbackBoundaryObserver release];
    [super dealloc];
}


-(void) setUpPlayer {
	if (!player) {
		NSURL *movieURL = [NSURL fileURLWithPath:getCaptureMoviePath()];
//		player = [[AVPlayer alloc] initWithURL:movieURL];
//		AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:movieURL];
		AVURLAsset *movieAsset = [[AVURLAsset alloc] initWithURL:movieURL 
													options: [NSDictionary  dictionaryWithObject:@"YES"
																						  forKey:AVURLAssetPreferPreciseDurationAndTimingKey]];
		AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:movieAsset];
		player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
		player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
		AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
		playerLayer.frame = playbackView.layer.bounds;
		playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
		[playbackView.layer addSublayer:playerLayer];
		// notice when playback ends (need a real asset for this to work)
		CMTime endTime = movieAsset.duration;
		NSLog (@"player.currentItem %@, asset %@", player.currentItem, player.currentItem.asset);
		playbackBoundaryObserver =
			[[player addBoundaryTimeObserverForTimes:[NSArray arrayWithObject: [NSValue valueWithCMTime: endTime]]
											  queue: NULL
										 usingBlock:^{
											 NSLog (@"playback ended");							 
										 }] retain];
		[playerItem release];
		[movieAsset release];
	}
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self setUpPlayer];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(IBAction) playStopButtonTapped: (id) sender {
	NSLog (@"playStopButtonTapped:");
	if (playButton.selected) {
		[player pause];
		playButton.selected = YES;
	} else {
		[player play];
		playButton.selected = NO;
	}
}



@end
