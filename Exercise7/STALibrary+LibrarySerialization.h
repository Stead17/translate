//
//  STALibrary+LibrarySerialization.h
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAModelController.h"

extern NSString *const kSTAListOfBooks;
extern NSString *const kSTAListOfReaders;

@class STABook, STAReader;

@interface STAModelController (ModelControllerSerialization)

@property(copy, readonly) NSArray *listOfBooks;
@property(copy, readonly) NSArray *listOfReaders;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;

@end
