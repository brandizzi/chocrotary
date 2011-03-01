//
//  ChocrotaryTableDataSource.h
//  Chocrotary
//
//  Created by Adam Victor Nazareth Brandizzi on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryController.h"

@interface ChocrotaryTableDataSource : NSObject {
	IBOutlet ChocrotaryController *controller;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView 
		objectValueForTableColumn:(NSTableColumn *)tableColumn 
		row:(NSInteger)row;
- (void)tableView:(NSTableView *)aTableView 
		setObjectValue:(id)anObject 
		forTableColumn:(NSTableColumn *)aTableColumn 
	    row:(NSInteger)rowIndex;

@end
