//
//  TestChocrotarySecretaryScheduledPerspective.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 12/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
	[project addTask:task1];
	[task2 scheduleFor:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[task3 scheduleFor:future];
	
	ChocrotarySecretaryPerspective *scheduledPerspective = [[ChocrotarySecretaryScheduledPerspective alloc] initWithChocrotarySecretary:secretary];
	STAssertEquals([scheduledPerspective countTasks], 2L, @"Should have two task scheduled");
	STAssertEquals([scheduledPerspective getNthTask:0], task2, @"Should be task 2");
	STAssertEquals([scheduledPerspective getNthTask:1], task3, @"Should be task 3");
	
}
-(void) testArchive {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30];
	[task1 scheduleFor:date];
	[task2 scheduleFor:date];
	[task3 scheduleFor:date];
	[task2 markAsDone];
	
	STAssertEquals([secretary countScheduledTasks], 3L, @"Should have three sch tasks");
	STAssertEquals([secretary getNthScheduledTask:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([secretary getNthScheduledTask:1], task2, @"Task 2 should be a task sch");
	STAssertEquals([secretary getNthScheduledTask:2], task3, @"Task 1 should be a task sch");
	
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryScheduledPerspective newWithSecretary:secretary];
	STAssertEquals([perspective countTasks], 3L, @"Should have one task");
	STAssertEquals([perspective getNthTask:0], task1, @"Should be task 1");
	STAssertEquals([perspective getNthTask:1], task2, @"Should be task 2");
	STAssertEquals([perspective getNthTask:2], task3, @"Should be task 3");
	
	[perspective archiveAllDoneTasks];
	
	
	STAssertEquals([secretary countScheduledTasks], 2L, @"Should have two tasks in inbox");
	STAssertEquals([secretary getNthScheduledTask:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([secretary getNthScheduledTask:1], task3, @"Task 3 should be the task sch");
	
}

@end