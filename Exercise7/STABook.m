//
//  STABook.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STABook.h"
#import "STAVisitor.h"
#import "STABook+BookSerialization.h"

NSString *const kNotificationBookNameDidChange = @"Book name changed";
NSString *const kNotificationBookYearDidChange = @"Book year changed";
NSString *const kNotificationBookCoverTypeDidChange = @"Book covertype changed";
NSString *const kNotificationBookOwnerDidChange = @"Book owner changed";

@interface STABook()
{
@private
    NSString *_bookName;
    NSUInteger _bookYear;
    STABookType _coverType;
    STAVisitor *_owner;
    NSString *_ID;
}
@end

@implementation STABook

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSUUID *tmp = [[NSUUID alloc] init];
        _ID = [tmp.UUIDString copy];
        [tmp release];
    }
    return self;
}

- (instancetype)initWithBookName:(NSString *)bookName bookYear:(NSUInteger)year bookType:(STABookType)coverType
{
    self = [self init];
    if(self)
    {
        _bookName = [bookName copy];
        _bookYear = year;
        _coverType = coverType;
    }
    return self;
}
+ (instancetype)bookWithName:(NSString *)name bookYear:(NSUInteger)year bookType:(STABookType )coverType
{
    return [[[self alloc] initWithBookName:name bookYear:year bookType:coverType] autorelease];
}

- (instancetype)initWithBookID:(NSString *)aID bookName:(NSString *)bookName bookYear:(NSUInteger)year bookType:(STABookType)coverType
{
    self = [super init];
    if (self)
    {
        _bookName = [bookName copy];
        _bookYear = year;
        _coverType = coverType;
        _ID = [aID copy];
    }
    return self;
}
+ (instancetype)bookWithID:(NSString *)aID bookName:(NSString *)bookName bookYear:(NSUInteger)year bookType:(STABookType)coverType
{
    return [[[STABook alloc] initWithBookID:aID bookName:bookName bookYear:year bookType:coverType] autorelease];
}


-(NSString *)bookName
{
    return _bookName;
}
- (NSUInteger)bookYear
{
    return _bookYear;
}
- (NSString *)ID
{
    return _ID;
}

- (STABookType)coverType
{
    return _coverType;
}
- (STAVisitor *)owner
{
    return _owner;
}

- (void)setBookName:(NSString *)bookName
{
    if (_bookName != bookName)
    {
        [_bookName release];
        _bookName = [bookName copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookNameDidChange object:self];
    }
}
- (void)setBookYear:(NSUInteger)bookYear
{
    _bookYear = bookYear;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookYearDidChange object:self];
}

- (void)setCoverType:(STABookType)coverType
{
    _coverType = coverType;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookCoverTypeDidChange object:self];
}
- (void)setOwner:(STAVisitor *)owner
{
    _owner = owner;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookOwnerDidChange object:self];
}

- (BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if ([object isKindOfClass:[STABook class]])
    {
        STABook *temporaryBook = (STABook *)object;
        if ([self.bookName isEqualToString:temporaryBook.bookName] && self.bookYear == temporaryBook.bookYear && self.owner == temporaryBook.owner && [self.ID isEqual: temporaryBook.ID])
        {
            result = YES;
        }
    }
    return result;
}

- (NSUInteger)hash
{
    return self.bookName.hash ^ self.bookYear ^ self.coverType ^ self.owner.hash ^ self.ID.hash;
}

- (NSString *)description
{
    NSString *type = [[[NSString alloc] init] autorelease];
    if (self.coverType == kSTABookTypeUndefined)
    {
        type = @"Undefined";
    }
    else if (self.coverType == kSTABookTypePaperCover)
    {
        type = @"Paperback";
    }
    else if(self.coverType == kSTABookTypeHardCover)
    {
        type = @"Hardcover";
    }
    
    return [NSString stringWithFormat:@"\n%@\nBook Name: '%@'\nYear: %lu\nBook cover type: '%@'\nOwner: %@\nID: %@\n", [super description], self.bookName, self.bookYear, type, (self.owner == nil ? @"No owner" :                                                                                                                                                                 self.owner.fullName), self.ID];
}

- (void)dealloc
{
    [_bookName release];
    [_ID release];
    [super dealloc];
}

@end