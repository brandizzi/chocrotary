/**
 * Secretary for Mac OS X (aka Chocrotary): a Objective-C-written, 
 * Cocoa-based todo list manager
 * Copyright (C) 2011  Adam Victor Nazareth Brandizzi <brandizzi@gmail.com>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * You can get the latest version of this file at 
 * http://bitbucket.org/brandizzi/chocrotary/
 */
//  ChocrotaryController.h
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 28/02/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import <Cocoa/Cocoa.h>
#import "ChocrotaryNotebook.h"
#import "ChocrotaryProject.h"
#import "ChocrotaryTableViewDataSource.h"

#define ChocrotaryControllerNoProject (-1L)
#define ChocrotaryTotalLabelMask @"%d projects, %d tasks here (%d tasks everywhere)"

@class ChocrotaryTaskTableViewController;

@interface ChocrotaryController : NSObject {
	ChocrotaryNotebook *notebook;
	ChocrotarySecretary *secretary;
	
	IBOutlet NSTableView* taskTableView;
	IBOutlet NSTableView* projectTableView;
	IBOutlet NSMenu *projectsMenu;
	IBOutlet NSTextField *totalLabel;
	
	IBOutlet ChocrotaryTaskTableViewController *taskTableViewController;

	// DEPRECATED!!!
	IBOutlet NSMutableArray *projectArray;
	
	
}

@property(readonly) ChocrotarySecretary *secretary;
@property(readonly) ChocrotaryNotebook *notebook;

@property(readwrite,assign) NSTableView* taskTableView;
@property(readwrite,assign) NSTableView* projectTableView;
@property(readwrite,assign) NSTextField* totalLabel;

@property(readwrite,assign) ChocrotaryTaskTableViewController *taskTableViewController;


// DEPRECATED
@property(readwrite,assign) NSMutableArray *projectArray;
@property(readwrite,assign) NSMenu *projectsMenu;

-(id)init;
-(id) initWithNotebook:(ChocrotaryNotebook*) n;
-(void) awakeFromNib;

-(void)reloadMenuOfProjects;
-(void) updateTotalLabel;
-(void) reconfigureTaskTable;

-(IBAction) addTask:(id)sender;
-(IBAction) removeTask:(id)sender;
-(IBAction) archiveTasksOfCurrentPerspective:(id)sender;
-(IBAction) addProject:(id)sender;
-(IBAction) removeProject:(id)sender;



@end
