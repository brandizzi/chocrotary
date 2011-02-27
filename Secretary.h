//
//  Secretary.h
//  chocrotary
//
//  Created by Adam Victor Nazareth Brandizzi on 26/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Secretary : NSObject {

}

- Secretary *secretary_new();
Task *secretary_appoint(Secretary *secretary, const char* description);
#define secretary_count_task(secretary) ((secretary)->task_count)
Task *secretary_get_task(Secretary *secretary, int number);
#define secretary_get_nth_task(secretary, n) ((secretary)->tasks[n])

int secretary_count_inbox(Secretary *secretary);
Task *secretary_get_nth_inbox_task(Secretary *secretary, int n);

Project *secretary_start(Secretary *secretary, const char* name);
#define secretary_count_project(secretary) ((secretary)->project_count)
Project *secretary_get_project(Secretary *secretary, const char *name);
#define secretary_get_nth_project(secretary, n) \
(((secretary)->project_count > (n))? ((secretary)->projects[n]) : NULL)

void secretary_move(Secretary *secretary, Task *task, Project *project);
void secretary_move_to_inbox(Secretary *secretary, Task *task);

void secretary_delete_task(Secretary *secretary, Task *task);
void secretary_delete_project(Secretary *secretary, Project *project);

void secretary_schedule(Secretary *secretary, Task *task, struct tm date);
int secretary_count_scheduled(Secretary *secretary);
int secretary_count_scheduled_for(Secretary *secretary, struct tm date);
int secretary_count_scheduled_for_today(Secretary *secretary);
Task *secretary_get_nth_scheduled(Secretary *secretary, int n);
Task *secretary_get_nth_scheduled_for(Secretary *secretary, struct tm date, int n);
Task *secretary_get_nth_scheduled_for_today(Secretary *secretary, int n);
void secretary_unschedule(Secretary *secretary, Task *task);

#define secretary_do(secretary, task) (task_mark_as_done(task))
#define secretary_undo(secretary, task) (task_unmark_as_done(task))
int secretary_count_done_tasks(Secretary *secretary);
Task *secretary_get_nth_done_task(Secretary *secretary, int n);

void secretary_free(Secretary *secretary);

#define secretary_count_area(secretary) 0


@end
