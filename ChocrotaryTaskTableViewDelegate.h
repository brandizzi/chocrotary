//
//  ChocrotaryTaskTableViewDelegate.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryController.h"

@interface ChocrotaryTaskTableViewDelegate : NSObject <NSTableViewDelegate> {
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell 
   forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
