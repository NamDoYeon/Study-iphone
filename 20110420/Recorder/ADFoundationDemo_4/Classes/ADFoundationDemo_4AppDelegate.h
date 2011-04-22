//
//  ADFoundationDemo_4AppDelegate.h
//  ADFoundationDemo_4
//
//  Created by ziyi on 11-4-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADFoundationDemo_4ViewController;

@interface ADFoundationDemo_4AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ADFoundationDemo_4ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ADFoundationDemo_4ViewController *viewController;

@end

