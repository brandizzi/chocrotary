//
//  ChocrotaryController.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <secretary/secretary.h>
#import "ChocrotaryNotebook.h"
#import "ChocrotaryTableViewDataSource.h"

#define ChocrotaryControllerNoProject (-1L)
#define ChocrotaryTotalLabelMask @"%d tasks here (%d tasks everywhere)"

@class ChocrotaryTaskTableViewController;

@interface ChocrotaryController : NSObject {
	ChocrotaryNotebook *notebook;
	ChocrotarySecretary *secretary;
	
	IBOutlet NSTableView* taskTableView;
	IBOutlet NSTableView* projectTableView;
	IBOutlet NSMenu *projectsMenu;
	IBOutlet NSTextField *totalLabel;
	
	IBOutlet ChocrotaryTaskTableViewController *taskTableViewDataSource;

	// DEPRECATED!!!
	IBOutlet NSMutableArray *projectArray;
	
	
}

@property(readonly) ChocrotarySecretary *secretary;

@property(readwrite,assign) NSTableView* taskTableView;
@property(readwrite,assign) NSTableView* projectTableView;
@property(readwrite,assign) NSTextField* totalLabel;

@property(readwrite,assign) ChocrotaryTaskTableViewController *taskTableViewDataSource;


// DEPRECATED
@property(readwrite,assign) NSMutableArray *projectArray;
@property(readwrite,assign) NSMenu *projectsMenu;

-(id)init;
-(id) initWithNotebook:(ChocrotaryNotebook*) n;
-(void) awakeFromNib;

-(void)save;
-(void)reloadMenuOfProjects;
-(void) updateTotalLabel;

-(IBAction) addTask:(id)sender;
-(IBAction) removeTask:(id)sender;
-(IBAction) archiveTasksOfCurrentPerspective:(id)sender;
-(IBAction) addProject:(id)sender;
-(IBAction) removeProject:(id)sender;

-(IBAction) reconfigureTaskTable:(id)sender;

@end
