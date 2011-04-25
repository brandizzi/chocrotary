//
//  ChocrotaryBaseTableViewDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryTableViewDataSource.h"
#import "ChocrotaryController.h"

#define ChocrotaryTaskTableColumnDone @"done"
#define ChocrotaryTaskTableColumnDescription @"description"
#define ChocrotaryTaskTableColumnProject @"project"
#define ChocrotaryTaskTableColumnScheduled @"scheduled"

@interface ChocrotaryBaseTableViewDataSource : NSObject < ChocrotaryTableViewDataSource > {
}

-(id) controller;
-(ChocrotarySecretaryPerspective*) secretaryPerspective;
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
