/*
 *  VTM_RecAndPlayConstants.m
 *  VTM_AVRecPlay
 *
 *  Created by Chris Adamson on 10/8/10.
 *  Copyright 2010 Subsequently and Furthermore, Inc. All rights reserved.
 *
 */
#import "VTM_RecAndPlayConstants.h"
	//	NSString *captureMoviePath = [NSTemporaryDirectory() stringByAppendingPathComponent:MOVIE_FILE_NAME];

NSString* getCaptureMoviePath() {
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
	return [documentsDirectoryPath stringByAppendingPathComponent:MOVIE_FILE_NAME];
}