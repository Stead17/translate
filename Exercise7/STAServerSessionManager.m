//
//  STAServerSessionManager.m
//  Exercise7
//
//  Created by Иван Ткаченко on 8/10/16.
//  Copyright © 2016 Иван Ткаченко. All rights reserved.
//

#import "STAServerSessionManager.h"

NSString * const kSTAMainURL = @"https://translate.yandex.net/";
NSString * const kSTAGETRequestURL = @"api/v1.5/tr.json/getLangs?ui=en&key=";
NSString * const kSTAPOSTRequestLanguageDetect = @"/api/v1.5/tr.json/detect?de&key=";

NSString * const kSTAPOSTRequestTranslateText = @"/api/v1.5/tr.json/translate?lang=";
NSString * const kSTAKeyArguement = @"&key=";

NSString * const kSTAAPIKey = @"trnsl.1.1.20160810T065716Z.a332350274f467af.274051ab6fe8fea6a1fe0a220b80b04136f93efd";
NSString * const kSTATextArguementToRequest = @"text=";

@implementation STAServerSessionManager

- (void)getListOfLanguages:(void (^)(NSDictionary *))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kSTAMainURL, kSTAGETRequestURL, kSTAAPIKey]];
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError *error)
          {
              if (!error)
              {
                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                  if (!error)
                  {
                      dispatch_sync(dispatch_get_main_queue(), ^{
                          completion(dict);
                      });
                  }
                  else
                  {
                      NSLog(@"%@", error);
                  }
              }
              else
              {
                  NSLog(@"%@", error);
              }
          }];
    
    [dataTask resume];
}

- (void)languageDetect:(void (^)(NSDictionary *))completion textToDetect:(NSString *)text
{
    NSString *detectText = [NSString stringWithFormat:@"%@%@", kSTATextArguementToRequest, text];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kSTAMainURL, kSTAPOSTRequestLanguageDetect, kSTAAPIKey]];
    
    NSData *data = [detectText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError *error)
          {
              if (!error)
              {
                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                  if (!error)
                  {
                      dispatch_sync(dispatch_get_main_queue(), ^{
                          completion(dict);
                      });
                  }
                  else
                  {
                      NSLog(@"%@", error);
                  }
              }
              else
              {
                  NSLog(@"Error %@", error);
              }
          }];
    
    [dataTask resume];
}


- (void)translateText:(void (^)(NSDictionary *))completion textToTranslate:(NSString *)text translationDirection:(NSString *)direction
{
    NSString *textToTranslate = [NSString stringWithFormat:@"%@%@", kSTATextArguementToRequest, text];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", kSTAMainURL, kSTAPOSTRequestTranslateText, direction, kSTAKeyArguement, kSTAAPIKey]];
    NSData *data = [textToTranslate dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (!error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!error)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion(dict);
                });
            }
            else
            {
                NSLog(@"%@", error);
            }
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
    
    [dataTask resume];
}

@end
