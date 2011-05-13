//
//  TestChocrotarySecretary.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface TestChocrotarySecretary : SenTestCase {
}
-(void) testZero;
-(void) testMoveToProject;
-(void) testMoveToInbox;
-(void) testCountScheduled;
-(void) testCountScheduledForToday;
-(void) testGetProject;
-(void) testGetTaskObjectFromTask;

-(void) testAttachDetachTaskObserver;
-(void) testAttachDetachProjectObserver;
-(void) testAttachedTaskObserverKnowsTaskUpdate;
-(void) testAttachedProjectObserverKnowsProjectUpdate;

-(void) testArchiveInboxTasks;
-(void) testArchiveScheduledTasks;
-(void) testArchiveScheduledForTodayTasks;
@end
