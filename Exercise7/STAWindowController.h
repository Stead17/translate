//
//  STAWindowController.h
//  Exercise7
//
//  Created by Иван Ткаченко on 7/26/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const kTitleColumnIdentifier;
extern NSString *const kYearColumnIdentifier;
extern NSString *const kCoverTypeColumnIdentifier;
extern NSString *const kOwnerColumnIdentifier;

extern NSString *const kNameVisitorTextField;
extern NSString *const kSurnameVisitorTextField;
extern NSString *const kYearVisitorTextField;

@class STAVisitor, STAModelController;

@interface STAWindowController : NSWindowController

@property (nonatomic, retain) STAVisitor *visitor;

- (instancetype)initWithWindowNibName:(NSString *)windowNibName visitorForTable:(STAVisitor *)visitor modelToChange:(STAModelController *)model;

@end
