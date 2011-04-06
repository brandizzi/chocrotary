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

@interface ChocrotaryBaseTableViewDataSource : NSObject < ChocrotaryTableViewDataSource > {
}

-(id) controller;
-(ChocrotarySecretaryView*) secretaryView;
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
