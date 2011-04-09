//
//  TestChocrotarySecretary.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotarySecretary.h"
#import "ChocrotarySecretary.h"

@implementation TestChocrotarySecretary
-(void) testZero {
	ChocrotarySecretary *chocrotary = [[ChocrotarySecretary alloc] init];
	STAssertNotNil(chocrotary, @"ChocrotarySecretary not created");
	STAssertEquals([chocrotary countTasks], 0L, @"Should not contain any task");
	[chocrotary release];
}

-(void) testMoveToProject {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];

	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:(ChocrotaryTask*) task1 to:(ChocrotaryProject*) project];
	[secretary schedule:task2 to:[NSDate date]];
	
	STAssertEquals([secretary countInboxTasks], 1L, @"Should have only one task in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task3, @"Task 3 should be the task in inbox");
}

-(void) testMoveToInbox {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:(ChocrotaryTask*) task1 to:(ChocrotaryProject*) project];
	[secretary schedule:task2 to:[NSDate date]];
	
	STAssertEquals([secretary countInboxTasks], 1L, @"Should have only one task in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task3, @"Task 3 should be the task in inbox");

	[secretary moveTaskToInbox:task1];
	STAssertEquals([secretary countInboxTasks], 2L, @"Should have two tasks in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task1, @"Task 1 should be the task in inbox");
}

-(void) testCountScheduled {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	/*ChocrotaryTask *task1 = */[secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	/*ChocrotaryTask *task3 = */[secretary appoint:@"Buy pequi"];
	[secretary schedule:task2 to:[NSDate date]];
	
	STAssertEquals([secretary countScheduledTasks], 1L, @"Should have only one schduled tasks");
	STAssertEquals([secretary getNthScheduledTask:0], task2, @"Should be task 2");
}

-(void) testCountScheduledForToday {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	/*ChocrotaryTask *task1 = */[secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary appoint:@"Buy pequi"];
	
	[secretary schedule:task2 to:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*72];
	[secretary schedule:task3 to:future];
	
	STAssertEquals([secretary countTasksScheduledForToday], 1L, @"Should have only one schduled tasks");
	STAssertEquals([secretary getNthTaskScheduledForToday:0], task2, @"Should be task 2");
}

-(void) testGetProject {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotaryProject *project1 = [secretary start:@"Chocrotary"],
	*project2 = [secretary start:@"libsecretary"], *project;
	
	project = [secretary getProjectByName:@"Chocrotary"];
	STAssertEquals(project, project1, @"Should be the first project");
	project = [secretary getProjectByName:@"libsecretary"];
	STAssertEquals(project, project2, @"Should be the second project");	
}
@end
