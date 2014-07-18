//
//  PreferencesWindowController.h
//  Chippai
//
//  Created by 大宮　将嗣　 on 2014/07/14.
//
//

#import <Cocoa/Cocoa.h>
#import "ChippaiAppDelegate.h"

@interface PreferencesWindowController : NSWindowController
@property (nonatomic, weak) ChippaiAppDelegate *delegate;

@property (nonatomic, weak) IBOutlet NSSlider *scrollSpeedSlider;
@property (nonatomic, weak) IBOutlet NSSlider *widthSlider;

@end
