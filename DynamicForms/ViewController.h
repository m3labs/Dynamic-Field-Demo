//
//  ViewController.h
//  DynamicForms
//
//  Created by Phong on 5/14/14.
//  Copyright (c) 2014 MCubedLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *formTableView;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;

/**
 IBAction method that is binded to the count UITextFields Editing Did End event in the header of the table view.
 @param sender
 This is the UITextfield that has finished editing
 */
- (IBAction)countDidEdit:(id)sender;

/**
 IBAction method that is binded to the cell's UITextFields Editing Did End event.
 @param sender
 This is the UITextfield that has finished editing
 */
- (IBAction)fieldDidEdit:(id)sender;

/**
 IBAction method that toggles the view controller editing state.
 @param sender
 This is the UIBarButtonItem that was pressed
 */
- (IBAction)editTable:(id)sender;

@end
