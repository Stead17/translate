//
//  STALibrary+LibrarySerialization.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STALibrary+LibrarySerialization.h"
#import "STAVisitor+VisitorSerialization.h"
#import "STABook+BookSerialization.h"

NSString *const kSTAListOfBooks = @"kSTAListOfBooks";
NSString *const kSTAListOfReaders = @"kSTAListOfReaders";

@interface STAModelController()

@property(copy, readwrite) NSArray *listOfBooks;
@property(copy, readwrite) NSArray *listOfReaders;

@end

@implementation STAModelController (LibrarySerialization)

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary
{
    self = [self init];
    if(self)
    {
        for (NSDictionary *obj in aDictionary[kSTAListOfBooks])
        {
            STABook *bookToAdd = [[STABook alloc] initWithDictionaryRepresentation:obj];
            [self addBook:bookToAdd];
            [bookToAdd release];
        }
        for (NSDictionary *obj in aDictionary[kSTAListOfReaders])
        {
            STAVisitor *readerToAdd = [[STAVisitor alloc] initWithDictionaryRepresentation:obj];
            [self addReader:readerToAdd];
            [readerToAdd release];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.listOfBooks)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:self.listOfBooks.count];
        for (NSDictionary *obj in self.listOfBooks)
        {
            [arr addObject:obj];
        }
        dict[kSTAListOfBooks] = arr;
        [arr release];
    }
    if (self.listOfReaders)
    {
        NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:self.listOfReaders.count];
        for (NSDictionary *obj in self.listOfReaders)
        {
            [arr1 addObject:obj];
        }
        dict[kSTAListOfReaders] = arr1;
        [arr1 release];
    }
    return dict;
}

@end