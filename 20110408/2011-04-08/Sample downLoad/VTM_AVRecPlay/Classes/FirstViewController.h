//
//  FirstViewController.h
//  VTM_AVRecPlay
//
//  Created by Chris Adamson on 10/4/10.
//  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface FirstViewController : UIViewController <AVCaptureFileOutputRecordingDelegate > {

	AVCaptureSession	*captureSession;
	AVCaptureMovieFileOutput *captureMovieOutput;
	NSString *captureMoviePath;
	NSURL *captureMovieURL;
}

@property (nonatomic, retain) IBOutlet UIView *captureView;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;

-(IBAction) startStopCaptureTapped: (id) sender;

@end
