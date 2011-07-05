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
//  TestChocrotarySecretaryProjectPerspective.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 12/05/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotarySecretaryProjectPerspective.h"
#import "ChocrotarySecretaryProjectPerspective.h"
#import "ChocrotaryProject.h"

@implementation TestChocrotarySecretaryProjectPerspective

-(void) testPerspective {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project1 = [secretary createProject:@"Chocrotary"];
	[project1 addTask:task1];
	ChocrotaryProject *project2 = [secretary createProject:@"libsecretary"];
	[project2 addTask:task2];
	
	ChocrotarySecretaryPerspective *projectPerspective = [[ChocrotarySecretaryProjectPerspective alloc] 
														  initWithChocrotarySecretary:secretary
														  forProject:project1];
	STAssertEquals([projectPerspective countTasks], 1L, @"Should have one task in project 1");
	STAssertEqualObjects([projectPerspective getNthTask:0], task1, @"Should be task 1");	
	projectPerspective = [[ChocrotarySecretaryProjectPerspective alloc] 
						  initWithChocrotarySecretary:secretary
						  forProject:project2];
	STAssertEquals([projectPerspective countTasks], 1L, @"Should have one task in project 2");
	STAssertEqualObjects([projectPerspective getNthTask:0], task2, @"Should be task 2");
}

-(void) testArchive {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];

	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task1];
	[project addTask:task2];
	[project addTask:task3];
	[task2 markAsDone];
	
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryProjectPerspective 
												   newWithSecretary:secretary];
	[perspective setProject:project];
	STAssertEquals([perspective countTasks], 3L, @"Should have one task");
	STAssertEquals([perspective getNthTask:0], task1, @"Should be task 1");
	STAssertEquals([perspective getNthTask:1], task2, @"Should be task 2");
	STAssertEquals([perspective getNthTask:2], task3, @"Should be task 3");
	
	[perspective archiveAllDoneTasks];
	
	
	STAssertEquals([project countTasks], 2L, @"Should have two tasks in inbox");
	STAssertEquals([project getNthTask:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([project getNthTask:1], task3, @"Task 3 should be the task sch");
	
}
@end
