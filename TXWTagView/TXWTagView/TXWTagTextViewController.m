//
//  TXWTagTextViewController.m
//  qgzh
//
//  Created by niko on 15/9/12.
//  Copyright (c) 2015年 jiaodaocun. All rights reserved.
//

#import "TXWTagTextViewController.h"

//COLOR app main color 20150707 alvin
#define COLOR_MAIN ([UIColor colorWithRed:0.459 green:0.325 blue:0.263 alpha:1.000])
//#define COLOR_MAIN ([UIColor colorWithWhite:1 alpha:0.96])
#define COLOR_MAIN_DETAIL ([UIColor colorWithWhite:0.529 alpha:1.000])
#define COLOR_MAIN_BG ([UIColor groupTableViewBackgroundColor])
#define COLOR_MAIN_SEPREATE ([UIColor colorWithRed:0.898 green:0.898 blue:0.878 alpha:1.000])
#define COLOR_MAIN_TEXT ([UIColor blackColor])
#define COLOR_MAIN_WHITE ([UIColor whiteColor])
#define COLOR_MAIN_DROPDOWNBOX ([UIColor colorWithRed:0.204 green:0.184 blue:0.176 alpha:0.960])
#define COLOR_MAIN_GREEN ([UIColor colorWithRed:0.722 green:0.808 blue:0.000 alpha:1.000])
#define COLOR_MAIN_TABBAR_TEXT ([UIColor colorWithRed:0.596 green:0.596 blue:0.604 alpha:1.000])
#define COLOR_NAV_TINTCOLOR ([UIColor colorWithRed:0.596 green:0.596 blue:0.604 alpha:1.000])
#define COLOR_NAV_BARTINTCOLOR ([UIColor colorWithWhite:1 alpha:0.96])
#define COLOR_NAV_TITLE ([UIColor colorWithRed:0.122 green:0.090 blue:0.075 alpha:1.000])
#define COLOR_MAIN_BUTTON ([UIColor colorWithRed:0.122 green:0.090 blue:0.075 alpha:1.000])
#define COLOR_VERIFICATION_YES ([UIColor colorWithRed:0.725 green:0.808 blue:0.000 alpha:1.000])
#define COLOR_VERIFICATION_NO ([UIColor colorWithWhite:0.600 alpha:1.000])

@interface TXWTagTextViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filterArr;
@property (nonatomic, strong) NSMutableArray *dataSource;// tableView dataSource;
@property (nonatomic, assign) BOOL isShowAddCell;// 是否显示添加分组cell

@property (nonatomic ,strong) NSMutableArray *tagNameArr;
@property (nonatomic ,copy) NSString *customerID;
@end

@implementation TXWTagTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init data
    self.dataSource = [NSMutableArray array];
    self.filterArr = [NSMutableArray array];
    self.tagNameArr = [NSMutableArray array];

    self.isShowAddCell = NO;
    
    
    // 获取UserDefault
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.customerID = [userDefault objectForKey:@"ID"];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    [self initUIBarButtonItem];
    
    // 获取本地tag标签值
    [self localTagDataSource];
}

- (void)localTagDataSource
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arraySaveData=[NSMutableArray arrayWithArray:[saveDefaults objectForKey:@"tagDataSource"]];
    self.tagNameArr = arraySaveData;
    self.dataSource = _tagNameArr;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - private method
- (void)initUIBarButtonItem
{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(cleanTagDataSource)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.title = self.isPeopleTagType?@"添加标签":@"添加标签";
}

- (void)cleanTagDataSource
{
    [self.tagNameArr removeAllObjects];
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults setObject:self.tagNameArr forKey:@"tagDataSource"];
    [saveDefaults synchronize];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    if (_isShowAddCell && indexPath.row==0) {
        cell.textLabel.textColor = COLOR_MAIN_GREEN;
        cell.textLabel.text = [NSString stringWithFormat:@"添加一个新标签:%@",_dataSource[indexPath.row]];
    }else{
        cell.textLabel.textColor = COLOR_MAIN_TEXT;
        cell.textLabel.text = _dataSource[indexPath.row];
    }

    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *tagText = [self.dataSource objectAtIndex:indexPath.row];

    if (_isShowAddCell && indexPath.row==0) {
        // 本地缓存
        NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
        [self.tagNameArr addObject:tagText];
        [saveDefaults setObject:self.tagNameArr forKey:@"tagDataSource"];
        [saveDefaults synchronize];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    _callback(tagText);
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 15)];
        return view;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 15.0f;
    }else{
        return 0;
    }
}

#pragma mark - UISearchBarDelegate
// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

// return NO to not resign first responder
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (_searchBar.text.length > MAX_TAGTEXT_LENGTH) {
        NSString *str = [NSString stringWithFormat: @"标签长度不能超过%d个字",MAX_TAGTEXT_LENGTH];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    BOOL isContains = NO;
    // 搜索

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchText];
        self.filterArr =  [[NSMutableArray alloc] initWithArray:[self.tagNameArr filteredArrayUsingPredicate:predicate]];
        
        for (NSString *tagName in self.filterArr) {
            if ([tagName isEqualToString:searchText]) {
                isContains = YES;
            }
        }
        
        if (isContains) {
            self.dataSource = self.filterArr;
            self.isShowAddCell = NO;
        }else{
            NSString *tagNewName;
            tagNewName = searchText;
            [self.filterArr insertObject:tagNewName atIndex:0];
            self.dataSource = self.filterArr;
            self.isShowAddCell = YES;
        }
        [self.tableView reloadData];

}


// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - setter
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64.0, [[UIScreen mainScreen] bounds].size.width, 44.0)];
        // searchbar
        _searchBar.showsCancelButton = NO;
        _searchBar.placeholder = @"输入你想搜索或创建的标签";
        _searchBar.delegate = self;

    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64.0f+44.0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-44.0f-64.0) style:UITableViewStylePlain];
        // tableView init
        _tableView.rowHeight = 44.0f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = COLOR_MAIN_SEPREATE;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = COLOR_MAIN_BG;
        
    }
    
    return _tableView;
}
@end
