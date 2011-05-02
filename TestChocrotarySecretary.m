//
//  TestChocrotarySecretary.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotarySecretary.h"
#import "ChocrotarySecretary.h"
#import "ChocrotaryProject.h"
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

	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task1];
	
	[task2 scheduleFor:[NSDate date]];
	
	STAssertEquals([secretary countInboxTasks], 1L, @"Should have only one task in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task3, @"Task 3 should be the task in inbox");
}

-(void) testMoveToInbox {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task1];
	
	[task2 scheduleFor:[NSDate date]];
	
	STAssertEquals([secretary countInboxTasks], 1L, @"Should have only one task in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task3, @"Task 3 should be the task in inbox");

	[task1 unsetProject];
	STAssertEquals([secretary countInboxTasks], 2L, @"Should have two tasks in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task1, @"Task 1 should be the task in inbox");
}

-(void) testCountScheduled {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	/*ChocrotaryTask *task1 = */[secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	/*ChocrotaryTask *task3 = */[secretary createTask:@"Buy pequi"];	
	[task2 scheduleFor:[NSDate date]];
	
	
	STAssertEquals([secretary countScheduledTasks], 1L, @"Should have only one schduled tasks");
	STAssertEqualObjects([secretary getNthScheduledTask:0], task2, @"Should be task 2");
}

-(void) testCountScheduledForToday {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	/*ChocrotaryTask *task1 = */[secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
		
	[task2 scheduleFor:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*72];
	[task3 scheduleFor:future];
	
	STAssertEquals([secretary countTasksScheduledForToday], 1L, @"Should have only one schduled tasks");
	STAssertEquals([secretary getNthTaskScheduledForToday:0], task2, @"Should be task 2");
}

-(void) testGetProject {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotaryProject *project1 = [secretary createProject:@"Chocrotary"],
	*project2 = [secretary createProject:@"libsecretary"], *project;
	
	project = [secretary getProjectByName:@"Chocrotary"];
	STAssertEqualObjects(project, project1, @"Should be the first project");
	project = [secretary getProjectByName:@"libsecretary"];
	STAssertEqualObjects(project, project2, @"Should be the second project");	
}

-(void) testGetTaskObjectFromTask {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotaryTask *task = [secretary createTask:@"Add hidden option"];
	Task *wrapped = [task wrappedTask];
	
	ChocrotaryTask *task2 = [secretary wrapperForTask:wrapped];
	STAssertEqualObjects(task, task2, @"Should be equal");
}

-(void) testAttachDetachTaskObserver {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachTaskObserver:stub];
	STAssertEquals([stub countTaskUpdates], 0L, @"Should have no task update");
	
	[secretary notifyTaskUpdate];
	STAssertEquals([stub countTaskUpdates], 1L, @"Now should have one task update");

	ChocrotarySecretaryObserverStub *stub2 = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachTaskObserver:stub2];
	STAssertEquals([stub2 countTaskUpdates], 0L, @"Should have no task update");
	
	[secretary notifyTaskUpdate];
	STAssertEquals([stub countTaskUpdates], 2L, @"Should have two task updates");
	STAssertEquals([stub2 countTaskUpdates], 1L, @"Now should have one task update");
	
	[secretary detachTasksObserver:stub];
	[secretary notifyTaskUpdate];
	STAssertEquals([stub countTaskUpdates], 2L, @"Should have still two task updates");
	STAssertEquals([stub2 countTaskUpdates], 2L, @"Now should have two task updates");
}

-(void) testAttachDetachProjectObserver {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachProjectObserver:stub];
	STAssertEquals([stub countProjectUpdates], 0L, @"Should have no project update");
	
	[secretary notifyProjectUpdate];
	STAssertEquals([stub countProjectUpdates],1L, @"Now should have one project update");
	
	ChocrotarySecretaryObserverStub *stub2 = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachProjectObserver:stub2];
	STAssertEquals([stub2 countProjectUpdates], 0L, @"Should have no project update");
	
	[secretary notifyProjectUpdate];
	STAssertEquals([stub countProjectUpdates], 2L, @"Should have 2 project update");
	STAssertEquals([stub2 countProjectUpdates], 1L, @"Should have no project update");
	
	[secretary detachProjectsObserver:stub];
	[secretary notifyProjectUpdate];
	STAssertEquals([stub countProjectUpdates], 2L, @"Should have still two project updates");
	STAssertEquals([stub2 countProjectUpdates], 2L, @"Should have one project update");
}
@end
