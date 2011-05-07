//
//  TestChocrotaryController.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface TestChocrotaryController : SenTestCase {

}

-(void) testUpdateProjectsMenu;
-(void) testChangePerspectiveToInbox;
-(void) testChangePerspectiveToScheduled;
-(void) testChangePerspectiveToScheduledForToday;
-(void) testChangePerspectiveToProject;
@end
