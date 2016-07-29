//
//  STALibraryViewController.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/23/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STALibraryViewController.h"
#import "STAModelController.h"
#import "STAWindowController.h"
#import "STAVisitor.h"
#import "STABook.h"
#import "STAVisitor+VisitorSerialization.h"
#import "STACustomTableCellView.h"

NSString *const kVisitorsTableViewIdentifier = @"visitorsTableView";
NSString *const kNameTableColumnIdentifier = @"visitorNameTableColumn";
NSString *const kSurnameTableColumnIdentifier = @"visitorSurnameTableColumn";
NSString *const kYearTableColumnIdentifier = @"visitorYearTableColumn";

NSString *const kBooksTableViewIdentifier = @"booksTableView";
NSString *const kTitleTableColumnIdentifier = @"bookTitleTableColumn";
NSString *const kBookYearTableColumnIdentifier = @"bookYearTableColumn";
NSString *const kTypeTableColumnIdentifier = @"bookTypeTableColumn";
NSString *const kOwnerTableColumnIdentifier = @"bookOwnerTableColumn";

@class STAAppDelegate;

@interface STALibraryViewController () <NSTabViewDelegate, NSTableViewDataSource, NSTextFieldDelegate>
{
@private
    NSTableView *_visitorsTableView;
    NSTableView *_booksTableView;
    STAModelController *_modelController;
    NSMutableArray *_windowControllersArray;
}

@property (nonatomic, assign) IBOutlet NSTableView *visitorsTableView;
@property (nonatomic, assign) IBOutlet NSTableView *booksTableView;
@property (nonatomic, retain) STAModelController *modelController;
@property (nonatomic, retain) NSMutableArray *windowControllersArray;


@end

@implementation STALibraryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(STAModelController *)model
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _modelController = [model retain];
    }
    // Notification from visitor
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationVisitorNameDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationVisitorSurnameDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationVisitorBirthYearDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationVisitorBooksDidChanged object:nil];
    
    // Notification from book
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationBookNameDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationBookYearDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationBookCoverTypeDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationBookOwnerDidChange object:nil];
    
    // Notification from window
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowClosed:) name:NSWindowWillCloseNotification object:nil];

    // Notification from library
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationModelBookDidAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationModelBookDidRemoved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationModelVisitorDidAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView:) name:kNotificationModelVisitorDidRemoved object:nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if ([tableView.identifier isEqualToString:kVisitorsTableViewIdentifier])
    {
        return self.modelController.listOfVisitors.count;
    }
    else if ([tableView.identifier isEqualToString:kBooksTableViewIdentifier])
    {
        return self.modelController.listOfBooks.count;
    }
    
    return 0;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    NSView *nameCell = nil;
    STAVisitor *visitor = nil;
    STABook *book = nil;
    
    if ([[tableView identifier] isEqualToString:kVisitorsTableViewIdentifier])
    {
        visitor = self.modelController.listOfVisitors[row];
        if ([identifier isEqualToString:kNameTableColumnIdentifier])
        {
            nameCell = [tableView makeViewWithIdentifier:kNameTableColumnIdentifier owner:self];
            if (visitor.name)
            {
                ((NSTableCellView *)nameCell).textField.stringValue = visitor.name;
            }
            else
            {
                ((NSTableCellView *)nameCell).textField.stringValue = @"";
            }
        }
        else if ([identifier isEqualToString:kSurnameTableColumnIdentifier])
        {
            nameCell = [tableView makeViewWithIdentifier:kSurnameTableColumnIdentifier owner:self];
            if (visitor.surname)
            {
                ((NSTableCellView *)nameCell).textField.stringValue = visitor.surname;
            }
            else
            {
                ((NSTableCellView *)nameCell).textField.stringValue = @"";
            }
        }
        else if ([identifier isEqualToString:kYearTableColumnIdentifier])
        {
            nameCell = [tableView makeViewWithIdentifier:kYearTableColumnIdentifier owner:self];
            if (visitor.birthYear)
            {
                ((NSTableCellView *)nameCell).textField.stringValue = [NSString stringWithFormat:@"%ld", visitor.birthYear];
            }
            else
            {
                ((NSTableCellView *)nameCell).textField.stringValue = @"";
            }
        }
    }
    else if ([[tableView identifier] isEqualToString:kBooksTableViewIdentifier])
    {
        book = self.modelController.listOfBooks[row];
        if ([identifier isEqualToString:kTitleTableColumnIdentifier])
        {
            nameCell = [tableView makeViewWithIdentifier:kTitleTableColumnIdentifier owner:self];
            if (book.bookName)
            {
                ((NSTableCellView *)nameCell).textField.stringValue = book.bookName;
            }
            else
            {
                ((NSTableCellView *)nameCell).textField.stringValue = @"";
            }
        }
        else if ([identifier isEqualToString:kBookYearTableColumnIdentifier])
        {
            nameCell = [tableView makeViewWithIdentifier:kBookYearTableColumnIdentifier owner:self];
            if (book.bookYear)
            {
                ((NSTableCellView *)nameCell).textField.stringValue = [NSString stringWithFormat:@"%ld", book.bookYear];
            }
            else
            {
                ((NSTableCellView *)nameCell).textField.stringValue = @"";
            }
        }
        else if ([identifier isEqualToString:kTypeTableColumnIdentifier])
        {
            nameCell = [tableView makeViewWithIdentifier:kTypeTableColumnIdentifier owner:self];
            [((STACustomTableCellView *)nameCell).popUpButton removeAllItems];
            [((STACustomTableCellView *)nameCell).popUpButton addItemsWithTitles:[NSArray arrayWithObjects:@"Undefined", @"Paperback", @"Hardcover", nil]];
            NSString *type;
            
            NSInteger coverType = book.coverType;
            if (coverType == kSTABookTypePaperCover)
            {
                type = @"Paperback";
            }
            else if(coverType == kSTABookTypeHardCover)
            {
                type = @"Hardcover";
            }
            else
            {
                type = @"Undefined";
            }
            
            [((STACustomTableCellView *)nameCell).popUpButton selectItemWithTitle:type];
            [type release];
        }
        else if ([identifier isEqualToString:kOwnerTableColumnIdentifier])
        {
            nameCell = [tableView makeViewWithIdentifier:kOwnerTableColumnIdentifier owner:self];
            if (!book.owner)
            {
                ((NSTableCellView *)nameCell).textField.stringValue = [NSString stringWithFormat:@"No info"];
            }
            else
            {
                ((NSTableCellView *)nameCell).textField.stringValue = [NSString stringWithFormat:@"%@", book.owner.fullName];
            }
        }
    }
    visitor = nil;
    book = nil;
    return nameCell;
}

// MARK: Check for control typecasting
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSInteger row = [self.visitorsTableView rowForView:control.superview];
    NSInteger rowTwo = [self.booksTableView rowForView:control.superview];
    if (row != -1)
    {
        if ([[control identifier] isEqualToString:kNameTableColumnIdentifier])
        {
            self.modelController.listOfVisitors[row].name = fieldEditor.string;
        }
        else if ([[control identifier] isEqualToString:kSurnameTableColumnIdentifier])
        {
            self.modelController.listOfVisitors[row].surname = fieldEditor.string;
        }
        else if ([[control identifier] isEqualToString:kYearTableColumnIdentifier])
        {
            self.modelController.listOfVisitors[row].birthYear = [fieldEditor.string integerValue];
        }
    }
    else if (rowTwo != -1)
    {
        if ([[control identifier] isEqualToString:kTitleTableColumnIdentifier])
        {
            self.modelController.listOfBooks[rowTwo].bookName = fieldEditor.string;
        }
        else if ([[control identifier] isEqualToString:kBookYearTableColumnIdentifier])
        {
            self.modelController.listOfBooks[rowTwo].bookYear = [fieldEditor.string integerValue];
        }
    }
    
    return YES;
}

-(void)reloadView:(NSNotification *)notification
{
    NSLog(@"Notification %@", notification.name);
    if ([notification.name isEqualToString:kNotificationVisitorNameDidChanged])
    {
        [self.booksTableView reloadData];
        [self.visitorsTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationVisitorSurnameDidChanged])
    {
        [self.booksTableView reloadData];
        [self.visitorsTableView reloadData];
        
    }
    else if ([notification.name isEqualToString:kNotificationVisitorBirthYearDidChanged])
    {
        [self.visitorsTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationVisitorBooksDidChanged])
    {
        [self.booksTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationBookNameDidChange])
    {
        [self.booksTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationBookCoverTypeDidChange])
    {
        [self.booksTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationBookOwnerDidChange])
    {
        [self.booksTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationBookYearDidChange])
    {
        [self.booksTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationModelBookDidAdded])
    {
        [self.booksTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationModelBookDidRemoved])
    {
        [self.booksTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationModelVisitorDidAdded])
    {
        [self.visitorsTableView reloadData];
        [self.booksTableView reloadData];
    }
    else if ([notification.name isEqualToString:kNotificationModelVisitorDidRemoved])
    {
        [self.visitorsTableView reloadData];
        [self.booksTableView reloadData];
    }
}


- (IBAction)reactionOnDoubleClick:(id)sender
{
    if ([sender isKindOfClass:[NSTableView class]])
    {
        NSTableView *table = (NSTableView *)sender;
        if (table.clickedRow != -1 && table.clickedColumn != -1)
        {
            [self newWindowController:self.modelController.listOfVisitors[table.clickedRow]];
        }
    }
    
}
- (IBAction)changeCoverType:(NSPopUpButton *)sender
{
    NSInteger row = [self.booksTableView rowForView:sender.superview];
    if (row != -1)
    {
        self.modelController.listOfBooks[row].coverType = sender.indexOfSelectedItem;
    }
}
- (IBAction)addVisitor:(NSButton *)sender
{
    NSLog(@"Add Visitor");
    STAVisitor *vstr = [STAVisitor new];
    [self.modelController addReader:vstr];
    [vstr release];
}

- (IBAction)deleteVisitor:(NSButton *)sender
{
    NSInteger row = [self.visitorsTableView selectedRow];
    if (row != -1)
    {
        [self.modelController removeReader:self.modelController.listOfVisitors[row]];
    }
}

- (IBAction)addBook:(NSButton *)sender
{
    STABook *bk = [STABook new];
    [self.modelController addBook:bk];
    [bk release];
}

- (IBAction)deleteBook:(NSButton *)sender
{
    NSInteger row = [self.booksTableView selectedRow];
    if (row != -1)
    {
        [self.modelController removeBook:self.modelController.listOfBooks[row]];
    }
}

- (void)newWindowController:(STAVisitor *)visitor
{
    STAWindowController *windowController = [[STAWindowController alloc] initWithWindowNibName:@"STAWindowController" visitorForTable:visitor modelToChange:self.modelController];
    if (self.windowControllersArray == nil)
    {
        self.windowControllersArray = [[NSMutableArray alloc] init];
        
    }
    if ([self arrayContent:visitor])
    {
        [self.windowControllersArray addObject:windowController];
    }
    [windowController showWindow:self];
    [windowController release];
}

- (void)windowClosed:(NSNotification *)note
{
    NSWindow *window = [note object];
    for (NSWindowController *winController in self.windowControllersArray)
    {
        if (winController.window == window)
        {
            [[winController retain] autorelease]; // Keeps the instance alive a little longer so things can unbind from it
            [self.windowControllersArray removeObject:winController];
            break;
        }
    }
}

- (BOOL)arrayContent:(STAVisitor *)visitor
{
    BOOL result = YES;
    NSArray *array = self.windowControllersArray;
    for (int i = 0; i < array.count; i++)
    {
        if ([[[array objectAtIndex:i] visitor] isEqualTo:visitor])
        {
            result = NO;
            break;
        }
    }
    
    array = nil;
    return result;
}

- (STAModelController *)modelController
{
    return _modelController;
}
- (NSMutableArray *)windowControllersArray
{
    return _windowControllersArray;
}
- (NSTableView *)visitorsTableView
{
    return _visitorsTableView;
}
- (NSTableView *)booksTableView
{
    return _booksTableView;
}

- (void)setModelController:(STAModelController *)modelController
{
    if (_modelController != modelController)
    {
        [_modelController release];
        _modelController = [modelController retain];
    }
}
- (void)setWindowControllersArray:(NSMutableArray *)windowControllersArray
{
    if (_windowControllersArray != windowControllersArray)
    {
        [_windowControllersArray release];
        _windowControllersArray = [windowControllersArray retain];
    }
}
- (void)setVisitorsTableView:(NSTableView *)visitorsTableView
{
    _visitorsTableView = visitorsTableView;
}
- (void)setBooksTableView:(NSTableView *)booksTableView
{
    _booksTableView = booksTableView;
}

- (void)dealloc
{
    [_modelController release];
    [_windowControllersArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationVisitorNameDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationVisitorSurnameDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationVisitorBirthYearDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationVisitorBooksDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBookNameDidChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBookYearDidChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBookCoverTypeDidChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBookOwnerDidChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationModelVisitorDidAdded object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationModelVisitorDidRemoved object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationModelBookDidAdded object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationModelBookDidRemoved object:nil];
    [super dealloc];
}

@end