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

@interface ChocrotaryController : NSObject {
	ChocrotaryNotebook *notebook;
	ChocrotarySecretary *secretary;
	
	IBOutlet NSTableView* taskTableView;
	IBOutlet NSTableView* projectTableView;
	
	IBOutlet id<ChocrotaryTableViewDataSource> currentDataSource;
	IBOutlet id<ChocrotaryTableViewDataSource> inboxTableDataSource;
}

@property(readonly) ChocrotarySecretary *secretary;

@property(readwrite,assign) NSTableView* taskTableView;
@property(readwrite,assign) NSTableView* projectTableView;

@property(readwrite,assign) id<ChocrotaryTableViewDataSource> currentDataSource; 
@property(readwrite,assign) id<ChocrotaryTableViewDataSource> inboxTableDataSource; 

-(id)init;
-(id) initWithNotebook:(ChocrotaryNotebook*) n;

-(void)save;

-(IBAction) addTask:(id)sender;
-(IBAction) removeTask:(id)sender;

-(IBAction) addProject:(id)sender;
-(IBAction) removeProject:(id)sender;

-(IBAction) reconfigureTaskTable:(id)sender;

@end
