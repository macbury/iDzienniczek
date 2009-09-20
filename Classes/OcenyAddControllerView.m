//
//  OcenyAddControllerView.m
//  iDzienniczek
//
//  Created by MacBury on 08-08-06.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OcenyAddControllerView.h"


@implementation OcenyAddControllerView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:@"OcenyAddControllerView" bundle:nibBundleOrNil];
	
	iDzienniczekAppDelegate * mainDelegate = (iDzienniczekAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	ocenyArray = [mainDelegate.gradeSystem objectForKey:@"Grades"];
	zaCoArray = [mainDelegate.gradeSystem objectForKey:@"ForWhat"];
    return self;
}

- (IBAction) dateChange:(id)sender{
	ocena.dodano = datePicker.date;
	[tableView reloadData];
}

- (IBAction) save:(id)sender{
	[notatkaView resignFirstResponder];
	[ocena save];
	[ocena release];
	ocena = nil;
	if (self.status == sDetail){
		[self.navigationController popViewControllerAnimated:YES];
	}else {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
}

- (IBAction) cancel:(id)sender{
	[notatkaView resignFirstResponder];
	[ocena release];
	ocena = nil;
	if (self.status == sDetail){
		[self.navigationController popViewControllerAnimated:YES];
	}else {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

	if (customDataSource == 0){
		ocena.ocena = ++row;
	}else{
		ocena.zaco = row;
	}

	[tableView reloadData];
}

- (UITableViewCell *)getNotatkaTableCell {
	static NSString *BodyIdentifier = @"notatkaCellView";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BodyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 100) reuseIdentifier:BodyIdentifier] autorelease];
		notatkaView = [[UITextView alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 6, 6)];
		notatkaView.font = [UIFont systemFontOfSize:15.0f];
		
		notatkaView.editable = YES;
		notatkaView.delegate = self;
		[notatkaView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[cell.contentView addSubview:notatkaView];
		
	}
	notatkaView.text = self.ocena.notatka;
	
	return cell;

}

- (void)textViewDidEndEditing:(UITextView *)textView {
	self.ocena.notatka = textView.text;

}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			customDataSource = 0;
			[pickerView reloadComponent:0];
			
			[datePicker setHidden:YES];
			[pickerView setHidden:NO];
		
			[pickerView selectRow:ocena.ocena-1 inComponent:0 animated:YES];
			
			[notatkaView resignFirstResponder];
		break;
		case 1:
			customDataSource = 1;
			[pickerView reloadComponent:0];
			
			[datePicker setHidden:YES];
			[pickerView setHidden:NO];
			[pickerView selectRow:ocena.zaco inComponent:0 animated:YES];
			
			[notatkaView resignFirstResponder];
		break;
		case 2:
			[datePicker setHidden:NO];
			[pickerView setHidden:YES];
			[datePicker setDate:ocena.dodano animated:YES];
			
			[notatkaView resignFirstResponder];
		break;
		case 3:
			[notatkaView becomeFirstResponder];
			[tableView deselectRowAtIndexPath:indexPath animated:NO];
		break;
	}
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (customDataSource == 0){
		return [ocenyArray count];
	}else{
		return [zaCoArray count];
	}
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (customDataSource == 0){
		return [ocenyArray objectAtIndex:row];
	}else{
		return [zaCoArray objectAtIndex:row];
	}
	
}

- (void)dealloc {
	[zaCoArray release];
	[ocenyArray release];
	[notatkaView release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	iDzienniczekAppDelegate * appDelegate = (iDzienniczekAppDelegate *)[[UIApplication sharedApplication] delegate];
	tableView.scrollEnabled = YES;
	tableView.userInteractionEnabled = YES;
	[super viewWillAppear:animated];
	[tableView selectRowAtIndexPath:1 animated:YES scrollPosition:UITableViewScrollPositionTop];
	customDataSource = 0;
	[pickerView reloadComponent:0];
	[pickerView selectRow:ocena.ocena-1 inComponent:0 animated:YES];
	[datePicker setMinimumDate: appDelegate.selected_rok.start];
	[datePicker setMaximumDate: appDelegate.selected_rok.koniec];
	[datePicker setHidden:YES];
	[pickerView setHidden:NO];
	[notatkaView resignFirstResponder];
	[tableView reloadData];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
	[notatkaView resignFirstResponder];
}
@end

