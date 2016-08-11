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
{
    self.bookToEdit.bookYear = [fieldEditor.string integerValue];
    return YES;
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
    [self.languagesDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop)
    {
        if ([self.languagesToTranslate.titleOfSelectedItem isEqualToString:obj])
        {
            translateDirection = [key copy];
        }
    }];
    [self.server translateText:^(NSDictionary *dictionary)
    {
        NSString *resultText = [NSArray arrayWithArray:[dictionary objectForKey:@"text"]][0];
        
        [self.translatedTextView setString:@""];
        
        __block NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:resultText];
        [self.textView.attributedString enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop)
        {
            [attributedString addAttributes:attrs range:range];
        }];
        
        [self.translatedTextView.textStorage setAttributedString:attributedString];
        
    } textToTranslate:self.textView.string translationDirection:translateDirection];
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