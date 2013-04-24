//
//  ChippaiAppDelegate.m
//  Chippai
//
//  Created by 大宮 将嗣 on 13/04/12.
//
//

#import "ChippaiAppDelegate.h"

#import "HTTPServer.h"
#import "ChippaiResponse.h"

#import "SocketIOPacket.h"


@implementation ChippaiAppDelegate

@synthesize statusMenu;
@synthesize statusBar = _statusBar;
@synthesize socketIO;

- (void)awakeFromNib
{
  self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  self.statusBar.title = @"Loading...";
  
  self.statusBar.menu = self.statusMenu;
  self.statusBar.highlightMode = YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
  
//  [self updateTitle];
//  [NSTimer scheduledTimerWithTimeInterval:0.05f
//                                   target:self
//                                 selector:@selector(updateTitle)
//                                 userInfo:nil repeats:YES];
  
  NSNumber *ownerPid = [self getOwnerPIDWithOwnerName:@"VLC"];
  
  NSRunningApplication *application = [NSRunningApplication runningApplicationWithProcessIdentifier:[ownerPid intValue]];
  NSLog(@"application = %@", application);
  
//  NSLog(@"activeApplication = %@", [[NSWorkspace sharedWorkspace] activeApplication]);
//
//  NSArray *runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
//  NSLog(@"runningApplications = %@", runningApplications);
//  
//  for (NSRunningApplication *application in runningApplications) {
//    
//    NSNumber *pid = [appInfo objectForKey:@"NSApplicationProcessIdentifier"];
//    if ([ownerPid intValue] == [pid intValue]){
//      
//      NSLog(@"appInfo = %@", appInfo);
//      
//      break;
//    }
//    
//  }
  
//  [[HTTPServer sharedHTTPServer] start];
//  [ChippaiResponse load];
  
//  SRWebSocket *webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://153.135.43.113:58080"]]];
////  SRWebSocket *webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://dev.charag.jp:18000"]]];
//  [webSocket setDelegate:self];
//  [webSocket open];
  
  self.socketIO = [[SocketIO alloc] initWithDelegate:self];
  [self.socketIO connectToHost:@"153.135.43.113" onPort:58080];
}



- (void)applicationWillTerminate:(NSNotification *)notification
{
  [[HTTPServer sharedHTTPServer] stop];
}

- (void)updateTitle
{
//  NSString *vlcTitle = [self getWindowTitleWithOwnerName:@"VLC"];
  
  NSString *vlcTitle = nil;
  if (vlcTitle) {
    self.statusBar.title = vlcTitle;
  } else {
    self.statusBar.title = @"(。ﾟωﾟ) ｡";
  }
}

- (IBAction)copyToPastaborad:(id)sender
{
  [[NSPasteboard generalPasteboard] clearContents];
  [[NSPasteboard generalPasteboard] writeObjects:[NSArray arrayWithObject:self.statusBar.title]];
}

- (IBAction)google:(id)sender
{
  NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/search?q=%@",
                         [self.statusBar.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSURL *url = [NSURL URLWithString:urlString];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (NSNumber*)getOwnerPIDWithOwnerName:(NSString*)ownerName
{
  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
  NSArray *array = CFBridgingRelease(windowList);
//  NSLog(@"array = %@", array);
  for (NSDictionary *dic in array) {
    NSString *windowOwnerName = [dic objectForKey:@"kCGWindowOwnerName"];
    BOOL isOnScreen = [[dic objectForKey:@"kCGWindowIsOnscreen"] boolValue];
    if ([windowOwnerName isEqualToString:ownerName]
        && isOnScreen == YES){
      return [dic objectForKey:@"kCGWindowOwnerPID"];
    }
  }
  return nil;
}

- (NSString*)getWindowTitleWithOwnerName:(NSString*)ownerName
{
  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
  NSArray *array = CFBridgingRelease(windowList);
  NSLog(@"array = %@", array);
  for (NSDictionary *dic in array) {
    NSString *windowOwnerName = [dic objectForKey:@"kCGWindowOwnerName"];
    BOOL isOnScreen = [[dic objectForKey:@"kCGWindowIsOnscreen"] boolValue];
    if ([windowOwnerName isEqualToString:ownerName]
        && isOnScreen == YES){
      return [dic objectForKey:@"kCGWindowName"];
    }
  }
  return nil;
}

- (void)updateTitle:(NSString*)title
{
  self.statusBar.title = title;
}


#pragma mark - SRWebSocketDelegate methods
//
//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
//{
//  NSLog(@"webSocket:didReceiveMessage called.");
//  NSLog(@"message = %@", message);
//}
//
//- (void)webSocketDidOpen:(SRWebSocket *)webSocket
//{
//  NSLog(@"webSocketDidOpen called.");
//  NSLog(@"webSocket = %@", webSocket);
//}
//
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
//{
//  NSLog(@"webSocket:didFailWithError called.");
//  NSLog(@"webSocket = %@", webSocket);
//  NSLog(@"error = %@", error);
//}
//
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
//{
//  NSLog(@"webSocket:didCloseWithCode:reason:wasClean called.");
//  NSLog(@"webSocket = %@", webSocket);
//  NSLog(@"code = %ld", code);
//  NSLog(@"reason = %@", reason);
//  NSLog(@"wasClean = %@", wasClean ? @"YES" : @"NO");
//}

#pragma mark - SocketIODelegate methods

- (void) socketIODidConnect:(SocketIO *)socket
{
   NSLog(@"socketIODidConnect"); 
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
  NSLog(@"socketIODidDisconnect:disconnectedWithError");
  NSLog(@"error = %@", error);
}

- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
  NSLog(@"socketIO:didReceiveMessage");
  [packet dump];
}

- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet
{
  NSLog(@"socketIO:didReceiveJSON");
  [packet dump];
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
  NSLog(@"socketIO:didReceiveEvent");
  [packet dump];
  
  
  if ([packet.name isEqualToString:@"FromMpd"]) {
    
    if ([packet.args count] > 0) {
      NSString *line = [packet.args objectAtIndex:0];
      if ([line hasPrefix:@"OK MPD"]) {
        [socket sendEvent:@"statusupdate" withData:@"statusupdate"];// currentsong"];
      }
    }
  }
  
  if ([[packet name] isEqualToString:@"Status"]) {
    [socket sendEvent:@"data" withData:@"statusupdate"];
  }
}

- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet
{
  NSLog(@"socketIO:didSendMessage");
  [packet dump];
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
  NSLog(@"socketIO:onError");
  NSLog(@"error = %@", error);
}



@end
