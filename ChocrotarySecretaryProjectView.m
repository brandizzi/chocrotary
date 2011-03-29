//
//  ChocrotarySecretaryProjectView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 29/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryProjectView.h"


@implementation ChocrotarySecretaryProjectView

@synthesize project;

-(id) initWithChocrotarySecretary:(ChocrotarySecretary*) s 
					   forProject: (ChocrotaryProject*) p {
	[super initWithChocrotarySecretary:s];
	self->project = p;
	return self;
}
- (NSInteger) countTasks {
	if (project != NULL) {
		return project_count_task(project);
	}
	return 0L;
}
- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	if (project != NULL) {
		return project_get_nth_task(project, n);
	}
	return NULL;
}
@end
