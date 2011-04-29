//
//  TestChocrotarySecretary.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotarySecretary.h"
#import "ChocrotarySecretary.h"
#import "ChocrotarySecretaryObserver.h"
#import "ChocrotarySecretaryObserverStub.h"

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
	STAssertEqualObjects([secretary getNthScheduledTask:0], task2, @"Should be task 2");
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
	STAssertEqualObjects(project, project1, @"Should be the first project");
	project = [secretary getProjectByName:@"libsecretary"];
	STAssertEqualObjects(project, project2, @"Should be the second project");	
}

-(void) testGetTaskObjectFromTask {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotaryTask *task = [secretary appoint:@"Add hidden option"];
	Task *wrapped = [task wrappedTask];
	
	ChocrotaryTask *task2 = [secretary wrapperForTask:wrapped];
	STAssertEqualObjects(task, task2, @"Should be equal");
}

-(void) testAttachDetachObserver {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachObserver:stub];
	STAssertEquals([stub countProjectsUpdates], 0L, @"Should have no task update");
	STAssertEquals([stub countProjectsUpdates], 0L, @"Should have no project update");
	
	[secretary notifyProjectsUpdate];
	STAssertEquals([stub countTasksUpdates], 0L, @"Should have no task update");
	STAssertEquals([stub countProjectsUpdates], 1L, @"Should have one project update");
	[secretary notifyTasksUpdate];
	STAssertEquals([stub countTasksUpdates], 1L, @"Now should have one task update");
	STAssertEquals([stub countProjectsUpdates], 1L, @"Should have still one project update");

	ChocrotarySecretaryObserverStub *stub2 = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachObserver:stub2];
	STAssertEquals([stub2 countTasksUpdates], 0L, @"Should have no task update");
	STAssertEquals([stub2 countProjectsUpdates], 0L, @"Should have no project update");
	
	[secretary notifyProjectsUpdate];
	STAssertEquals([stub countTasksUpdates], 1L, @"Should have one task update");
	STAssertEquals([stub countProjectsUpdates], 2L, @"Should have two project updates");
	STAssertEquals([stub2 countTasksUpdates], 0L, @"Should have no task update");
	STAssertEquals([stub2 countProjectsUpdates], 1L, @"Should have one project update");
	[secretary notifyTasksUpdate];
	STAssertEquals([stub countTasksUpdates], 2L, @"Should have two task updates");
	STAssertEquals([stub countProjectsUpdates], 2L, @"Should have tow project updates");
	STAssertEquals([stub2 countTasksUpdates], 1L, @"Now should have one task update");
	STAssertEquals([stub2 countProjectsUpdates], 1L, @"Should have still one project update");
	
	[secretary detachObserver:stub];
	[secretary notifyProjectsUpdate];
	STAssertEquals([stub countTasksUpdates], 2L, @"Should have still two task updates");
	STAssertEquals([stub countProjectsUpdates], 2L, @"Should have two projects update");
	STAssertEquals([stub2 countTasksUpdates], 1L, @"Should have no task update");
	STAssertEquals([stub2 countProjectsUpdates], 2L, @"Should have two project updates");
	[secretary notifyTasksUpdate];
	STAssertEquals([stub countTasksUpdates], 2L, @"Should have still two task updates");
	STAssertEquals([stub countProjectsUpdates], 2L, @"Should have still project updates");
	STAssertEquals([stub2 countTasksUpdates], 2L, @"Now should have two task updates");
	STAssertEquals([stub2 countProjectsUpdates], 2L, @"Should have two project update");
	
}
@end
