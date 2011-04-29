//
//  ChocrotarySecretaryProjectView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 29/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryProjectPerspective.h"


@implementation ChocrotarySecretaryProjectPerspective

@synthesize project;

-(id) initWithChocrotarySecretary:(ChocrotarySecretary*) s 
					   forProject: (ChocrotaryProject*) p {
	[super initWithChocrotarySecretary:s];
	self->project = p;
	return self;
}
- (NSInteger) countTasks {
	if (project != NULL) {
		return [project countTasks];
	}
	return 0L;
}
- (ChocrotaryTask *) getNthTask:(NSInteger) n {
	if (project != NULL) {
		return [project getNthTask:n];
	}
	return NULL;
}
@end
