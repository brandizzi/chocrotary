//
//  ChocrotarySecretaryObserverStub.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 21/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryTaskObserver.h"
#import "ChocrotaryProjectObserver.h"

@interface ChocrotarySecretaryObserverStub : NSObject <ChocrotaryTaskObserver, ChocrotaryProjectObserver> {
	NSInteger countProjectUpdates, countTaskUpdates;
}

@property (readonly) NSInteger countProjectUpdates, countTaskUpdates;

-(id) init;
-(void) projectsWereUpdated:(id) objectWitState;
-(void) tasksWereUpdated:(id) objectWitState;

@end
