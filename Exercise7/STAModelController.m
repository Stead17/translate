//
//  STAModelController.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAModelController.h"
//#import "STALibrary+LibrarySerialization.h"
#import "STABook+BookSerialization.h"
#import "STAVisitor+VisitorSerialization.h"

NSString *const kFILEPATHREADERS = @"/Users/stead/Developer/Obj-C/Exercise7/readers.json";
NSString *const kFILEPATHBOOKS = @"/Users/stead/Developer/Obj-C/Exercise7/books.json";
NSString *const kNotificationModelVisitorDidAdded = @"Visitor added to library";
NSString *const kNotificationModelVisitorDidRemoved = @"Visitor from from library";
NSString *const kNotificationModelBookDidAdded = @"Book added to library";
NSString *const kNotificationModelBookDidRemoved = @"Book removed from library";

@interface STAModelController()
{
@private
    NSMutableArray<STABook *> *_listOfBooks;
    NSMutableArray<STAVisitor *> *_listOfVisitors;
}

@property(retain, readwrite) NSMutableArray<STABook *> *mListOfBooks;
@property(retain, readwrite) NSMutableArray<STAVisitor *> *mListOfVisitors;

@end

@implementation STAModelController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _listOfBooks = [[NSMutableArray alloc] init];
        _listOfVisitors = [[NSMutableArray alloc] init];
    }
    return self;
}

// MARK: Work on file writting
- (BOOL)writeToFile
{
    BOOL result = NO;
    if (self.listOfBooks)
    {
        NSData *json = [NSJSONSerialization dataWithJSONObject:self.listOfBooks options:NSJSONWritingPrettyPrinted error:nil];
        NSString *stringData = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
        [[stringData dataUsingEncoding:NSUTF8StringEncoding] writeToFile:kFILEPATHBOOKS atomically:NO];
        [stringData release];
        result = YES;
    }
    if (self.listOfVisitors)
    {
        NSData *json = [NSJSONSerialization dataWithJSONObject:self.listOfVisitors options:NSJSONWritingPrettyPrinted error:nil];
        NSString *stringData = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
        [[stringData dataUsingEncoding:NSUTF8StringEncoding] writeToFile:kFILEPATHREADERS atomically:NO];
        [stringData release];
        result = YES;
    }
    
    return result;
}

- (BOOL)addBook:(STABook *)aBook
{
    BOOL result= NO;
    if (aBook && ![self.mListOfBooks containsObject:aBook])
    {
        [self.mListOfBooks addObject:aBook];
        result = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModelBookDidAdded object:self];
    }
    return result;
}
- (BOOL)removeBook:(STABook *)aBook
{
    BOOL result= NO;
    if (aBook && [self.listOfBooks containsObject:aBook])
    {
        [self.mListOfBooks removeObject:aBook];
        result = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModelBookDidRemoved object:self];
    }
    return result;
}

- (BOOL)addReader:(STAVisitor *)aVisitor
{
    BOOL result= NO;
    if (aVisitor && ![self.listOfVisitors containsObject:aVisitor])
    {   
        [self.mListOfVisitors addObject:aVisitor];
        for (STABook *book in aVisitor.visitorBooks)
        {
            [self addBook:book];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModelVisitorDidAdded object:self];
        result = YES;
    }
    return result;
}
- (BOOL)removeReader:(STAVisitor *)aVisitor
{
    BOOL result= NO;
    if (aVisitor && [self.listOfVisitors containsObject:aVisitor])
    {
        for (STABook *book in aVisitor.visitorBooks)
        {
            book.owner = nil;
        }
        [self.mListOfVisitors removeObject:aVisitor];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModelVisitorDidRemoved object:self];
        result = YES;
    }
    return result;
}

// Must have methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nLIST OF BOOKS%@\nLIST OF READERS%@", self.listOfBooks,self.listOfVisitors];
}

- (NSArray *)listOfBooks
{
    return self.mListOfBooks;
}
- (NSMutableArray *)mListOfBooks
{
    return _listOfBooks;
}
- (void)setMListOfBooks:(NSMutableArray *)mListOfBooks
{
    if (_listOfBooks != mListOfBooks)
    {
        [_listOfBooks release];
        _listOfBooks = [mListOfBooks retain];
    }
}

- (NSArray *)listOfVisitors
{
    return self.mListOfVisitors;
}
- (NSMutableArray *)mListOfVisitors
{
    return _listOfVisitors;
}
- (void)setMListOfVisitors:(NSMutableArray *)mListOfVisitors
{
    if(_listOfVisitors != mListOfVisitors)
    {
        [_listOfVisitors release];
        _listOfVisitors = [_listOfVisitors retain];
    }
}

- (void)dealloc
{
    [_listOfVisitors release];
    [_listOfBooks release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object
{
    BOOL result= NO;
    if ([object isKindOfClass:[STAModelController class]])
    {
        if ([self.listOfBooks isEqualToArray:[object listOfBooks]] && [self.listOfVisitors isEqualToArray:[object listOfVisitors]])
        {
            result = YES;
        }
    }
    return result;
}

- (NSUInteger)hash
{
    return self.listOfBooks.hash ^ self.listOfVisitors.hash;
}
@end