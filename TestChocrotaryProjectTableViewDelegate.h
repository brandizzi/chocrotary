//
//  TestChocrotaryProjectTableViewDelecate.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface TestChocrotaryProjectTableViewDelegate : SenTestCase {
	
}
-(void) testChangePerspectiveToInbox;
-(void) testChangePerspectiveToScheduled;
-(void) testChangePerspectiveToScheduledForToday;
-(void) testChangePerspectiveToProject;
-(void) testChangeTotalLabel;
@end
