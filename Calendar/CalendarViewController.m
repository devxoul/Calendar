//
//  CalendarViewController.h
//  Calendar
//
//  Created by 전수열 on 3/1/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarHeaderView.h"
#import "CalendarCell.h"
#import "NSDate+CalendarUtils.h"

@interface CalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *visibleMonths;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CalendarViewController

- (instancetype)init
{
    return [self initWithDate:[NSDate date]];
}

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.visibleMonths = @[[date dateByAddingMonth:-2],
                               date.prevMonth,
                               date,
                               date.nextMonth,
                               [date dateByAddingMonth:2]].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat headerHeight = [CalendarHeaderView height];
    NSInteger cellWidth = CGRectGetWidth(self.view.bounds) / 7;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), headerHeight);
    layout.itemSize = CGSizeMake(cellWidth, cellWidth);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:CalendarCell.class forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:CalendarHeaderView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionTop
                                        animated:NO];
    self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentOffset.y - headerHeight);
}


#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.visibleMonths.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    CalendarHeaderView *headerView = [collectionView
                                      dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                      withReuseIdentifier:@"header"
                                      forIndexPath:indexPath];
    headerView.date = self.visibleMonths[indexPath.section];
    return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDate *month = self.visibleMonths[section];
    return month.columnForFirstDayInMonth + month.numberOfDaysInMonth;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDate *month = self.visibleMonths[indexPath.section];
    cell.day = indexPath.item - month.columnForFirstDayInMonth + 1;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view
        forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        [self preparePrevMonth];
    } else if (scrollView.contentOffset.y >= scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds)) {
        [self prepareNextMonth];
    }
}


#pragma mark - Prepare Month

- (void)preparePrevMonth
{
    self.collectionView.delegate = nil;

    NSDate *firstMonth = self.visibleMonths.firstObject;
    [self.visibleMonths removeLastObject];
    [self.visibleMonths insertObject:firstMonth.prevMonth atIndex:0];

    firstMonth = self.visibleMonths.firstObject;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat sectionHeight = firstMonth.numberOfWeeksInMonth * layout.itemSize.height + [CalendarHeaderView height];
    self.collectionView.contentOffset = CGPointMake(0, sectionHeight);
    [self.collectionView reloadData];

    self.collectionView.delegate = self;
}

- (void)prepareNextMonth
{
    self.collectionView.delegate = nil;

    NSDate *firstMonth = self.visibleMonths.firstObject;
    NSDate *lastMonth = self.visibleMonths.lastObject;
    [self.visibleMonths removeObjectAtIndex:0];
    [self.visibleMonths addObject:lastMonth.nextMonth];

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat sectionHeight = firstMonth.numberOfWeeksInMonth * layout.itemSize.height + [CalendarHeaderView height];
    self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentOffset.y - sectionHeight);
    [self.collectionView reloadData];

    self.collectionView.delegate = self;
}

@end
