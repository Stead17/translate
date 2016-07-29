//
//  STAVisitor.m
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAVisitor.h"
#import "STABook.h"
#import "STAVisitor+VisitorSerialization.h"

NSString *const kNotificationVisitorNameDidChanged = @"Visitor name changed";
NSString *const kNotificationVisitorSurnameDidChanged = @"Visitor surname changed";
NSString *const kNotificationVisitorBirthYearDidChanged = @"Visitor birth year changed";
NSString *const kNotificationVisitorBooksDidChanged = @"Visitor books changed";

@interface STAVisitor()
{
@private
    NSString *_name;
    NSString *_surname;
    NSUInteger _birthYear;
    NSString *_fullName;
    NSMutableArray<STABook *> *_visitorBooks;
}

@property (readwrite) NSMutableArray<STABook *> *mvisitorBooks;

@end

@implementation STAVisitor

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _visitorBooks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)aName visitorSurname:(NSString *)aSurname birthYear:(NSUInteger)aYear
{
    self = [self init];
    if(self)
    {
        _name = [aName copy];
        _surname = [aSurname copy];
        _birthYear = aYear;
    }
    return self;
}
+ (instancetype)visitorWithName:(NSString *)aName visitorSurname:(NSString *)aSurname birthYear:(NSUInteger)aYear
{
    return [[[self alloc] initWithName:aName visitorSurname:aSurname birthYear:aYear] autorelease];
}

- (instancetype)initWithBooks:(NSArray<STABook *> *)booksArray
{
    self = [self init];
    if (self)
    {
        _visitorBooks = [booksArray mutableCopy];
    }
    return self;
}
+ (instancetype)visitorWithBooks:(NSArray<STABook *> *)booksArray
{
    return [[[STAVisitor alloc] initWithBooks:booksArray] autorelease];
}

- (NSString *)name
{
    return _name;
}
- (NSString *)surname
{
    return _surname;
}
- (NSUInteger)birthYear
{
    return _birthYear;
}
- (NSString *)fullName
{
    NSString *stringResult = nil;
    if(!self.name && !self.surname)
        stringResult = [NSString stringWithFormat:@"No name, surname info"];
    else if (!self.name)
        stringResult = [NSString stringWithFormat:@"No name info\n%@", self.surname];
    else if(!self.surname)
        stringResult = [NSString stringWithFormat:@"No surname info\n%@", self.name];
    else
        stringResult = [NSString stringWithFormat:@"%@ %@", self.name, self.surname];
    
    return stringResult;
}


- (NSArray<STABook *> *)visitorBooks
{
    return self.mvisitorBooks;
}

- (NSMutableArray<STABook *> *)mvisitorBooks
{
    return _visitorBooks;
}

- (void)setMvisitorBooks:(NSMutableArray<STABook *> *)mvisitorBooks
{
    if (_visitorBooks != mvisitorBooks)
    {
        [_visitorBooks release];
        _visitorBooks = [mvisitorBooks retain];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVisitorBooksDidChanged object:self];
    }
}

- (void)setName:(NSString *)name
{
    if (_name != name)
    {
        [_name release];
        _name = [name copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVisitorNameDidChanged object:self];
    }
}
- (void)setSurname:(NSString *)surname
{
    if (_surname != surname)
    {
        [_surname release];
        _surname = [surname copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVisitorSurnameDidChanged object:self];
    }
}
- (void)setBirthYear:(NSUInteger)birthYear
{
    _birthYear = birthYear;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVisitorBirthYearDidChanged object:self];
}

- (BOOL)takeBook:(STABook *)aBook
{
    BOOL result= NO;
    if (aBook && ![self.mvisitorBooks containsObject:aBook] && !aBook.owner)
    {
        if([aBook isKindOfClass:[STABook class]])
        {
            [self.mvisitorBooks addObject:aBook];
            aBook.owner = self;
            result= YES;
        }
    }
    return result;
}

- (BOOL)returnBook:(STABook *)book
{
    BOOL result= NO;
    if (book && [self.mvisitorBooks containsObject:book])
    {
        int indx = (int)[self.mvisitorBooks indexOfObject:book];
        self.mvisitorBooks[indx].owner = nil;
        [self.mvisitorBooks removeObject:book];
        result= YES;
    }
    return result;
}

- (BOOL)isEqual:(id)object
{
    BOOL result= NO;
    if ([object isKindOfClass:[STAVisitor class]])
    {
        STAVisitor *temporary = (STAVisitor *)object;
        if ([temporary.surname isEqualToString:self.surname] &&
            [temporary.name isEqualToString:self.name] && temporary.birthYear == self.birthYear &&
            [temporary.visitorBooks isEqualToArray:self.visitorBooks])
        {
            result= YES;
        }
    }
    return result;
}

- (NSUInteger)hash
{
    return self.name.hash ^ self.surname.hash ^ self.visitorBooks.hash ^ self.birthYear;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@\n%@\n", [super description], self.fullName];
}

-(void)dealloc
{
    [_name release];
    [_surname release];
    [_fullName release];
    [_visitorBooks release];
    [super dealloc];
}

@end