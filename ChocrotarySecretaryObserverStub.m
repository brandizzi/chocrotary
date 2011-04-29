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
	countTaskUpdates=0;
	countProjectUpdates=0;
	return self;
}

@synthesize countProjectUpdates, countTaskUpdates;

-(void) projectsWereUpdated:(id) objectWitState {
	countProjectUpdates++;
}

-(void) tasksWereUpdated:(id) objectWitState {
	countTaskUpdates++;
}

@end
