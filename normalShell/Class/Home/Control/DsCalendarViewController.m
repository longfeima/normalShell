//
//  DsCalendarViewController.m
//  normalShell
//
//  Created by Seven on 2018/2/23.
//  Copyright © 2018年 Seven. All rights reserved.
//

#import "DsCalendarViewController.h"
#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekDayView.h"
#import "LTSCalendarManager.h"


@interface DsCalendarViewController ()<LTSCalendarEventSource>{
    NSMutableDictionary *eventsByDate;
}

@property (nonatomic,strong)LTSCalendarContentView *calendarView;

@property (nonatomic,strong)LTSCalendarManager *manager;
@property (nonatomic, strong) UILabel *timeLb;
@end

@implementation DsCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self tableView];
//    self.navigationView.navType = DD_NormalType;
    
//    self.navigationView.title = DSLocalizedString(DS_HOME_CALENDAR_TITLE);
    self.title = DSLocalizedString(DS_HOME_CALENDAR_TITLE);
    [self configNormal];
}

- (void)preClick:(UIButton *)btn{
    [self.manager loadPreviousPage];
}

- (void)nextClick:(UIButton *)btn{
    [self.manager loadNextPage];
}

- (void)configNormal{
    UIButton *preBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH/2 - 50, 40)];
    [self.view addSubview:preBtn];
    [preBtn setTitle:DSLocalizedString(DS_HOME_CALENDAR_BTN_PREVIEW) forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor colorWithRed:133./256. green:205./256. blue:243./256. alpha:1.] forState:UIControlStateNormal];
    [preBtn addTarget:self action:@selector(preClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeLb = [[UILabel alloc]initWithFrame:CGRectMake(DS_APP_SIZE_WIDTH/2 - 50, DS_APP_NAV_HEIGHT, 100, 40)];
    [self.view addSubview:self.timeLb];
    
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(DS_APP_SIZE_WIDTH/2 + 50, DS_APP_NAV_HEIGHT, DS_APP_SIZE_WIDTH/2 - 50, 40)];
    [self.view addSubview:nextBtn];
    [nextBtn setTitleColor:[UIColor colorWithRed:133./256. green:205./256. blue:243./256. alpha:1.] forState:UIControlStateNormal];
    [nextBtn setTitle:DSLocalizedString(DS_HOME_CALENDAR_BTN_NEXT) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, DS_APP_NAV_HEIGHT + 40, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame))];
    [self.view addSubview:self.manager.calenderScrollView];
    [self createRandomEvents];
    self.automaticallyAdjustsScrollViewInsets = false;
    
}




// 该日期是否有事件
- (BOOL)calendarHaveEventWithDate:(NSDate *)date {
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)date {
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    self.timeLb.text =  key;
    NSArray *events = eventsByDate[key];
    self.title = key;
    NSLog(@"%@",date);
    if (events.count>0) {
        
        //该日期有事件    tableView 加载数据
    }
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
    [self.manager reloadAppearanceAndData];
}
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    return dateFormatter;
}


@end
