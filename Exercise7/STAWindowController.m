//
//  STAWindowController.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/26/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAWindowController.h"
#import "STAModelController.h"
#import "STAVisitor.h"
#import "STABook.h"
#import "STACustomTableCellView.h"

NSString *const kTitleColumnIdentifier = @"titleTableColumn";
NSString *const kYearColumnIdentifier = @"publishedYearTableColumn";
NSString *const kCoverTypeColumnIdentifier = @"typeTableColumn";
NSString *const kOwnerColumnIdentifier = @"ownerTableColumn";

NSString *const kNameVisitorTextField = @"nameTextField";
NSString *const kSurnameVisitorTextField = @"surnameTextField";
NSString *const kYearVisitorTextField = @"yearTextField";

NSString *const kGiveBackButtonState = @"Give back";
NSString *const kTakeButtonState = @"Take";
NSString *const kOwnedButtonState = @"Owned by";

@interface STAWindowController () <NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate, NSTextFieldDelegate>
{
    STAModelController *_modelController;
    STAVisitor *_visitor;
    
    NSTableView *_visitorEditorTable;
    NSTextField *_nameTextField;
    NSTextField *_surnameTextField;
    NSTextField *_yearTextField;
}

@property (assign) IBOutlet NSTableView *visitorEditorTable;

@property (assign) IBOutlet NSTextField *nameTextField;
@property (assign) IBOutlet NSTextField *surnameTextField;
@property (assign) IBOutlet NSTextField *yearTextField;

@property (nonatomic, retain) STAModelController *modelController;

@end

@implementation STAWindowController


- (instancetype)initWithWindowNibName:(NSString *)windowNibName visitorForTable:(STAVisitor *)visitor modelToChange:(STAModelController *)model
{
    self = [super initWithWindowNibName:windowNibName];
    if (self)
    {
        _visitor = [visitor retain];
        _modelController = [model retain];
    }
    
    // Notification from visitor
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationVisitorNameDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationVisitorSurnameDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationVisitorBirthYearDidChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationVisitorBooksDidChanged object:nil];
    
    // Notification from book
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationBookNameDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationBookYearDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationBookCoverTypeDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationBookOwnerDidChange object:nil];
    
    // Notification from library
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationModelBookDidAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationModelBookDidRemoved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationModelVisitorDidAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kNotificationModelVisitorDidRemoved object:nil];
    
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.modelController.listOfBooks.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cell = nil;
    STACustomTableCellView *customCell = nil;
    NSString *identifier = tableColumn.identifier;
    NSArray<STABook *> *booksArray = self.modelController.listOfBooks;
    
    if (self.visitor != nil)
    {
        STAVisitor *vstr = self.visitor;
        if (vstr.name)
        {
            self.nameTextField.stringValue = vstr.name;
        }
        if (vstr.surname)
        {
            self.surnameTextField.stringValue = vstr.surname;
        }
        if (vstr.birthYear)
        {
            self.yearTextField.stringValue = [NSString stringWithFormat:@"%ld", vstr.birthYear];
        }
    }
    
    if ([identifier isEqualToString:kTitleColumnIdentifier])
    {
        cell = [tableView makeViewWithIdentifier:kTitleColumnIdentifier owner:self];
        if (booksArray[row].bookName)
        {
            cell.textField.stringValue = booksArray[row].bookName;
        }
    }
    else if ([identifier isEqualToString:kYearColumnIdentifier])
    {
        cell = [tableView makeViewWithIdentifier:kYearColumnIdentifier owner:self];
        if (booksArray[row].bookYear)
        {
            cell.textField.stringValue = [NSString stringWithFormat:@"%ld", booksArray[row].bookYear];
        }
    }
    else if ([identifier isEqualToString:kCoverTypeColumnIdentifier])
    {
        cell = [tableView makeViewWithIdentifier:kCoverTypeColumnIdentifier owner:self];
        
        [((STACustomTableCellView *)cell).popUpButton removeAllItems];
        [((STACustomTableCellView *)cell).popUpButton addItemsWithTitles:[NSArray arrayWithObjects:@"Undefined", @"Paperback", @"Hardcover", nil]];
        NSString *type = nil;
        
        NSInteger coverType = booksArray[row].coverType;
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
        
        [((STACustomTableCellView *)cell).popUpButton selectItemWithTitle:type];
        [type release];
        
    }
    if ([identifier isEqualToString:kOwnerColumnIdentifier])
    {
        customCell = [tableView makeViewWithIdentifier:kOwnerColumnIdentifier owner:self];
        if (booksArray[row].owner != nil)
        {
            customCell.button.title = kGiveBackButtonState;
            if (booksArray[row].owner.name == self.visitor.name)
            {
                [customCell.button setEnabled:YES];
                customCell.button.state = NSOffState;
            }
            else
            {
                customCell.button.title = [NSString stringWithFormat:@"%@ %@", kOwnedButtonState, booksArray[row].owner.fullName];
                [customCell.button setEnabled:NO];
            }
        }
        else
        {
            customCell.button.title = kTakeButtonState;
            [customCell.button setEnabled:YES];
            customCell.button.state = NSOnState;
        }
        return customCell;
    }
    
    return cell;
}

// MARK: Check for control typecasting
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSString *string = [control identifier];
    NSInteger row = [self.visitorEditorTable rowForView:control.superview];
    if (row != -1)
    {
        if ([string isEqualToString:kTitleColumnIdentifier])
        {
            self.modelController.listOfBooks[row].bookName = fieldEditor.string;
        }
        else if ([string isEqualToString:kYearColumnIdentifier])
        {
            self.modelController.listOfBooks[row].bookYear = [fieldEditor.string integerValue];
        }
        else if ([string isEqualToString:kCoverTypeColumnIdentifier])
        {
            self.modelController.listOfBooks[row].coverType = [fieldEditor.string integerValue];
        }
    }
    if ([string isEqualToString:kNameVisitorTextField])
    {
        self.visitor.name = fieldEditor.string;
    }
    else if ([string isEqualToString:kSurnameVisitorTextField])
    {
        self.visitor.surname = fieldEditor.string;
    }
    else if ([string isEqualToString:kYearVisitorTextField])
    {
        self.visitor.birthYear = [fieldEditor.string integerValue];
    }
    
    return YES;
}

- (void)reloadTableView:(NSNotification *)aNotification
{
    NSLog(@"Window %@", aNotification.name);
    if ([aNotification.name isEqualToString:kNotificationModelVisitorDidRemoved])
    {
        if (![self.modelController.listOfVisitors containsObject:self.visitor])
        {
            [self.window close];
        }
    }
    [self.visitorEditorTable reloadData];
}

- (IBAction)changeCoverType:(NSPopUpButton *)sender
{
    NSInteger row = [self.visitorEditorTable rowForView:sender.superview];
    if (row != -1)
    {
        self.modelController.listOfBooks[row].coverType = sender.indexOfSelectedItem;
    }
}

- (IBAction)changeOwnerShip:(NSButton *)sender
{
    if ([sender isKindOfClass:[NSButton class]])
    {
        NSButton *btn = (NSButton *)sender;
        NSInteger row = [self.visitorEditorTable rowForView:sender.superview];
        if (btn.state == NSOffState)
        {
            self.modelController.listOfBooks[row].owner = self.visitor;
            [self.visitor takeBook:self.modelController.listOfBooks[row]];
        }
        else if (btn.state == NSOnState)
        {
            self.modelController.listOfBooks[row].owner = nil;
            [self.visitor returnBook:self.modelController.listOfBooks[row]];
        }
    }
}

- (STAModelController *)modelController
{
    return _modelController;
}
- (STAVisitor *)visitor
{
    return _visitor;
}
- (NSTableView *)visitorEditorTable
{
    return _visitorEditorTable;
}
- (NSTextField *)nameTextField
{
    return _nameTextField;
}
- (NSTextField *)surnameTextField
{
    return _surnameTextField;
}
- (NSTextField *)yearTextField
{
    return _yearTextField;
}

- (void)setModelController:(STAModelController *)modelController
{
    if (_modelController != modelController)
    {
        [_modelController release];
        _modelController = [modelController retain];
    }
}
- (void)setVisitor:(STAVisitor *)visitor
{
    if (_visitor != visitor)
    {
        [_visitor release];
        _visitor = [visitor retain];
    }
}
- (void)setVisitorEditorTable:(NSTableView *)visitorEditorTable
{
    _visitorEditorTable = visitorEditorTable;
}
- (void)setNameTextField:(NSTextField *)nameTextField
{
    _nameTextField = nameTextField;
}
- (void)setSurnameTextField:(NSTextField *)surnameTextField
{
    _surnameTextField = surnameTextField;
}
- (void)setYearTextField:(NSTextField *)yearTextField
{
    _yearTextField = yearTextField;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}
- (void)dealloc
{
    [_modelController release];
    [_visitor release];
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