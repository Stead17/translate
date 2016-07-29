//
//  STAVisitor.h
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STABook;

extern NSString *const kNotificationVisitorNameDidChanged;
extern NSString *const kNotificationVisitorSurnameDidChanged;
extern NSString *const kNotificationVisitorBirthYearDidChanged;
extern NSString *const kNotificationVisitorBooksDidChanged;

@interface STAVisitor : NSObject

@property (copy, readwrite) NSString *name;
@property (copy, readwrite) NSString *surname;
@property NSUInteger birthYear;
@property (copy, readonly) NSString *fullName;
@property (readonly) NSArray<STABook *> *visitorBooks;

- (instancetype)initWithName:(NSString *)aName visitorSurname:(NSString *)aSurname birthYear:(NSUInteger)aYear;
+ (instancetype)visitorWithName:(NSString *)aName visitorSurname:(NSString *)aSurname birthYear:(NSUInteger)aYear;

- (instancetype)initWithBooks:(NSArray<STABook *> *)booksArray;
+ (instancetype)visitorWithBooks:(NSArray<STABook *> *)booksArray;

- (BOOL)takeBook:(STABook *)aBook;
- (BOOL)returnBook:(STABook *)book;

@end