//
//  CollectionViewBaseClass.m
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "CollectionViewBaseClass.h"

@interface CollectionViewBaseClass ()

@end

@implementation CollectionViewBaseClass

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAlwaysBounceHorizontal:YES];
    }
    return self;
}

- (EKEventStore *)eventStore
{
    if (!_eventStore) {
        _eventStore = [EKEventStore new];
    }

    return _eventStore;
}

- (NSUInteger)numberOfLists
{
    return [self.eventStore calendarsForEntityType:EKEntityTypeReminder].count;
}

- (EKCalendar *)calendarAtIndex:(NSInteger)index
{
    NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];

    if (index >= 0 && index < calendars.count) {
        return calendars[index];
    }

    return nil;
}

- (void)requestListsFromCalendar:(EKCalendar *)calendar
                  withCompletion:(ReminderAccessCompletionBlock)completion
{
    EKEventStore *store = self.eventStore;
    NSPredicate *predicate = [store predicateForRemindersInCalendars:@[calendar]];

    [store fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES,[reminders copy]);
        });
    }];
}

- (LXReorderableCollectionViewFlowLayout *)topCollectionFlowLayout
{
    static LXReorderableCollectionViewFlowLayout *layout = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        layout = [[LXReorderableCollectionViewFlowLayout alloc] init];

        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setSectionInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [layout setMinimumInteritemSpacing:0.0];
        [layout setMinimumLineSpacing:0.0];
        [layout setItemSize:CGSizeMake(cellWidth, cellHeight)];
        [layout setHeaderReferenceSize:CGSizeMake(73.0, cellHeight)];
        [layout setFooterReferenceSize:CGSizeMake(73.0, cellHeight)];
    });

    return layout;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
