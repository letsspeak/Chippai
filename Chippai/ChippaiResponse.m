//
//  ChippaiResponse.m
//  Chippai
//
//  Created by 大宮 将嗣 on 13/04/19.
//
//

#import "ChippaiResponse.h"
#import "HTTPServer.h"

#import "ChippaiAppDelegate.h"
#import "NSString+GetParameter.h"

@implementation ChippaiResponse

//
// load
//
// Implementing the load method and invoking
// [HTTPResponseHandler registerHandler:self] causes HTTPResponseHandler
// to register this class in the list of registered HTTP response handlers.
//
+ (void)load
{
	[HTTPResponseHandler registerHandler:self];
}

//
// canHandleRequest:method:url:headerFields:
//
// Class method to determine if the response handler class can handle
// a given request.
//
// Parameters:
//    aRequest - the request
//    requestMethod - the request method
//    requestURL - the request URL
//    requestHeaderFields - the request headers
//
// returns YES (if the handler can handle the request), NO (otherwise)
//
+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
                  method:(NSString *)requestMethod
                     url:(NSURL *)requestURL
            headerFields:(NSDictionary *)requestHeaderFields
{
  NSLog(@"requestURL = %@", requestURL);
  if ([requestURL.host isEqualToString:@"localhost"] == NO) return NO;
  
  if ([requestURL.path isEqualToString:@"/update"]) {
    
    NSDictionary *parameterDictionary = [self parameterDictionaryWithQuery:requestURL.query];
    if ([self dictionary:parameterDictionary hasKey:@"title"]) {
      
      ChippaiAppDelegate *delegate = [[NSApplication sharedApplication] delegate];
      [delegate updateTitle:[parameterDictionary objectForKey:@"title"]];
      
      return YES;
      
    }
  }
  
//  NSLog(@"requestURL = %@", requestURL);
//  NSLog(@"requestURL.host = %@", requestURL.host);
//  NSLog(@"requestURL.path = %@", requestURL.path);
//  NSLog(@"requestURL.parameterString = %@", requestURL.parameterString);
//  NSLog(@"requestURL.query = %@", requestURL.query);

	return NO;
}

//
// startResponse
//
// Since this is a simple response, we handle it synchronously by sending
// everything at once.
//
- (void)startResponse
{
//	NSData *fileData =
//  [NSData dataWithContentsOfFile:[AppTextFileResponse pathForFile]];
  
  NSData *data = [@"success" dataUsingEncoding:NSUTF8StringEncoding];
  
	CFHTTPMessageRef response =
  CFHTTPMessageCreateResponse(
                              kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(
                                   response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
	CFHTTPMessageSetHeaderFieldValue(
                                   response, (CFStringRef)@"Connection", (CFStringRef)@"close");
	CFHTTPMessageSetHeaderFieldValue(
                                   response,
                                   (CFStringRef)@"Content-Length",
                                   (CFStringRef)[NSString stringWithFormat:@"%ld", [data length]]);
	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
  
	@try
	{
		[fileHandle writeData:(NSData *)headerData];
		[fileHandle writeData:data];
	}
	@catch (NSException *exception)
	{
		// Ignore the exception, it normally just means the client
		// closed the connection from the other end.
	}
	@finally
	{
		CFRelease(headerData);
		[server closeHandler:self];
	}
}

+ (NSDictionary*)parameterDictionaryWithQuery:(NSString*)query
{
  if (query == nil) return nil;
  
  // パーセントエンコードを解除
  NSString *decodedQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  return [decodedQuery getParameter];
}

+ (BOOL)dictionary:(NSDictionary*)dictionary hasKey:(NSString*)key
{
  for (NSString *dicKey in dictionary.allKeys) {
    if ([dicKey isEqualToString:key]) return YES;
  }
  return NO;
}

@end
