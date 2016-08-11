//
//  STABookEditWindow.m
//  Exercise7
//
//  Created by Иван Ткаченко on 8/10/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STABookEditWindow.h"
#import "STABook.h"
#import "STAModelController.h"
#import "STAServerSessionManager.h"

@interface STABookEditWindow ()


@property (atomic, readwrite, retain) STABook *bookToEdit;

@property (atomic, readwrite, retain) NSAttributedString *textToTranslate;
@property (atomic, readwrite, retain) NSAttributedString *textTranslated;

@property (atomic, readwrite, retain) STAModelController *model;
@property (atomic, readwrite, assign) NSMutableArray<NSMenuItem *> *arrayOfTypeCoverItems;
@property (atomic, readwrite, assign) IBOutlet NSTextField *bookYearTextField;
@property (atomic, readwrite, assign) IBOutlet NSTextView *textView;
@property (atomic, readwrite, assign) IBOutlet NSTextView *translatedTextView;
@property (atomic, readwrite, assign) IBOutlet NSPopUpButton *languagesButton;
@property (atomic, readwrite, assign) IBOutlet NSPopUpButton *languagesToTranslate;
@property (atomic, readwrite, assign) STAServerSessionManager *server;
@property (atomic, readwrite, copy) NSDictionary *languagesDictionary;

@end

@implementation STABookEditWindow

- (void)windowDidLoad
{
    NSLog(@"Feel menu");
    [super windowDidLoad];
    [self.arrayOfTypeCoverItems removeAllObjects];
    [self.arrayOfTypeCoverItems addObject:[[NSMenuItem alloc] initWithTitle:@"Undefined" action:nil keyEquivalent:@""]];
    [self.arrayOfTypeCoverItems addObject:[[NSMenuItem alloc] initWithTitle:@"Papercover" action:nil keyEquivalent:@""]];
    [self.arrayOfTypeCoverItems addObject:[[NSMenuItem alloc] initWithTitle:@"Hardcover" action:nil keyEquivalent:@""]];
    [self.bookYearTextField setStringValue:[NSString stringWithFormat:@"%ld", self.bookToEdit.bookYear]];
    
    [self.server getListOfLanguages:^(NSDictionary *request)
    {
        self.languagesDictionary = [[request objectForKey:@"langs"] copy];
        [self.languagesButton removeAllItems];
        [[request objectForKey:@"langs"] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *obj, BOOL * _Nonnull stop) {
            [self.languagesButton addItemWithTitle:obj];
            [self.languagesToTranslate addItemWithTitle:obj];
        }];
    }];
}

- (instancetype)initWithWindowNibName:(NSString *)windowNibName bookToEdit:(STABook *)book model:(STAModelController *)model;
{
    self = [super initWithWindowNibName:@"STABookEditWindow"];
    if (self)
    {
        _bookToEdit = [book retain];
        _model = [model retain];
        _arrayOfTypeCoverItems = [NSMutableArray<NSMenuItem *> new];
        _server = [STAServerSessionManager new];
        _languagesDictionary = [NSDictionary new];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:NSTextDidEndEditingNotification object:nil];
    return self;
}

- (NSString *)windowNibName
{
    return @"STABookEditWindow";
}

- (BOOL)isEqual:(id)other
{
    BOOL result = NO;
    if ([other isKindOfClass:[self class]])
    {
        STABookEditWindow *windowController = (STABookEditWindow *)other;
        if ([windowController.bookToEdit isEqual:self.bookToEdit])
        {
            result = YES;
        }
    }
    return result;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{    NSLog(@"text view changed");
    self.bookToEdit.bookYear = [fieldEditor.string integerValue];
    return YES;
}
- (IBAction)setLanguage:(NSPopUpButton *)sender
{
    NSLog(@"%@", sender.titleOfSelectedItem);
}

- (IBAction)detectLanguage:(NSButton *)button
{
    [self.server languageDetect:^(NSDictionary *text)
     {
         if ([[text objectForKey:@"code"] integerValue] == 200)
         {
             [self.languagesDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *obj, BOOL * _Nonnull stop)
              {
                  if ([key isEqualToString:[text objectForKey:@"lang"]])
                  {
                      [self.languagesButton selectItemWithTitle:obj];
                  }
              }];
         }
     } textToDetect:[self.textView string]];
}

- (IBAction)tramslateLanguage:(NSButton *)sender
{
    __block NSString *translateDirection;
    [self.languagesDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *obj, BOOL * _Nonnull stop)
    {
        if ([self.languagesToTranslate.titleOfSelectedItem isEqualToString:obj])
        {
            translateDirection = [key copy];
        }
    }];
    NSLog(@"%@", [self.textView string]);
    [self.server translateText:^(NSDictionary *dictionary)
    {
        NSString *string = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"text"]];
        NSLog(@"%@", [[dictionary objectForKey:@"text"] class]);
        NSError *error = nil;
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:[dictionary objectForKey:@"text"] options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"%@", data);
        
        id object = [NSJSONSerialization JSONObjectWithData:data options:0
                                                   error:&error];
        if (!error)
        {
            NSLog(@"object %@", [object class]);
        }
        
        NSAttributedString *attrstring = [[NSAttributedString alloc] initWithString:string];
        NSLog(@"Translated %@", string);
        [self.translatedTextView setString:@"Hello"];
        [self.translatedTextView.textStorage setAttributedString:attrstring];
    } textToTranslate:[self.textView string] translationDirection:@"ru"];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
}

- (NSUInteger)hash
{
    return self.bookToEdit.hash;
}



- (void)dealloc
{
    [_bookToEdit release];
    [_model release];
    [super dealloc];
}

@end