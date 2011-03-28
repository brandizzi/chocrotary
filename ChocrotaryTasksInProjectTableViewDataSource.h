//
//  ChocrotaryTasksInProjectTableViewDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 27/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryBaseTableViewDataSource.h"

@interface ChocrotaryTasksInProjectTableViewDataSource : 
ChocrotaryBaseTableViewDataSource <ChocrotaryTableViewDataSource> {
	IBOutlet ChocrotaryController *controller;
	IBOutlet ChocrotaryProject *project;
}

@property (readonly) ChocrotaryController *controller;
@property (readwrite,assign) ChocrotaryProject *project;

- (id) initWithController:(ChocrotaryController*) c;
- (ChocrotarySecretaryView*) secretaryView;

@end
