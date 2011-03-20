//
//  ChocrotaryProjectTableViewDelegate.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryController.h"

@interface ChocrotaryProjectTableViewDelegate : NSObject <NSTableViewDelegate> {
	IBOutlet ChocrotaryController *controller;
	IBOutlet NSTableView *tableView;
}

@property (readwrite,assign) ChocrotaryController *controller;
@property (readwrite,assign) NSTableView *tableView;

- (void)tableViewSelectionDidChange:(NSNotification *)notification;

@end
