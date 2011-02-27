//
//  ChtSecretary.m
//  chocrotary
//
//  Created by Adam Victor Nazareth Brandizzi on 26/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChtSecretary.h"


@implementation ChtSecretary

- (id) init {
	secretary = secretary_new();
}

- (ChtSecretary *) encapsulate:(Secretary*) readySecretary {
	secretary = readySecretary;
}

- (ChtTask *) appoint:(NSString*) description {
	const char *_d = [description cString];
	Task *task = secretary_appoint(secretary, _d);
	return [ChtTask encapsulate: task];
}
- (NSInteger) countTask;
- (ChtTask *) getTasks:(NSInteger) number;
- (ChtTask *) getNthTask:(NSInteger) n;

- (NSInteger) countInbox;
- (ChtTask *) getNthInboxTask:(NSInteger) n;

- (ChtProject *)start:(NSString*) name;
- (NSInteger) countProject;
- (ChtProject *) getProject: (NSString*) name;
- (ChtProject *) getNthProject: (NSInteger) n;

- (void) move:(ChtTask *) task toProject: (ChtProject *)project;
- (void) moveToInbox:(ChtTask *)task;

- (void) deleteTask:(ChtTask *) task;
- (void) deleteProject: (ChtProject *) project;

- (void) schedule:(ChtTask *) task toDate: (NSDate *) date;
- (NSInteger) countScheduled;
- (NSInteger) countScheduledFor:(NSDate *) date;
- (NSInteger) countScheduledForToday;
- (ChtTask *) getNthScheduled:(NSInteger) n;
- (ChtTask *) getNthScheduled:(NSInteger) n forDate:(NSDate *) date ;
- (ChtTask *) getNthScheduledForToday:(NSInteger) n;
- (void) unschedule:(ChtTask *) task;

- (void) doIt:(ChtTask *)task;
- (void) undo:(ChtTask *)task;
- (NSInteger) countDoneTasks;
- (ChtTask *) getNthDoneTask:(NSInteger) n;

- (void) free;
@end
