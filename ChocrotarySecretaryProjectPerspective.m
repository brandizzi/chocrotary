//
//  ChocrotarySecretaryProjectView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 29/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryProjectPerspective.h"
#import "ChocrotaryProject.h"


@implementation ChocrotarySecretaryProjectPerspective

-(id) initWithChocrotarySecretary:(ChocrotarySecretary*) s 
					   forProject: (ChocrotaryProject*) p {
	[super initWithChocrotarySecretary:s];
	self->project = p;
	return self;
}
- (NSInteger) countTasks {
	if (project != nil) {
		return [project countTasks];
	}
	return 0L;
}
- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	if (project != nil) {
		return [project getNthTask:n];
	}
	return nil;
}

- (void) addTask {
	ChocrotaryTask *task = [secretary createTask:@""];
	[project addTask:task];
}

- (void) archiveAllDoneTasks {
	[project archiveDoneTasks];
}
@end
