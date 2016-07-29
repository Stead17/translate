//
//  AppDelegate.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/22/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAAppDelegate.h"
#import "STALibraryViewController.h"
#import "STAModelController.h"
#import "STABook.h"
#import "STAVisitor.h"

@interface STAAppDelegate ()
{
@private
    NSWindow *_window;
    STALibraryViewController *_library;
    STAModelController *_model;
    STAWindowController *_windowController;
    NSMutableArray *_windowControllerArray;
}

@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) STALibraryViewController *library;
@property (nonatomic, retain) STAModelController *model;

@end

@implementation STAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    STABook *book = [STABook bookWithName:@"Paol" bookYear:1897 bookType:2];
    STABook *book1 = [STABook bookWithName:@"Cat molly" bookYear:1812 bookType:1];
    STABook *book2 = [STABook bookWithName:@"Pokemon" bookYear:2002 bookType:2];
    
    STAVisitor *visitor = [STAVisitor  visitorWithName:@"Tim" visitorSurname:@"Pok" birthYear:1997];
    STAVisitor *visitor1 = [STAVisitor visitorWithName:@"John" visitorSurname:@"Travka" birthYear:2000];
    
    [visitor takeBook:book];
    [visitor takeBook:book1];
    [visitor1 takeBook:book2];
    
    STAModelController *model = [[STAModelController alloc] init];
    [model addReader:visitor];
    [model addReader:visitor1];
    
    self.model = model;
    [model release];
    
    STALibraryViewController *libr = [[STALibraryViewController alloc] initWithNibName:@"STALibraryViewController" bundle:nil model:self.model];
    
    self.library = libr;
    [libr release];
    
    [self.window setContentView:self.library.view];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)dealloc
{
    [_library release];
    [_model release];
    [super dealloc];
}

@end