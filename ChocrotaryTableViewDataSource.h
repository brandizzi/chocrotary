//
//  ChocrotaryTableViewDataSource.h
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ChocrotaryTableViewDataSource <NSTableViewDataSource>

-(NSInteger) numberOfColumns;
-(NSTableColumn *) getNthColumn:(NSInteger) index;


@end
