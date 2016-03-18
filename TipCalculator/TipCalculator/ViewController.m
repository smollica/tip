//
//  ViewController.m
//  TipCalculator
//
//  Created by Monica Mollica on 2016-03-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bill;
@property (weak, nonatomic) IBOutlet UILabel *tipAmount;
@property (weak, nonatomic) IBOutlet UITextField *tipPercent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrain;
@property (nonatomic) float fixKeyboard;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];

    [center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tipButtomPressed:(id)sender {
    [self calculateTip];
}

- (void)calculateTip {
    float bill = self.bill.text.floatValue;
    float tip = bill * self.tipPercent.text.floatValue / 100;
    self.tipAmount.text = [[NSString alloc] initWithFormat:@"%.02f", tip];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = value.CGRectValue;
    if (self.tipSlider.frame.origin.y + self.tipSlider.frame.size.height + 20 >= frame.origin.y) {
        self.fixKeyboard = self.topConstrain.constant;
        self.topConstrain.constant = self.topConstrain.constant - self.tipSlider.frame.origin.y - self.tipSlider.frame.size.height - 20 + frame.origin.y;
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    if (self.fixKeyboard > 0) {
        self.topConstrain.constant = self.fixKeyboard;
        self.fixKeyboard = 0;
    }
}

- (void)adjustTip:(int)percent {
    self.tipPercent.text = [NSString stringWithFormat:@"%i", percent];
}

- (IBAction)tapOutside:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)sliderPercent:(UISlider*)sender {
    [self adjustTip:sender.value];
    [self calculateTip];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.tipSlider.value = self.tipPercent.text.intValue;
    [self calculateTip];
}

@end
