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
//  TestChocrotarySecretaryTodayPerspective.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 12/05/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotarySecretaryTodayPerspective.h"
#import "ChocrotarySecretaryScheduledForTodayPerspective.h"
#import "ChocrotaryProject.h"


@implementation TestChocrotarySecretaryTodayPerspective
-(void) testPerspective {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task1];
	[secretary scheduleTask:task2 forDate:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:UTIL_SECONDS_IN_DAY*3];
	[secretary scheduleTask:task3 forDate:future];
	
	ChocrotarySecretaryPerspective *todayPerspective = [[ChocrotarySecretaryScheduledForTodayPerspective alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([todayPerspective countTasks], 1L, @"Should have one task scheduled for today");
	STAssertEqualObjects([todayPerspective getNthTask:0], task2, @"Should be task 2");
	
}
-(void) testArchive {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	NSDate *date = [NSDate date];
	[secretary scheduleTask:task1 forDate:date];
	[secretary scheduleTask:task2 forDate:date];
	[secretary scheduleTask:task3 forDate:date];
	[task2 markAsDone];
	
	STAssertEquals([secretary countTasksScheduledForToday], 3L, @"Should have three sch tasks");
	STAssertEqualObjects([secretary getNthTaskScheduledForToday:0], task1, @"Task 1 should be a task sch");
	STAssertEqualObjects([secretary getNthTaskScheduledForToday:1], task2, @"Task 2 should be a task sch");
	STAssertEqualObjects([secretary getNthTaskScheduledForToday:2], task3, @"Task 1 should be a task sch");
	
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryScheduledForTodayPerspective newWithSecretary:secretary];
	STAssertEquals([perspective countTasks], 3L, @"Should have three task");
	STAssertEqualObjects([perspective getNthTask:0], task1, @"Should be task 1");
	STAssertEqualObjects([perspective getNthTask:1], task2, @"Should be task 2");
	STAssertEqualObjects([perspective getNthTask:2], task3, @"Should be task 3");
	
	[perspective archiveAllDoneTasks];

	
	STAssertEquals([secretary countTasksScheduledForToday], 2L, @"Should have two tasks in inbox");
	STAssertEqualObjects([secretary getNthTaskScheduledForToday:0], task1, @"Task 1 should be a task sch");
	STAssertEqualObjects([secretary getNthTaskScheduledForToday:1], task3, @"Task 3 should be the task sch");
	
}
@end
