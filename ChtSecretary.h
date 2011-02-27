//
//  ChtSecretary.h
//  chocrotary
//
//  Created by Adam Victor Nazareth Brandizzi on 26/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ChtTask.h>
#import <ChtProject.h>

#import <secretary/secretary.h>

@interface ChtSecretary : NSObject {
	Secretary *secretary;
}

- (id) init;
- (ChtSecretary *) encapsulate:(Secretary*) readySecretary;
- (ChtTask *) appoint:(NSString*) description;
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
