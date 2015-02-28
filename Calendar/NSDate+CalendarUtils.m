//
//  NSDate+CalendarUtils.m
//  Calendar
//
//  Created by 전수열 on 3/1/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

#import <objc/runtime.h>
#import "NSDate+CalendarUtils.h"

@implementation NSDate (CalendarUtils)


#pragma mark - Calendar

- (NSCalendar *)calendar
{
    return [NSCalendar currentCalendar];
}


#pragma mark - Components

- (NSInteger)year
{
    return [self.calendar components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)month
{
    return [self.calendar components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)day
{
    return [self.calendar components:NSCalendarUnitDay fromDate:self].day;
}


#pragma mark - Month

- (NSDate *)prevMonth
{
    return [self dateByAddingMonth:-1];
}

- (NSDate *)nextMonth
{
    return [self dateByAddingMonth:1];
}

- (NSDate *)dateByAddingMonth:(NSInteger)month
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    components.month += month;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)firstDateOfMonth
{
    NSDate *date = objc_getAssociatedObject(self, @selector(firstDateOfMonth));
    if (!date) {
        NSDateComponents *components = [self.calendar components:NSCalendarUnitDay fromDate:self];
        components.day = 1;
        date = [self.calendar dateFromComponents:components];
        objc_setAssociatedObject(self, @selector(firstDateOfMonth), date, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return date;
}

- (NSInteger)firstWeekdayOfMonth
{
    NSNumber *weekday = objc_getAssociatedObject(self, @selector(firstWeekdayOfMonth));
    if (!weekday) {
        weekday = @([self.calendar components:NSCalendarUnitWeekday fromDate:self.firstDateOfMonth].weekday);
        objc_setAssociatedObject(self, @selector(firstWeekdayOfMonth), weekday, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return weekday.integerValue;
}

- (NSInteger)columnForFirstDayInMonth
{
    NSNumber *column = objc_getAssociatedObject(self, @selector(columnForFirstDayInMonth));
    if (!column) {
        column = @((self.firstWeekdayOfMonth - 1) % 7);
        objc_setAssociatedObject(self, @selector(columnForFirstDayInMonth), column, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return column.integerValue;
}

- (NSInteger)numberOfWeeksInMonth
{
    return [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self].length;
}

- (NSInteger)numberOfDaysInMonth
{
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}


@end
