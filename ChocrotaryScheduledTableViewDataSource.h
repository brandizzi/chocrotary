//
//  ChocrotaryScheduledTableViewDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryTableViewDataSource.h"
#import "ChocrotaryController.h"

@interface ChocrotaryScheduledTableViewDataSource : NSObject < ChocrotaryTableViewDataSource > {
	IBOutlet ChocrotaryController *controller;
}

@property(readwrite,assign) ChocrotaryController *controller;

-(id) initWithController:(ChocrotaryController*) controller;
-(NSInteger) numberOfColumns;
-(NSTableColumn *) getNthColumn:(NSInteger) index;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
