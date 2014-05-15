//
//  ViewController.m
//  DynamicForms
//
//  Created by Phong on 5/14/14.
//  Copyright (c) 2014 MCubedLabs. All rights reserved.
//

#import "ViewController.h"
#import "FormTableViewCell.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSMutableArray * fields;
    UIToolbar * _toolbar;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    fields = [NSMutableArray new];
    
    //Setup the toolbar to have the done button for the keyboards
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(done:)];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:@[flexSpace,btnDone]];
    
    _countTextField.inputAccessoryView = _toolbar;
    _memoTextField.inputAccessoryView = _toolbar;
    
    //Register keyboard show/hide notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [fields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                              forIndexPath:indexPath];
    
    cell.fieldTextField.tag = indexPath.row;
    cell.fieldTextField.inputAccessoryView = _toolbar;
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormTableViewCell* formCell = (FormTableViewCell*)cell;
    NSString* field = fields[indexPath.row];
    
    if (field) {
        formCell.fieldTextField.text = field;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *item = [fields objectAtIndex:fromIndexPath.row];
    [fields removeObjectAtIndex:fromIndexPath.row];
    [fields insertObject:item atIndex:toIndexPath.row];
}

//Remove the delete button when editing the tableview
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

//Prevent the indentation that is caused by the deletion button
- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark KeyboardNotification Methods

//If the Keyboard is shown, ajust the tableview to the textfield that is being edited
- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
        [_formTableView setContentInset:edgeInsets];
        [_formTableView setScrollIndicatorInsets:edgeInsets];
    }];
}

//If the keyboard is dismissed, reset the tableview to its original state.
- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [_formTableView setContentInset:edgeInsets];
        [_formTableView setScrollIndicatorInsets:edgeInsets];
    }];
}

#pragma mark - Custom

//If the user press the done button on a keyboard, then dismiss the keyboard
-(void)done:(id) sender{
    [self.view endEditing:YES];
}

- (IBAction)countDidEdit:(id)sender {
    UITextField * field = (UITextField*) sender;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * count = [f numberFromString:field.text];
    
    NSNumber *missingCount = [NSNumber numberWithInt:[count intValue] - [fields count]];
    
    //Add rows
    if ([missingCount intValue] > 0) {
        [self addRows:[missingCount intValue]];
    }else{
        //Remove rows
        [self removeRows:abs([missingCount intValue])];
    }
}

//If the count value is greater that its original value, then add rows to the table.
-(void) addRows:(NSInteger)countAmount{
    NSInteger fieldCount = [fields count];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int x = 0; x < countAmount; x++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:fieldCount + x inSection:0]];
        [fields addObject:[NSString new]];
    }
    
    [self.formTableView beginUpdates];
    [self.formTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.formTableView endUpdates];
}

//If the count value is less than the original remove rows from the bottom
-(void) removeRows:(NSInteger)countAmount{
    NSInteger fieldCount = [fields count];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int x = 0; x < countAmount; x++) {
        [fields removeObjectAtIndex:fieldCount - x - 1];
        [indexPaths addObject:[NSIndexPath indexPathForRow:fieldCount - x - 1 inSection:0]];
    }
    
    [self.formTableView beginUpdates];
    [self.formTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.formTableView endUpdates];
}

- (IBAction)fieldDidEdit:(id)sender {
    UITextField * field = (UITextField*) sender;
    
    NSInteger index =  field.tag;
    
    fields[index] = field.text;
}

- (IBAction)editTable:(id)sender {
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [_formTableView setEditing:NO animated:NO];
        [_formTableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [_formTableView setEditing:YES animated:YES];
        [_formTableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

@end
