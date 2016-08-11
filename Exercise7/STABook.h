//
//  STABook.h
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import <Foundation/Foundation.h>

// Enum for types of book cover
typedef NS_ENUM(NSInteger, STABookType)
{
    kSTABookTypeUndefined = 0,
    kSTABookTypePaperCover = 1,
    kSTABookTypeHardCover = 2
};

extern NSString *const kNotificationBookNameDidChange;
extern NSString *const kNotificationBookYearDidChange;
extern NSString *const kNotificationBookCoverTypeDidChange;
extern NSString *const kNotificationBookOwnerDidChange;

@class STAVisitor;

@interface STABook : NSObject

@property (copy, readwrite) NSString *bookName;
@property (readwrite) NSUInteger bookYear;
@property (readwrite) STABookType coverType;
@property (assign, readwrite) STAVisitor *owner;
@property (retain, readonly) NSString *ID;
@property (copy, readwrite) NSAttributedString *text;

- (instancetype)initWithBookName:(NSString *)bookName bookYear:(NSUInteger)year bookType:(STABookType)coverType;
+ (instancetype)bookWithName:(NSString *)name bookYear:(NSUInteger)year bookType:(STABookType)coverType;

- (instancetype)initWithBookID:(NSString *)aID bookName:(NSString *)bookName bookYear:(NSUInteger)year bookType:(STABookType)coverType;
+ (instancetype)bookWithID:(NSString *)aID  bookName:(NSString *)bookName bookYear:(NSUInteger)year bookType:(STABookType)coverType;

@end