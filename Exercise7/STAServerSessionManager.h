//
//  STAServerSessionManager.h
//  Exercise7
//
//  Created by Иван Ткаченко on 8/10/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAServerSessionManager : NSObject <NSURLSessionTaskDelegate, NSURLSessionDelegate , NSURLSessionDataDelegate>

- (void)getListOfLanguages:(void (^)(NSDictionary *))completion;
- (void)languageDetect:(void (^)(NSDictionary *))completion textToDetect:(NSString *)text;
- (void)translateText:(void (^)(NSDictionary *))completion textToTranslate:(NSString *)text translationDirection:(NSString *)direction;

@end
