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


#pragma mark - Cache

- (id)cachedValueForKey:(const void *)key cacheBlock:(id (^)(void))cacheBlock
{
    id value = objc_getAssociatedObject(self, key);
    if (!value) {
        value = cacheBlock();
        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}


#pragma mark - Calendar

- (NSCalendar *)calendar
{
    return [self cachedValueForKey:@selector(year)
                  cacheBlock:^id {
                      return [NSCalendar currentCalendar];
                  }];
}


#pragma mark - Components

- (NSInteger)year
{
    return [[self cachedValueForKey:@selector(year)
                         cacheBlock:^id {
                             return @([self.calendar components:NSCalendarUnitYear fromDate:self].year);
                         }] integerValue];
}

- (NSInteger)month
{
    return [[self cachedValueForKey:@selector(month)
                         cacheBlock:^id {
                             return @([self.calendar components:NSCalendarUnitYear fromDate:self].month);
                         }] integerValue];
}

- (NSInteger)day
{
    return [[self cachedValueForKey:@selector(day)
                         cacheBlock:^id {
                             return @([self.calendar components:NSCalendarUnitYear fromDate:self].day);
                         }] integerValue];
}


#pragma mark - Month

- (NSDate *)prevMonth
{
    return [self cachedValueForKey:@selector(prevMonth)
                        cacheBlock:^id {
                            return [self dateByAddingMonth:-1];
                        }];
}

- (NSDate *)nextMonth
{
    return [self cachedValueForKey:@selector(nextMonth)
                        cacheBlock:^id {
                            return [self dateByAddingMonth:+1];
                        }];
}

- (NSDate *)dateByAddingMonth:(NSInteger)month
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    components.month += month;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)firstDateOfMonth
{
    return [self cachedValueForKey:@selector(firstDateOfMonth)
                        cacheBlock:^id {
                            NSDateComponents *components = [self.calendar components:(NSCalendarUnitDay |
                                                                                      NSCalendarUnitMonth |
                                                                                      NSCalendarUnitYear)
                                                                            fromDate:self];
                            components.day = 1;
                            return [self.calendar dateFromComponents:components];
                        }];
}

- (NSInteger)firstWeekdayOfMonth
{
    return [[self cachedValueForKey:@selector(firstWeekdayOfMonth)
                         cacheBlock:^id {
                             return @([self.calendar components:NSCalendarUnitWeekday
                                                       fromDate:self.firstDateOfMonth].weekday);
                         }] integerValue];
}

- (NSInteger)columnForFirstDayInMonth
{
    return [[self cachedValueForKey:@selector(columnForFirstDayInMonth)
                         cacheBlock:^id {
                             return @((self.firstWeekdayOfMonth - 1) % 7);
                         }] integerValue];
}

- (NSInteger)numberOfWeeksInMonth
{
    return [[self cachedValueForKey:@selector(numberOfWeeksInMonth)
                         cacheBlock:^id {
                             return @([self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth
                                                          inUnit:NSCalendarUnitMonth
                                                         forDate:self].length);
                         }] integerValue];
}

- (NSInteger)numberOfDaysInMonth
{
    return [[self cachedValueForKey:@selector(numberOfDaysInMonth)
                         cacheBlock:^id {
                             return @([self.calendar rangeOfUnit:NSCalendarUnitDay
                                                          inUnit:NSCalendarUnitMonth
                                                         forDate:self].length);
                         }] integerValue];
}


@end
