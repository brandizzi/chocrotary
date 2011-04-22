//
//  ChocrotarySecretaryObserverStub.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 21/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChocrotarySecretaryObserverStub.h"


@implementation ChocrotarySecretaryObserverStub

-(id) init {
	countTasksUpdates=0;
	countProjectsUpdates=0;
	return self;
}

@synthesize countProjectsUpdates, countTasksUpdates;

-(void) projectsWereUpdated:(ChocrotarySecretary*) secretary {
	countProjectsUpdates++;
}

-(void) tasksWereUpdated:(ChocrotarySecretary*) secretary {
	countTasksUpdates++;
}

@end
