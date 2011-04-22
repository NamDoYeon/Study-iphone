//
//  AVFoundationDemo_3ViewController.m
//  AVFoundationDemo_3
//
//  Created by ziyi on 11-4-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AVFoundationDemo_3ViewController.h"

@implementation AVFoundationDemo_3ViewController
-(void)viewDidLoad{
	[super viewDidLoad];
	recordEncoding = ENC_AAC;
}

-(IBAction)startRecording{
	NSLog(@"开始录音");
	[audioRecorder release];
	audioRecorder = nil;
	
	// init audio with record capability
	AVAudioSession *audioSession = [AVAudioSession sharedInstance]; // return single audio session
	[audioSession setCategory:AVAudioSessionCategoryRecord error:nil]; //sets audio session category is recording type
	
	NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
	if (recordEncoding == ENC_PCM) {
		[recordSettings setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey]; // 一个没有压缩的音频 // a format identifier[标识付]
		[recordSettings setObject:[NSNumber numberWithInt:44100.0] forKey:AVSampleRateKey]; // sample reta[率] 采样率
		[recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey]; // expression［表示］nsnumber integer value
		[recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey]; // nsnumber integer value
		[recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey]; // 指示是大音频 还是小音频
		[recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey]; // 指示音频格式是浮点还是整点
	}else {
		NSNumber *formatObject;
		switch (recordEncoding) {
			case ENC_AAC:
				formatObject = [NSNumber numberWithInt:kAudioFormatMPEG4AAC]; // identifiers for audioStreamBasicDescription in the structure
				break;
			case ENC_ALAC:
				formatObject = [NSNumber numberWithInt:kAudioFormatAppleLossless];
				break;
			case ENC_IMA4:
				formatObject = [NSNumber numberWithInt:kAudioFormatAppleIMA4];
				break;
			case ENC_ILBC:
				formatObject = [NSNumber numberWithInt:kAudioFormatiLBC];
				break;
			case ENC_ULAW:
				formatObject = [NSNumber numberWithInt:kAudioFormatULaw];
				break;
			default:
				formatObject = [NSNumber numberWithInt:kAudioFormatAppleIMA4];
				break;
		}
		[recordSettings setObject:formatObject forKey:AVFormatIDKey];
		[recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
		[recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
		[recordSettings setObject:[NSNumber numberWithInt:128800] forKey:AVEncoderBitRateKey];
		[recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
		[recordSettings setObject:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey]; // high quality[品质] convert // 
	}
	//NSDate *today = [NSDate date];
	//NSString *tempDir = NSTemporaryDirectory();
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound.caf",[[NSBundle mainBundle] bundlePath]]]; // includ complete path
	NSLog(@"url = %@",url);
	NSError *error = nil;
	audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
	
	if ([audioRecorder prepareToRecord] == YES) { // create audio an file ready record system
		[audioRecorder record]; // start record
		[audioRecorder peakPowerForChannel:0]; // record audio max  0 display max －160 display min
	}else {
		int errorCode = CFSwapInt32HostToBig([error code]); // return error
		NSLog(@"Error:%@ [%4,4s]",[error localizedDescription],(char*)&errorCode); // return localized error information
		
	}
	NSLog(@"recording");
}

-(IBAction)stopRecording{
	NSLog(@"StopRecording");
	[audioRecorder stop];
	NSLog(@"Stopped");
}
-(IBAction)playRecording{
	NSLog(@"playRecording");
	// init audio with playback capability
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound.caf",[[NSBundle mainBundle] bundlePath]]];
	NSError *error = nil;
	NSLog(@"url = %@",url);
	audioPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlay.numberOfLoops = 0;
	audioPlay.volume = 1.0; // playback audio max 1 display max 0 display min
	[audioPlay play];
	NSLog(@"playing");
}
-(IBAction)stopPlaying{
	NSLog(@"stopPlaying");
	[audioPlay stop];
	NSLog(@"stopped");
}
- (void)dealloc {
    [super dealloc];
}

@end
