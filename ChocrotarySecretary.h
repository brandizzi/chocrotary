//
//  ChocrotarySecretary.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/secretary.h>

typedef Task ChocrotaryTask;
typedef Project ChocrotaryProject;

@interface ChocrotarySecretary : NSObject {
	Secretary *secretary;
}
-(id)init;
-(id)initWithSecretary:(Secretary*) ready;

-(ChocrotaryTask*) appoint:(NSString*) description;
-(NSInteger) countTasks;
-(ChocrotaryTask*) getNthTask:(NSInteger)n;
-(void) deleteTask:(ChocrotaryTask*) task;

-(void)schedule:(ChocrotaryTask*)task to:(NSDate*) date;
-(void)unschedule:(ChocrotaryTask*)task;
-(NSInteger)countScheduledTasks;
-(ChocrotaryTask*)getNthScheduledTask:(NSInteger) n;

-(NSInteger) countTasksScheduledForToday;
-(ChocrotaryTask*) getNthTaskScheduledForToday:(NSInteger)n;

-(void)doTask:(ChocrotaryTask*) task;
-(void)undo:(ChocrotaryTask*) task;
-(void)switchDoneStatus:(ChocrotaryTask*) task;

-(ChocrotaryProject*) start:(NSString*)name;
-(NSInteger) countProjects;
-(ChocrotaryProject*) getNthProject:(NSInteger)n;
-(void) deleteProject:(ChocrotaryProject*) project;

-(void) move:(ChocrotaryTask*) task to:(ChocrotaryProject*) project;

-(NSInteger) countInboxTasks;
-(ChocrotaryTask*) getNthInboxTask:(NSInteger) n;

-(void)release;
@end
