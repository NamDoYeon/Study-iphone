//
//  VTM_PlayerAppDelegate.h
//  VTM_Player
//
//  Created by Chris Adamson on 10/16/10.
//  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTM_AVPlayerViewController;

@interface VTM_AVPlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    VTM_AVPlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet VTM_AVPlayerViewController *viewController;

@end

