#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window,rootViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[application setStatusBarHidden:YES animated:NO];
	[window addSubview:rootViewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[rootViewController release];
    [window release];
    [super dealloc];
}


@end
