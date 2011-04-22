//
//  VTM_PlayerViewController.h
//  VTM_Player
//
//  Created by Chris Adamson on 10/15/10.
//  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VTM_AVPlayerViewController : UIViewController {
	AVPlayer *player;
	UIView *playerView;
	UILabel *noVideoLabel;
}

@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) IBOutlet UIView *playerView;
@property (nonatomic, retain) IBOutlet	UILabel *noVideoLabel;


@end


