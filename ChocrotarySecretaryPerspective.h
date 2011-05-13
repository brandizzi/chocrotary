//
//  ChocrotarySecretaryView.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotarySecretary.h"

@interface ChocrotarySecretaryPerspective : NSObject {
	ChocrotarySecretary *secretary;
	ChocrotaryProject *project;
}

@property (readonly) ChocrotarySecretary *secretary;
@property (readwrite,assign) ChocrotaryProject *project;

- (id) initWithChocrotarySecretary: (ChocrotarySecretary*) secretary;
+ (id) newWithSecretary: (ChocrotarySecretary*) secretary;
- (NSInteger) countTasks;
- (ChocrotaryTask *) getNthTask:(NSInteger) n;
- (void) addTask;

- (void) archiveAllDoneTasks;

@end
