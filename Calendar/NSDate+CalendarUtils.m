//
//  NSDate+CalendarUtils.m
//  Calendar
//
//  Created by 전수열 on 3/1/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

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
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitWeekday |
                                                              NSCalendarUnitMonth | NSCalendarUnitYear)
                                                    fromDate:self];
    components.day = 1;
    return [self.calendar dateFromComponents:components];
}

- (NSInteger)firstWeekdayOfMonth
{
    return [self.calendar components:NSCalendarUnitWeekday fromDate:self.firstDateOfMonth].weekday;
}

- (NSInteger)columnForFirstDayInMonth
{
    return (self.firstWeekdayOfMonth - 1) % 7;
}

- (NSInteger)numberOfDaysInMonth
{
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}


@end
