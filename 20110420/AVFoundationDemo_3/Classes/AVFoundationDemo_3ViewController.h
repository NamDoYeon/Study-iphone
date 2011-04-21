//
//  AVFoundationDemo_3ViewController.h
//  AVFoundationDemo_3
//
//  Created by ziyi on 11-4-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AVFoundationDemo_3ViewController : UIViewController {
	AVAudioPlayer *audioPlay;
	AVAudioRecorder *audioRecorder;
	int recordEncoding;
	enum 
	{
		ENC_AAC = 1,
		ENC_ALAC = 2,
		ENC_IMA4 = 3,
		ENC_ILBC = 4,
		ENC_ULAW = 5,
		ENC_PCM = 6,
	}encodingTypes;
}

-(IBAction)startRecording;
-(IBAction)stopRecording;
-(IBAction)playRecording;
-(IBAction)stopPlaying;
@end

