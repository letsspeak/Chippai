//  NSString+GetParameter.m
//  Created by y-nakajima on 13/03/14.

#import "NSString+GetParameter.h"

@implementation NSString (GetParameter)

- (NSDictionary *)getParameter
{
  if ([self length] == 0)
    return nil;

  NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];

  NSArray *expressionArray = [self componentsSeparatedByString:@"&"];
  for (NSString *expressionString in expressionArray) {
    
    NSString *expressionPattern = @"(.+)=(.+)";
    
    NSError *parameterError = nil;
    NSRegularExpression *parameterRegexp =
    [NSRegularExpression regularExpressionWithPattern:expressionPattern
                                              options:0
                                                error:&parameterError];
    
    NSLog(@"parameterError = %@", parameterError);
    
    if (parameterError) return nil;
    
    NSTextCheckingResult *expressionMatch =
    [parameterRegexp firstMatchInString:expressionString options:0 range:NSMakeRange(0, expressionString.length)];
    
    if (expressionMatch.numberOfRanges == 3){
      
      NSString *param = [expressionString substringWithRange:[expressionMatch rangeAtIndex:1]];
      NSString *value = [expressionString substringWithRange:[expressionMatch rangeAtIndex:2]];
      
      NSLog(@"param = %@, value = %@", param, value);
      
      [parameterDictionary setValue:value forKey:param];
    }
  }

  return parameterDictionary;
}

@end
