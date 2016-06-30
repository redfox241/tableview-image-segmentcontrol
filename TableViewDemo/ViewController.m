//
//  ViewController.m
//  TableViewDemo
//
//  Created by rongfzh on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

//使用16进制
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]


#import "ViewController.h"



@interface ViewController ()

@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

@end

CGFloat imageViewHeight = 0;
CGFloat imageViewWidth = 0;

@implementation ViewController
@synthesize list = _list;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *arrayItem =[[NSMutableArray alloc] init];
    for( NSInteger index = 0; index < 30; index ++ ){
        [arrayItem addObject: [NSString stringWithFormat:@"%d",(10000 + index)] ];
    }
    
    self.list = arrayItem;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.list = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark Table View Data Source Methods 
- (NSInteger)tableView:(UITableView *)tableView   numberOfRowsInSection:(NSInteger)section {
    
    if( section == 0 ){
        return 1;
    }else{
        return [self.list count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if( indexPath.section == 0 ){
    
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        UIImage *img = [UIImage imageNamed:@"img_report_bg"];
        
        self.imageView = [[UIImageView alloc] initWithImage:img ];
        self.imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        self.imageView.layer.cornerRadius = 1;
        self.imageView.layer.masksToBounds = YES;
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill; // 图片充满imageview
        
        imageViewHeight = self.imageView.bounds.size.height;
        imageViewWidth  = self.imageView.bounds.size.width;
        
        [cell addSubview:self.imageView];
        
        return cell;
        
    }else{

        static NSString *TableSampleIdentifier = @"CellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: TableSampleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:TableSampleIdentifier];
        }
        
        NSUInteger row = [indexPath row];
        cell.textLabel.text = [self.list objectAtIndex:row];
        UIImage *image = [UIImage imageNamed:@"qq"];
        cell.imageView.image = image;
        UIImage *highLighedImage = [UIImage imageNamed:@"youdao"];
        cell.imageView.highlightedImage = highLighedImage;
        cell.detailTextLabel.text = @"详情...";
        
        
        return cell;
    }
 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 1 ){
        return 50;
    }else{
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger) section {
    
    if( section == 1){
        return 50;
    }else{
        return 0;
    }
    
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section {
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    
    if( section == 1 ){
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"国家",@"地区" ]];
        self.segmentedControl.segmentedControlStyle = UISegmentedControlSegmentCenter;
    }
    
    
    [container setBackgroundColor:UIColorFromHex(0x9FE8D8)];
    container.contentMode = UIViewContentModeCenter;
    self.segmentedControl.center = CGPointMake( screen_width / 2 , container.bounds.size.height / 2 );
    
    //[self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"t3"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//最后一个参数是横屏还是竖屏
//    [self.segmentedControl setDividerImage:[UIImage imageNamed:@"btn_my_setting"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//间隔图片
    
    [self.segmentedControl addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];

    [container addSubview:self.segmentedControl];
    
    return container;
}


-(void) segmentChange {
    NSLog(@"select header index item:%d",self.segmentedControl.selectedSegmentIndex );
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *rowString = [self.list objectAtIndex:[indexPath row]];

    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的行信息" message:rowString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect rect = self.imageView.frame;
    
    if( offsetY < 0 ){
        
        rect.origin.y = offsetY;
        rect.size.height = imageViewHeight - offsetY;
        rect.size.width  = imageViewWidth - offsetY;
        
        self.imageView.frame = rect;

    }
    
}


@end
