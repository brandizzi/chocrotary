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
//  TestChocrotarySecretaryInboxPerspective.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 12/05/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotarySecretaryInboxPerspective.h"
#import "ChocrotarySecretaryInboxPerspective.h"
#import "ChocrotaryProject.h"

@implementation TestChocrotarySecretaryInboxPerspective
-(void) testPerspective {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task1];
	[task2 scheduleFor:[NSDate date]];
	
	ChocrotarySecretaryPerspective *inboxPerspective = [ChocrotarySecretaryInboxPerspective newWithSecretary:secretary];
	STAssertEquals([inboxPerspective countTasks], 1L, @"Should have one task");
	STAssertEquals([inboxPerspective getNthTask:0], task3, @"Should be task 3, which is neither associated to project nor scheduled");
}

-(void) testArchive {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	[task2 markAsDone];
	
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryInboxPerspective newWithSecretary:secretary];
	STAssertEquals([perspective countTasks], 3L, @"Should have one task");
	STAssertEquals([perspective getNthTask:0], task1, @"Should be task 1");
	STAssertEquals([perspective getNthTask:1], task2, @"Should be task 2");
	STAssertEquals([perspective getNthTask:2], task3, @"Should be task 3");
	
	[perspective archiveAllDoneTasks];
	
	STAssertEquals([perspective countTasks], 2L, @"Should have one task");
	STAssertEquals([perspective getNthTask:0], task1, @"Should be task 1");
	STAssertEquals([perspective getNthTask:1], task3, @"Should be task 3");
}

@end
