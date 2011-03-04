//
//  ChocrotaryController.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/notebook.h>

typedef Task ChocrotaryTask;

@interface ChocrotaryController : NSObject {
	Notebook *notebook;
	Secretary *secretary;
	IBOutlet NSTableView* tableView;
}

@property(readwrite,assign) NSTableView* tableView;


-(id)init;
-(Secretary*) getSecretary;

-(NSInteger) countTasks;
-(ChocrotaryTask*) getNthTask:(NSInteger)n;
-(void) changeDescription:(ChocrotaryTask*) task to:(NSString*) description;

-(void) doIt:(ChocrotaryTask*) task;
-(void) undo:(ChocrotaryTask*) task;
-(void) switchDone:(ChocrotaryTask*) task;

-(void)save;

-(IBAction) addTask:(id)sender;
-(IBAction) removeTask:(id)sender;

@end
