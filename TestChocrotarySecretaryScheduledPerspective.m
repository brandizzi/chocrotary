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
//  TestChocrotarySecretaryScheduledPerspective.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 12/05/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotarySecretaryScheduledPerspective.h"
#import "ChocrotarySecretaryScheduledPerspective.h"
#import "ChocrotaryProject.h"

@implementation TestChocrotarySecretaryScheduledPerspective
-(void) testPerspective {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[secretary moveTask:task1 toProject:project];
	[secretary scheduleTask:task2 forDate:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[secretary scheduleTask:task3 forDate:future];
	
	ChocrotarySecretaryPerspective *scheduledPerspective = [[ChocrotarySecretaryScheduledPerspective alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([scheduledPerspective countTasks], 2L, @"Should have two task scheduled");
	STAssertEqualObjects([scheduledPerspective getNthTask:0], task2, @"Should be task 2");
	STAssertEqualObjects([scheduledPerspective getNthTask:1], task3, @"Should be task 3");
	
}
-(void) testArchive {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30];
	
	[secretary scheduleTask:task1 forDate:date];
	[secretary scheduleTask:task2 forDate:date];
	[secretary scheduleTask:task3 forDate:date];
	[task2 markAsDone];
	
	STAssertEquals([secretary countScheduledTasks], 3L, @"Should have three sch tasks");
	STAssertEqualObjects([secretary getNthScheduledTask:0], task1, @"Task 1 should be a task sch");
	STAssertEqualObjects([secretary getNthScheduledTask:1], task2, @"Task 2 should be a task sch");
	STAssertEqualObjects([secretary getNthScheduledTask:2], task3, @"Task 1 should be a task sch");
	
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryScheduledPerspective newWithSecretary:secretary];
	STAssertEquals([perspective countTasks], 3L, @"Should have one task");
	STAssertEqualObjects([perspective getNthTask:0], task1, @"Should be task 1");
	STAssertEqualObjects([perspective getNthTask:1], task2, @"Should be task 2");
	STAssertEqualObjects([perspective getNthTask:2], task3, @"Should be task 3");
	
	[perspective archiveAllDoneTasks];
	
	
	STAssertEquals([secretary countScheduledTasks], 2L, @"Should have two tasks in inbox");
	STAssertEqualObjects([secretary getNthScheduledTask:0], task1, @"Task 1 should be a task sch");
	STAssertEqualObjects([secretary getNthScheduledTask:1], task3, @"Task 3 should be the task sch");
	
}

@end
