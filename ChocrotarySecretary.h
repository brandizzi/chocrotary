//
//  ChocrotarySecretary.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/secretary.h>
#import "ChocrotaryTask.h"

#import "ChocrotaryTaskObserver.h"
#import "ChocrotaryProjectObserver.h"

@interface ChocrotarySecretary : NSObject <ChocrotaryTaskObserver, ChocrotaryProjectObserver> {
	Secretary *secretary;
	NSMutableSet *tasksObservers, *projectsObservers;
	CFMutableDictionaryRef cachedTaskObjects;
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
-(ChocrotaryProject*) getProjectByName:(NSString*) projectName;
-(void) deleteProject:(ChocrotaryProject*) project;

-(void) move:(ChocrotaryTask*) task to:(ChocrotaryProject*) project;
-(void) moveTaskToInbox:(ChocrotaryTask*) task;

-(NSInteger) countInboxTasks;
-(ChocrotaryTask*) getNthInboxTask:(NSInteger) n;

// For retrieving a ChocrotaryTask wrapping a Task
-(ChocrotaryTask*)wrapperForTask:(Task*) aTask;

// Publisher interface: the methods for reporting to observers that
// the secretary has changed its state.

-(void)attachTasksObserver:(id<ChocrotaryTaskObserver>)observer;
-(void)detachTasksObserver:(id<ChocrotaryTaskObserver>)observer;
-(void)attachProjectsObserver:(id<ChocrotaryProjectObserver>)observer;
-(void)detachProjectsObserver:(id<ChocrotaryProjectObserver>)observer;
-(void)notifyProjectsUpdate;
-(void)notifyTasksUpdate;

// Observer interface: it is through this interface that secretary
// knows when a task/project updates itself and then reports it
// to Secretary's own observers.
-(void) tasksWereUpdated:(ChocrotarySecretary*) secretary;
-(void) projectsWereUpdated:(ChocrotarySecretary*) secretary;

//
-(void)release;
@end
