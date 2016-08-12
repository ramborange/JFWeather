//
//  SuggestionView.h
//  JFWeather
//
//  Created by ramborange on 16/8/2.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *brfLabel;
@property (nonatomic, strong) UILabel *txtLabel;
- (void)reloadDataWithSuggestion:(SuggestionModel *)suggestionModel;
@end
