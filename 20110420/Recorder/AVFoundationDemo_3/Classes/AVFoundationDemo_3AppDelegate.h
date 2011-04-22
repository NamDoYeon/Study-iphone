//
//  AVFoundationDemo_3AppDelegate.h
//  AVFoundationDemo_3
//
//  Created by ziyi on 11-4-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVFoundationDemo_3ViewController;

@interface AVFoundationDemo_3AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AVFoundationDemo_3ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AVFoundationDemo_3ViewController *viewController;

@end

