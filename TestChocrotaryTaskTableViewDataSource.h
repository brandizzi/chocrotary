//
//  TestChocrotaryTableViewDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 06/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface TestChocrotaryTaskTableViewDataSource : SenTestCase {

}

-(void) testInboxTasks;
-(void) testScheduleTasks;
-(void) testScheduleForToday;
-(void) testProject;

@end
