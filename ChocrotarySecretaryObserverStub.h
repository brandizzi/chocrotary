//
//  ChocrotarySecretaryObserverStub.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 21/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotarySecretaryObserver.h"


@interface ChocrotarySecretaryObserverStub : NSObject <ChocrotarySecretaryObserver> {
	NSInteger countProjectsUpdates, countTasksUpdates;
}

@property (readonly) NSInteger countProjectsUpdates, countTasksUpdates;

-(id) init;
-(void) projectsWereUpdated:(ChocrotarySecretary*) secretary;
-(void) tasksWereUpdated:(ChocrotarySecretary*) secretary;

@end
