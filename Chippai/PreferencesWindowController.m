//
//  PreferencesWindowController.m
//  Chippai
//
//  Created by 大宮　将嗣　 on 2014/07/14.
//
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
  self = [super initWithWindow:window];
  if (self) {
  }
  return self;
}

- (void)windowDidLoad
{
  [super windowDidLoad];
  
  [self.scrollSpeedSlider setTarget:self];
  [self.scrollSpeedSlider setAction:@selector(onChangeScrollSpeed:)];
  
  [self.widthSlider setTarget:self];
  [self.widthSlider setAction:@selector(onChangeWidth:)];
  
//  - (IBAction)sliderValueChanged:(UISlider *)sender {
//    NSLog(@"slider value = %f", sender.value);
//  }
  // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)onChangeScrollSpeed:(id)sender
{
  NSSlider *slider = (NSSlider*)sender;
  self.delegate.scrollSpeed = slider.intValue;
}

- (void)onChangeWidth:(id)sender
{
  NSSlider *slider = (NSSlider*)sender;
  if (slider.intValue == 0) {
    self.delegate.width = 3000;
  }
  self.delegate.width = (CGFloat)(slider.maxValue - slider.floatValue);
}


@end
