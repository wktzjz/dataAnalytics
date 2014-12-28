//
//  ConditionInquireController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-22.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "ConditionInquireController.h"
#import "CityDBManager.h"
#import "PNColor.h"
#import <snDataAnalytics-swift.h>

#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@implementation ConditionInquireController
{
    inquireViewType _type;
    UIView *_contentView;
    UITableView *_tableView;
    
    UITextField *_cityField;
    
    LTMorphingLabel *_cityLabel;
    LTMorphingLabel *_terminalLabel;

    UISearchBar *_citySearchBar;
    UISearchBar *_terminalSearchBar;

    UISearchDisplayController *_citySearchDisplayController;
    UISearchDisplayController *_terminalSearchDisplayController;

    NSMutableArray *_cityArray;
    NSMutableArray *_searchResults;
    
}


- (instancetype)initWithFrame:(CGRect)frame type:(inquireViewType)type
{
     if ( (self = [super init]) ) {
        _type = type;
        self.view.frame = frame;
     }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 300, 360);
    _contentView = [[UIView alloc] initWithFrame:self.view.frame];
    _contentView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_contentView];
    switch (_type) {
        case inquireVisitorGroup1:{
            [self addVisitorGroupView1];
            break;
        }
        case inquireVisitorGroup2:{
            [self addVisitorGroupView2];
            break;
        }
        case inquireSourceAnalytics:{
            
            
            break;
        }
        case inquirePageAnalytics:{
            
            
            break;
        }
        case inquireTransformAnalytics:{
            
            break;
        }
            
        default:
            break;
    }
}

- (void)addVisitorGroupView1
{
    _cityLabel = [[LTMorphingLabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20.0, 30)];
    _cityLabel.text = @"输入查询城市";
    _cityLabel.textColor = PNDeepGrey;
    _cityLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _cityLabel.textAlignment = NSTextAlignmentLeft;
    [_contentView addSubview:_cityLabel];
    
    _cityArray = [[CityDBManager sharedInstance] getAllCities];
    _searchResults = [[NSMutableArray alloc] initWithCapacity:10];
    
    _citySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 10.0 + _cityLabel.frame.size.height + 20.0, 300 , 44)];
    _citySearchBar.backgroundColor = [UIColor redColor];
    _citySearchBar.delegate = self;
    [_citySearchBar setPlaceholder:@"搜索城市"];
    [_citySearchBar sizeToFit];
    [self.view addSubview:_citySearchBar];
    
    _terminalLabel = [[LTMorphingLabel alloc] initWithFrame:CGRectMake(10, _citySearchBar.frame.origin.y + _citySearchBar.frame.size.height + 20.0, self.view.frame.size.width - 20.0, 30)];
    _terminalLabel.text = @"输入查询终端";
    _terminalLabel.textColor = PNDeepGrey;
    _terminalLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _terminalLabel.textAlignment = NSTextAlignmentLeft;
    [_contentView addSubview:_terminalLabel];
    
    _terminalSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(30, _terminalLabel.frame.origin.y + _terminalLabel.frame.size.height + 20.0, self.view.frame.size.width - 2 * 30, 44)];
    _terminalSearchBar.delegate = self;
    [_terminalSearchBar setPlaceholder:@"搜索终端"];
    [self.view addSubview:_terminalSearchBar];
    
    
    _citySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_citySearchBar contentsController:self];
    _citySearchDisplayController.active = NO;
    _citySearchDisplayController.searchResultsDataSource = self;
    _citySearchDisplayController.searchResultsDelegate = self;
    
    _terminalSearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_terminalSearchBar contentsController:self];
    _terminalSearchDisplayController.active = NO;
    _terminalSearchDisplayController.searchResultsDataSource = self;
    _terminalSearchDisplayController.searchResultsDelegate = self;


//    _cityField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10.0 + chartLabel.frame.size.height + 20.0, self.view.frame.size.width - 2 * 20, 44)];
//    _cityField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"城市", @"") attributes:@{NSForegroundColorAttributeName: PNGrey}];
//    _cityField.font            = [UIFont systemFontOfSize:16];
//    _cityField.textColor       = [UIColor whiteColor];
//    _cityField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _cityField.delegate        = self;
//    _cityField.returnKeyType   = UIReturnKeyDone;
//    _cityField.keyboardType    = UIKeyboardTypeEmailAddress;
//    _cityField.backgroundColor = [UIColor brownColor];
//    [_cityField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];

//    [_contentView addSubview:_cityField];
}


#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar == _citySearchBar) {
        [self searchBarTextChanged:searchText targetArray:_cityArray];
    }else{
        [self searchBarTextChanged:searchText targetArray:_cityArray];
    }
}

- (void)searchBarTextChanged:(NSString *)searchText targetArray:(NSMutableArray *)targetArray
{
    @autoreleasepool {
        [_searchResults removeAllObjects];
        
        if (searchText.length > 0 && ![ChineseInclude isIncludeChineseInString:searchText]) {
            for (int i = 0; i < targetArray.count; i++) {
                if ([ChineseInclude isIncludeChineseInString:targetArray[i]]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:targetArray[i]];
                    NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length > 0) {
                        [_searchResults addObject:targetArray[i]];
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:targetArray[i]];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length > 0) {
                        [_searchResults addObject:targetArray[i]];
                    }
                }else {
                    NSRange titleResult=[targetArray[i] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length > 0) {
                        [_searchResults addObject:targetArray[i]];
                    }
                }
            }
        } else if (searchText.length > 0 && [ChineseInclude isIncludeChineseInString:searchText]){
            _searchResults = [[NSMutableArray alloc] initWithArray:[targetArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@",searchText]]];
            
            //            for (NSString *tempStr in _cityArray) {
            //                NSRange titleResult=[tempStr rangeOfString:_citySearchBar.text options:NSCaseInsensitiveSearch];
            //                if (titleResult.length > 0) {
            //                    [_searchResults addObject:tempStr];
            //                }
            //            }
        }
        
    }
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    CGRect r = _citySearchBar.frame;
//    r.size.width = self.view.frame.size.width - 2 * 30;
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _citySearchBar.frame = r;
//    } completion:nil];
    
//    _citySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(30, 10.0 + chartLabel.frame.size.height + 20.0, self.view.frame.size.width - 2 * 30, 44)];

}


- (void)addVisitorGroupView2
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if (textField == _accountField) {
//        [_passwordField becomeFirstResponder];
//    }
    
    [self.view endEditing:YES];
    
    if (_chooseActionBlock){
        _chooseActionBlock(@{@"cityName:":_cityField.text});
    }
    
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
//    [_suggestList showSuggestionsFortextFieldDidBeginEditing:textField];
}

- (CGSize)preferredContentSize
{
    if (_type == inquireVisitorGroup1) {
        return CGSizeMake(300, 360);
    }else{
        return CGSizeMake(300, 360);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchResults.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _searchResults[indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row < _searchResults.count){
        if (tableView == _citySearchDisplayController.searchResultsTableView) {
            _cityLabel.text = [NSString stringWithFormat:@"选定城市:%@",_searchResults[indexPath.row]];
            _citySearchBar.text = @"";
    //        [_citySearchBar resignFirstResponder];
            _citySearchDisplayController.active = NO;
        }else{
            _terminalLabel.text = [NSString stringWithFormat:@"选定终端:%@",_searchResults[indexPath.row]];
            _terminalSearchBar.text = @"";
            _terminalSearchDisplayController.active = NO;
        }
    }
    
}


@end
