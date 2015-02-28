//
//  CalendarCell.m
//  Calendar
//
//  Created by 전수열 on 3/1/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

#import "CalendarCell.h"

@interface CalendarCell ()

@property (nonatomic, strong) UILabel *dayLabel;

@end

@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.dayLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.dayLabel];
    }
    return self;
}

- (void)setDay:(NSInteger)day
{
    _day = day;
    if (day > 0) {
        self.dayLabel.hidden = NO;
        self.userInteractionEnabled = YES;
        self.dayLabel.text = @(day).stringValue;
        [self setNeedsLayout];
    } else {
        self.dayLabel.hidden = YES;
        self.userInteractionEnabled = NO;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.dayLabel sizeToFit];
    self.dayLabel.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
}

@end
