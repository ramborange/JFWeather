//
//  SuggestionView.m
//  JFWeather
//
//  Created by ramborange on 16/8/2.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "SuggestionView.h"

@implementation SuggestionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [Utility GetLabelWithFrame:CGRectMake(10, 10, 100, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:20] textAlig:0 textColor:[UIColor darkGrayColor]];
        [self addSubview:_titleLabel];
        
        _brfLabel = [Utility GetLabelWithFrame:CGRectMake(frame.size.width-110, 10, 100, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:2 textColor:[UIColor orangeColor]];
        [self addSubview:_brfLabel];
        
        _txtLabel = [Utility GetLabelWithFrame:CGRectMake(10, 30, frame.size.width-20, 50) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:themeColor];
        [self addSubview:_txtLabel];
    }
    [self.layer setBorderColor:RGBA(232, 232, 232, 1).CGColor];
    [self.layer setBorderWidth:1.0];
    [self.layer setShadowColor:RGBA(220, 220, 220, 1).CGColor];
    [self.layer setShadowRadius:1.0];
    [self.layer setShadowOpacity:1.0];
    [self.layer setShadowOffset:CGSizeMake(1, 1)];
    return self;
}

- (void)reloadDataWithSuggestion:(SuggestionModel *)suggestionModel {
    _titleLabel.text = suggestionModel.title;
    _brfLabel.text = suggestionModel.brf;
    _txtLabel.text = suggestionModel.txt;
}

@end
