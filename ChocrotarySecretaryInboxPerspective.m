//
//  ChocrotarySecretaryInboxView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryInboxPerspective.h"


@implementation ChocrotarySecretaryInboxPerspective

- (NSInteger) countTasks {
	return [secretary countInboxTasks];
}
- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	return [secretary getNthInboxTask:n];
}

- (void) addTask {
	[secretary createTask:@""];
}
- (void) archiveAllDoneTasks {
	[secretary archiveDoneInboxTasks];
}
@end
