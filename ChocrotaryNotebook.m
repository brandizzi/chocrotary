/**
 * Secretary for Mac OS X (aka Chocrotary): a Objective-C-written, 
 * Cocoa-based todo list manager
 * Copyright (C) 2011  Adam Victor Nazareth Brandizzi <brandizzi@gmail.com>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * You can get the latest version of this file at 
 * http://bitbucket.org/brandizzi/chocrotary/
 */
//  ChocrotaryNotebook.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 11/03/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "ChocrotaryNotebook.h"


@implementation ChocrotaryNotebook 

@synthesize secretary;

-(id) init {
	NSString *executableName = [[[NSBundle mainBundle] infoDictionary] 
								objectForKey:@"CFBundleExecutable"];
	NSArray* paths = NSSearchPathForDirectoriesInDomains(
														 NSApplicationSupportDirectory,
														 NSUserDomainMask,
														 YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL isDirectory, exists;
	exists = [manager fileExistsAtPath:path isDirectory:&isDirectory];
	if (!exists || isDirectory) {
		if (!isDirectory) {
			[manager removeItemAtPath:path error:NULL];
		}
		[manager createDirectoryAtPath:path withIntermediateDirectories:YES 
							attributes:nil error:NULL];
	}
	
	notebook = notebook_new([[path stringByAppendingPathComponent:@"secretary.notebook"] UTF8String]);
	secretary = [[ChocrotarySecretary alloc] initWithSecretary:notebook_get_secretary(notebook)];
	return self;
}

-(id) initWithFile:(NSString*)filename {
	notebook = notebook_new([filename UTF8String]);
	secretary = [[ChocrotarySecretary alloc] initWithSecretary:notebook_get_secretary(notebook)];
	return self;
}
-(ChocrotarySecretary*) getSecretary {
	return secretary;
}
-(void)save {
	notebook_save(notebook);
}

@end
