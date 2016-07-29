//
//  STAVisitor+VisitorSerialization.h
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAVisitor.h"

extern NSString *const kSTAReaderName;
extern NSString *const kSTAReaderSurname;
extern NSString *const kSTABirthYear;
extern NSString *const kSTAFullName;
extern NSString *const kSTAVisitorBooks;

@class STABook;

@interface STAVisitor (VisitorSerialization)

@property (copy, readwrite) NSString *name;
@property (copy, readwrite) NSString *surname;
@property NSUInteger birthYear;
@property (copy, readonly) NSString *fullName;
@property (retain, readonly) NSMutableArray<STABook *> *visitorBooks;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;



@end