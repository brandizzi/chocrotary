/**
 * Secretary for Mac OS X (aka Chocrotary): a Objective-C-written, 
 * Cocoa-based todo list manager
 * Copyright (C) 2011  Adam Victor Nazareth Brandizzi <brandizzi@gmail.com>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * You can get the latest version of this file at 
 * http://bitbucket.org/brandizzi/chocrotary/
 */
//  ChtSecretary.h
//  chocrotary
//  Created by Adam Victor Nazareth Brandizzi on 26/02/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

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
