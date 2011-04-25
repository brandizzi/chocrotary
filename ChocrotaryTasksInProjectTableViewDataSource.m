//
//  ChocrotaryTasksInProjectTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotaryTasksInProjectTableViewDataSource.h"
#import "ChocrotarySecretaryProjectPerspective.h"

@implementation ChocrotaryTasksInProjectTableViewDataSource

@synthesize controller, project;

- (id) initWithController:(ChocrotaryController*) c {
	self->controller = c;
	return self;
}

- (ChocrotarySecretaryPerspective*) secretaryPerspective {
	if (project != NULL) {
		return [[ChocrotarySecretaryProjectPerspective alloc] 
				initWithChocrotarySecretary:controller.secretary forProject:project];
	}
 	return nil;
}


@end
