//
//  STABook+BookSerialization.h
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STABook.h"

extern NSString *const kSTABookName;
extern NSString *const kSTABookYear;
extern NSString *const kSTABookCoverType;
extern NSString *const kSTABookOwner;
extern NSString *const kSTABookID;

@class STAVisitor;

@interface STABook (BookSerialization)

@property (copy, readwrite) NSString *bookName;
@property (readwrite) NSUInteger bookYear;
@property (readwrite) STABookType coverType;
@property (assign, readwrite) STAVisitor *owner;
@property (retain, readonly) NSUUID *ID;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;

@end