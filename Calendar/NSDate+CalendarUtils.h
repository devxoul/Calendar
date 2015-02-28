//
//  NSDate+CalendarUtils.h
//  Calendar
//
//  Created by 전수열 on 3/1/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarUtils)

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSDate *)prevMonth;
- (NSDate *)nextMonth;
- (NSDate *)dateByAddingMonth:(NSInteger)month;
- (NSDate *)firstDateOfMonth;
- (NSInteger)firstWeekdayOfMonth;
- (NSInteger)columnForFirstDayInMonth;
- (NSInteger)numberOfWeeksInMonth;
- (NSInteger)numberOfDaysInMonth;

@end
