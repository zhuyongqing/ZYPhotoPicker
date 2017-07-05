//
//  ZYPhotoPickToolView.m
//  ZYPhotoPicker
//
//  Created by zhuyongqing on 2017/7/5.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ZYPhotoPickToolView.h"

@interface ZYPhotoPickToolView()

@property(nonatomic,strong) UIButton *doneBtn;

@property(nonatomic,strong) UILabel *numberLabel;

@property(nonatomic,strong) UIButton *previousBtn;

@property(nonatomic,strong) UIView *line;


@end

@implementation ZYPhotoPickToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
        
        _previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previousBtn setTitle:NSLocalizedString(@"预览", nil) forState:UIControlStateNormal];
        [_previousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previousBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_previousBtn addTarget:self action:@selector(previousBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_previousBtn setEnabled:NO];
        _previousBtn.alpha = .4;
        [self addSubview:_previousBtn];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.backgroundColor = [UIColor blackColor];
        _numberLabel.font = [UIFont systemFontOfSize:13];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.hidden = YES;
        [self addSubview:_numberLabel];
        
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_doneBtn addTarget:self action:@selector(doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_doneBtn setEnabled:NO];
        _doneBtn.alpha = .4;
        [self addSubview:_doneBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat leftSpace = 15;
    CGFloat labelSpace = 10;
    _line.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), .5);
    [_previousBtn sizeToFit];
    _previousBtn.frame = CGRectMake(leftSpace, 0, CGRectGetWidth(_previousBtn.frame), CGRectGetHeight(self.frame));
    [_doneBtn sizeToFit];
    _doneBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(_doneBtn.frame) - leftSpace, 0, CGRectGetWidth(self.doneBtn.frame), CGRectGetHeight(self.frame));
    
    CGFloat numberLabelHeight = 25;
    _numberLabel.layer.cornerRadius = numberLabelHeight/2;
    _numberLabel.layer.masksToBounds = YES;
    _numberLabel.frame = CGRectMake(CGRectGetMinX(_doneBtn.frame) - labelSpace - numberLabelHeight, CGRectGetHeight(self.frame)/2 - numberLabelHeight/2, numberLabelHeight, numberLabelHeight);
}

- (void)setCount:(NSInteger)count{
    _count = count;
    _doneBtn.alpha = count > 0 ? 1:.4;
    _doneBtn.enabled = count;
    _previousBtn.enabled = count;
    _previousBtn.alpha = _doneBtn.alpha;
    _numberLabel.hidden = !count;
    _numberLabel.text = [NSString stringWithFormat:@"%ld",count];
}

- (void)previousBtnAction{
    _toolViewBlock(ZYPhotoPickBtnTypePrevious);
}

- (void)doneBtnAction{
    _toolViewBlock(ZYPhotoPickBtnTypeDone);
}

@end
