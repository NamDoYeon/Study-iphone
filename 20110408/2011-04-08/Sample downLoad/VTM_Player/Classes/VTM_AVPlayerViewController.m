//
//  VTM_PlayerViewController.m
//  VTM_Player
//
//  Created by Chris Adamson on 10/16/10.
//  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
//

#import "VTM_AVPlayerViewController.h"

@implementation VTM_AVPlayerViewController

@synthesize player;
@synthesize playerView;
@synthesize noVideoLabel;

- (void)dealloc {
	[player release];
	[playerView release];
	[noVideoLabel release];
    [super dealloc];
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
*/
- (void)viewDidLoad {
    [super viewDidLoad];
	
// m4a audio file
// 	NSURL *url = [NSURL URLWithString:@"http://www.subfurther.com/audio/jarhand.m4a"];

// shoutcast web radio stream	
	NSURL *url = [NSURL URLWithString:@"http://radio3.cbc.ca/nmcradio/webradioLow.m3u"];

// quicktime movie	
//	NSURL *url = [NSURL URLWithString:@"http://www.subfurther.com/video/running-start-iphone.m4v"];

// http live streaming - apple's test pattern
//	NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];

// http live streaming - apple event september 2010	
//	NSURL *url = [NSURL URLWithString:@"http://qthttp.apple.com.edgesuite.net/1009qpeijrfn2/sl.m3u8"];
	
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url
											options:nil];
	AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
	player = [[AVPlayer playerWithPlayerItem:playerItem] retain];

	// enable/disable UI as appropriate
	NSArray *visualTracks = [asset tracksWithMediaCharacteristic:AVMediaCharacteristicVisual];
	if ((!visualTracks) ||
		([visualTracks count] == 0)) {
		playerView.hidden = YES;
		noVideoLabel.hidden = NO;
	} else {
		playerView.hidden = NO;
		noVideoLabel.hidden = YES;
		AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
		[playerView.layer addSublayer:playerLayer];
		playerLayer.frame = playerView.layer.bounds;
		playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	}

// visual characteristic test seems not to work for http live streams (likely needs to get
// some data to determine if it has video), so comment out the above enable/disable test
// and comment this stuff in
//	AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//	[playerView.layer addSublayer:playerLayer];
//	playerLayer.frame = playerView.layer.bounds;
//	playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

	
	[player play];
	NSLog (@"playing %@", url);
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


@end
