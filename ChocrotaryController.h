//
//  ChocrotaryController.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/notebook.h>

typedef Secretary ChocrotarySecretary;
typedef Task ChocrotaryTask;
typedef Project ChocrotaryProject;

@interface ChocrotaryController : NSObject {
	Notebook *notebook;
	ChocrotarySecretary *secretary;
	IBOutlet NSTableView* taskTableView;
	IBOutlet NSTableView* projectTableView;
}

@property(readwrite,assign) NSTableView* taskTableView;


-(id)init;
-(ChocrotarySecretary*) getSecretary;

-(NSInteger) countTasks;
-(ChocrotaryTask*) getNthTask:(NSInteger)n;
-(void) changeDescription:(ChocrotaryTask*) task to:(NSString*) description;

-(void) doIt:(ChocrotaryTask*) task;
-(void) undo:(ChocrotaryTask*) task;
-(void) switchDone:(ChocrotaryTask*) task;

-(void)save;

-(IBAction) addTask:(id)sender;
-(IBAction) removeTask:(id)sender;

-(IBAction) addProject:(id)sender;
-(IBAction) removeProject:(id)sender;

@end
