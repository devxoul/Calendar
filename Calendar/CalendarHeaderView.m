//
//  CalendarHeaderView.m
//  Calendar
//
//  Created by 전수열 on 3/1/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

#import "CalendarHeaderView.h"
#import "NSDate+CalendarUtils.h"

@interface CalendarHeaderView ()

@property (nonatomic, strong) UILabel *monthLabel;

@end

@implementation CalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.monthLabel = [[UILabel alloc] init];
        self.monthLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.monthLabel];
    }
    return self;
}

+ (CGFloat)height
{
    return 30;
}

+ (NSDateFormatter *)formatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyyMMM"
                                                               options:0
                                                                locale:[NSLocale currentLocale]];
    });
    return formatter;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    self.monthLabel.text = [self.class.formatter stringFromDate:date];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [self.monthLabel sizeToFit];
    self.monthLabel.center = CGPointMake(self.monthLabel.center.x, CGRectGetHeight(self.bounds) / 2);
}

@end
