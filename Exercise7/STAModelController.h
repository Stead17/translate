//
//  STAModelController.h
//  Exercise7
//
//  Created by Иван Ткаченко on 7/25/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kNotificationModelVisitorDidAdded;
extern NSString *const kNotificationModelVisitorDidRemoved;
extern NSString *const kNotificationModelBookDidAdded;
extern NSString *const kNotificationModelBookDidRemoved;

@class STABook, STAVisitor;
@interface STAModelController : NSObject

@property(copy, readonly) NSArray<STABook *> *listOfBooks;
@property(copy, readonly) NSArray<STAVisitor *> *listOfVisitors;


- (BOOL)addBook:(STABook *)aBook;
- (BOOL)addReader:(STAVisitor *)aVisitor;

- (BOOL)removeBook:(STABook *)aBook;
- (BOOL)removeReader:(STAVisitor *)aVisitor;

@end