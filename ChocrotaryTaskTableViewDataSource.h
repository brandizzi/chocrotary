//
//  ChocrotaryTaskTableViewDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 06/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryController.h"
#import "ChocrotarySecretaryPerspective.h"

#define ChocrotaryTaskTableColumnDone @"done"
#define ChocrotaryTaskTableColumnDescription @"description"
#define ChocrotaryTaskTableColumnProject @"project"
#define ChocrotaryTaskTableColumnScheduled @"scheduled"

@interface ChocrotaryTaskTableViewDataSource : NSObject <NSTableViewDataSource> {
	ChocrotaryController *controller;
	ChocrotarySecretaryPerspective *perspective;
}

@property (readwrite,assign) ChocrotaryController *controller;
@property (readwrite,assign) ChocrotarySecretaryPerspective *perspective;

+(id)new;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;


@end
