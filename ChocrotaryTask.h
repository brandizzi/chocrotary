//
//  ChocrotaryTask.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 26/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/task.h>
#import <secretary/project.h>

typedef Project ChocrotaryProject;

@interface ChocrotaryTask : NSObject {
	Task *task;
}

-(id)initWithTask:(Task*) aTask;
+(id)newWithWrappedTask:(Task*) aTask;

-(NSString*) description;
-(void) setDescription:(NSString*) aDescription;

-(BOOL) done;
-(void) markAsDone;
-(void) unmarkAsDone;

-(BOOL) isScheduled;
-(NSDate*) scheduledFor;
-(void) scheduleFor:(NSDate*) aDate;
-(void) unschedule;

-(ChocrotaryProject*) project;
	
-(Task*) wrappedTask;

@end
