//
//  ChocrotaryTableDataSource.h
//  Chocrotary
//
//  Created by Adam Victor Nazareth Brandizzi on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "secretary/notebook.h"

@interface ChocrotaryTableDataSource : NSObject {
	Notebook *notebook;
	Secretary *secretary;
}

- (id) init;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView 
		objectValueForTableColumn:(NSTableColumn *)tableColumn 
		row:(NSInteger)row;
- (void)tableView:(NSTableView *)aTableView 
		setObjectValue:(id)anObject 
		forTableColumn:(NSTableColumn *)aTableColumn 
	    row:(NSInteger)rowIndex;

@end
