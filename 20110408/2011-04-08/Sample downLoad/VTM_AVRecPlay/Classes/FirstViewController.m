//
//  FirstViewController.m
//  VTM_AVRecPlay
//
//  Created by Chris Adamson on 10/4/10.
//  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
//

#import "FirstViewController.h"
#import "VTM_RecAndPlayConstants.h"

@interface FirstViewController()
	-(NSError*) setUpCaptureSession;	
@end

@implementation FirstViewController

@synthesize captureView;
@synthesize recordButton;

#pragma mark init/dealloc

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
- (void)dealloc {
	[captureView release];
	[recordButton release];
	[captureMovieURL release];
	[captureMoviePath release];
    [super dealloc];
}

#pragma mark vc lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
*/
- (void)viewDidLoad {
    [super viewDidLoad];
	[self setUpCaptureSession];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark capture stuff
-(NSError*) setUpCaptureSession {
	captureSession = [[AVCaptureSession alloc] init];
	// find, attach devices
	NSError *setUpError = nil;
	AVCaptureDevice *muxedDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeMuxed];
	if (muxedDevice) {
		NSLog (@"got muxedDevice");
		AVCaptureDeviceInput *muxedInput = [AVCaptureDeviceInput deviceInputWithDevice:muxedDevice
																				 error:&setUpError];
		if (muxedInput) {
			[captureSession addInput:muxedInput];
		}
	} else {
		AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
		if (videoDevice) {
			NSLog (@"got videoDevice");
			AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice
																					 error:&setUpError];
			if (videoInput) {
				[captureSession addInput: videoInput];
			}
		}
		AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeAudio];
		if (audioDevice) {
			NSLog (@"got audioDevice");
			AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice
																					 error:&setUpError];
			if (audioInput) {
				[captureSession addInput: audioInput];
			}
		}
	}

	// create a preview layer from the session and add it to UI
	AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
	previewLayer.frame = captureView.layer.bounds;
	previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	[captureView.layer addSublayer:previewLayer];
	
	// create capture file output
	[captureMovieOutput release];
	captureMovieOutput = [[AVCaptureMovieFileOutput alloc] init];
	if (! captureMovieURL) {
		captureMoviePath = [getCaptureMoviePath() retain];
		captureMovieURL = [[NSURL alloc] initFileURLWithPath:captureMoviePath];
	}
	NSLog (@"recording to %@", captureMovieURL);
	[captureSession addOutput:captureMovieOutput];
	
	
	return setUpError;
}
#pragma mark event handlers
-(IBAction) startStopCaptureTapped: (id) sender {
	NSLog (@"startStopCaptureTapped:");
	if (recordButton.selected) {
		[captureSession stopRunning];
		recordButton.selected = NO;
		[captureMovieOutput stopRecording];
	} else {
		
		[captureSession startRunning];
		recordButton.selected = YES;
		if ([[NSFileManager defaultManager] fileExistsAtPath:captureMoviePath]) {
			[[NSFileManager defaultManager] removeItemAtPath:captureMoviePath error:nil];
		}
		// note: must have a delegate
		[captureMovieOutput startRecordingToOutputFileURL:captureMovieURL
										recordingDelegate:self];
	}
}

#pragma mark AVCaptureFileOutputRecordingDelegate 

/** Supposedly the methods in AVCaptureFileOutputRecordingDelegate are optional, but you
	will get a compiler warning if you don't actually implement them (check for @optional?)
 */

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
		didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
		fromConnections:(NSArray *)connections {
	NSLog (@"started recording to %@", fileURL);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
		didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
		fromConnections:(NSArray *)connections error:(NSError *)error {
	if (error) { 
		NSLog (@"failed to record: %@", error);
	} else {
		NSLog (@"finished recording to %@", outputFileURL);
	}
	
}


@end
