//
//  ChocrotaryProjectTableDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryController.h"

typedef enum {
	ChocrotaryProjectTableViewDataSourceInbox = 0L,
	ChocrotaryProjectTableViewDataSourceScheduled,
	ChocrotaryProjectTableViewDataSourceScheduledForToday
} ChocrotaryProjectTableViewSelected;

#define ChocrotaryProjectTableViewDataSourceFirstProject (ChocrotaryProjectTableViewDataSourceScheduledForToday+1)


@interface ChocrotaryProjectTableViewDataSource : NSObject < NSTableViewDataSource/*, NSTableViewDelegate*/ > {
	IBOutlet ChocrotaryController *controller;
	//IBOutlet NSTableView *tableView;
}

@property (readwrite,assign) ChocrotaryController *controller;
//@property (readwrite,assign) NSTableView *tableView;

// Data source protocol
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView 
	objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

// Delegate protocol
//- (void)tableViewSelectionDidChange:(NSNotification *)notification;
@end
