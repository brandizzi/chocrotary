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
	ChocrotaryProjectTableViewDataSourceInbox = 0,
	ChocrotaryProjectTableViewDataSourceScheduled,
	ChocrotaryProjectTableViewDataSourceScheduledForToday
} ChocrotaryProjectTableViewSelected;

#define ChocrotaryProjectTableViewDataSourceFirstProject (ChocrotaryProjectTableViewDataSourceScheduledForToday+1)


@interface ChocrotaryProjectTableViewDataSource : NSObject < NSTableViewDataSource > {
	IBOutlet ChocrotaryController *controller;
}

@property (readwrite,assign) ChocrotaryController *controller;
	
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView 
	objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
@end