    //
//  SecondViewController.m
//  VTM_AVEditor
//
//  Created by Chris Adamson on 10/16/10.
//  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
//

#import "SecondViewController.h"

#define MUSIC_NAME @"Torn Jeans Long"
#define MUSIC_TYPE @"caf"
#define EXPORT_NAME @"exported.mp4"

@implementation SecondViewController

@synthesize composition;
@synthesize previewView;
@synthesize timeSlider;
@synthesize playPauseButton;
@synthesize exportProgressView;


-(id) initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		composition = [[AVMutableComposition alloc] init];
	}
	return self;
	
}

- (void)dealloc {
    [super dealloc];
	[sliderTimer invalidate];
	[sliderTimer release];
	[composition release];
	[previewView release];
	[timeSlider release];
	[playPauseButton release];
	[exportProgressView release];
	
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
*/
- (void)viewDidLoad {
    [super viewDidLoad];
	timeSlider.value = 0;
	AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:composition];
	player = [[AVPlayer playerWithPlayerItem:playerItem] retain];
	isScrubbing = NO;
	wasPlaying = NO;
	addedMusicTrack = NO;
	
	AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
	[previewView.layer addSublayer:playerLayer];
	playerLayer.frame = previewView.layer.bounds;
	playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

	// update the slider while playing
	sliderTimer =[[NSTimer scheduledTimerWithTimeInterval:0.2
												  target:self
												selector:@selector (updateSlider:)
												userInfo:nil
												 repeats:YES]
				  retain];
	
	// add a track for the audio
	musicTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
										  preferredTrackID:kCMPersistentTrackID_Invalid];

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


-(IBAction) exportButtonTapped: (id) sender {
	NSError *exportError = nil;
	// add the audio track
	if (! addedMusicTrack) {
		NSString *musicPath = [[NSBundle mainBundle] pathForResource:MUSIC_NAME
															  ofType:MUSIC_TYPE];
		NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
		musicAsset = [AVURLAsset URLAssetWithURL: musicURL
										 options: nil];
		CMTimeRange musicRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0,600),
												 composition.duration);
		AVAssetTrack *musicAssetTrack = [[musicAsset tracksWithMediaType:AVMediaTypeAudio]
										 objectAtIndex: 0];
		[musicTrack insertTimeRange:musicRange
							ofTrack:musicAssetTrack
							 atTime:CMTimeMakeWithSeconds(0,600)
							  error:&exportError];
		if (exportError) {
			NSLog (@"export error: %@", exportError);
		}
	}

	AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition
																		   presetName:AVAssetExportPresetMediumQuality];
	NSLog (@"can export: %@", exportSession.supportedFileTypes);
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
	NSString *exportPath = [documentsDirectoryPath stringByAppendingPathComponent:EXPORT_NAME];
	[[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
	NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
	exportSession.outputURL = exportURL;
	exportSession.outputFileType = @"com.apple.quicktime-movie";
	[exportSession exportAsynchronouslyWithCompletionHandler:^{
		NSLog (@"i is in your block, exportin. status is %d",
			   exportSession.status);
		switch (exportSession.status) {
			case AVAssetExportSessionStatusFailed:
			case AVAssetExportSessionStatusCompleted: {
				[self performSelectorOnMainThread:@selector (doPostExportUICleanup:)
									   withObject:nil
									waitUntilDone:NO];
				break;
			}
		};
	}];
	exportProgressView.progress = 0.0;
	exportProgressView.hidden = NO;
	exportTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
												   target:self
												 selector:@selector (updateExportProgress:)
												 userInfo:exportSession
												  repeats:YES];
	
	
	
}

-(void) updateExportProgress: (NSTimer*) timer {
	AVAssetExportSession *exportSession = (AVAssetExportSession*) [timer userInfo];
	exportProgressView.progress = exportSession.progress;
}

-(void) doPostExportUICleanup: (NSObject*) userInfo {
	exportProgressView.hidden = YES;
	[exportTimer invalidate];
}

-(IBAction) timeSliderTouchDown: (id) sender {
	isScrubbing = YES;
	if (player.rate > 0.0) {
		[player pause];
		wasPlaying = YES;
	}
}
-(IBAction) timeSliderTouchUp: (id) sender {
	isScrubbing = NO;
	if (wasPlaying) {
		[player	 play];
	}
	wasPlaying = NO;
}

-(IBAction) timeSliderValueChanged: (id) sender {
	CMTime newTime = CMTimeMakeWithSeconds(timeSlider.value, 600);
	[player seekToTime: newTime];

}

-(void) updateSlider: (NSTimer*) timer {
	timeSlider.value = CMTimeGetSeconds(player.currentTime);
}

-(IBAction) playPauseButtonTapped: (id) sender {
	if (playPauseButton.selected) {
		[player pause];
		playPauseButton.selected = NO;
	} else {
		[player play];
		playPauseButton.selected = YES;
	}
}

@end
