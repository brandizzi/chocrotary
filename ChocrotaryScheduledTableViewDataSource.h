//
//  ChocrotaryScheduledTableViewDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChocrotaryBaseTableViewDataSource.h"
#import "ChocrotaryController.h"
#import "ChocrotarySecretaryPerspective.h"

@interface ChocrotaryScheduledTableViewDataSource : ChocrotaryBaseTableViewDataSource <ChocrotaryTableViewDataSource> {
	IBOutlet ChocrotaryController *controller;
}

@property (readonly) ChocrotaryController *controller;


- (id) initWithController:(ChocrotaryController*) c;
- (ChocrotarySecretaryPerspective*) secretaryPerspective;

@end
