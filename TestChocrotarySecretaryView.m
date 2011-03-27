//
//  TestChocrotarySecretaryView.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotarySecretaryView.h"
#import "ChocrotarySecretary.h"
#import "ChocrotarySecretaryView.h"
#import "ChocrotarySecretaryInboxView.h"
#import "ChocrotarySecretaryScheduledView.h"
#import "ChocrotarySecretaryScheduledForTodayView.h"


@implementation TestChocrotarySecretaryView
-(void) testInboxView {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	
	ChocrotarySecretaryView *inboxView = [[ChocrotarySecretaryInboxView alloc] initWithSecretary:secretary];
	STAssertEquals([inboxView countTasks], 1L, @"Should have one task");
	STAssertEquals([inboxView getNthTask:0], task3, @"Should be task 3, which is neither associated to project nor scheduled");
}
-(void) testScheduledView {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[secretary schedule:task3 to:future];
	
	ChocrotarySecretaryView *scheduledView = [[ChocrotarySecretaryScheduledView alloc] initWithSecretary:secretary];
	STAssertEquals([scheduledView countTasks], 2L, @"Should have two task scheduled");
	STAssertEquals([scheduledView getNthTask:0], task2, @"Should be task 2");
	STAssertEquals([scheduledView getNthTask:1], task3, @"Should be task 3");

}
-(void) testTodayView {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary appoint:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary appoint:@"Add hidden option"];
	ChocrotaryTask *task3 =[secretary appoint:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary start:@"Chocrotary"];
	[secretary move:task1 to:project];
	[secretary schedule:task2 to:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[secretary schedule:task3 to:future];
	
	ChocrotarySecretaryView *todayView = [[ChocrotarySecretaryScheduledForTodayView alloc] initWithSecretary:secretary];
	STAssertEquals([todayView countTasks], 1L, @"Should have one task scheduled for today");
	STAssertEquals([todayView getNthTask:0], task2, @"Should be task 2");
	
}
@end
