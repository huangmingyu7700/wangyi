//
//  NewsDetailViewController.m
//  项目三
//
//  Created by Chrismith on 16/5/27.
//  Copyright © 2016年 Chrismith. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "RegexKitLite.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NewsDetailViewController ()
{
    NSString *_text;
    NSMutableArray *_imgaeArr;
    NSDictionary *_jsonDic;
}
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configNavigationBar];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 10, kScreenHeight - 84)];
    [self.view addSubview:_textView];

    [self GETFromUrlString:[NSString stringWithFormat:@"http://c.3g.163.com/nc/article/%@/full.html", _urlString]];
}

- (void)configNavigationBar
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 42, 42);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"top_navigation_back@2x"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"top_navigation_back_highlighted@2x"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtton;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 28, 28);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"top_navigation_more@2x"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"top_navigation_highlighted_more@2x"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)leftButtonAction:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)GETFromUrlString:(NSString *)urlString {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        _jsonDic = responseObject[_urlString];
        
        [self configTextView];
        
//        NSString *regex1 = @"<!--IMG#\\d{1,3}-->";
//        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSFontAttributeName : [UIFont systemFontOfSize:25]} documentAttributes:nil error:nil];
//        _textView.attributedText = attributeString;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
    
}

- (void)configTextView
{
    NSString *htmlString = _jsonDic[@"body"];
    _imgaeArr = _jsonDic[@"img"];
    NSString *regex2 = @"<p>[^<]*?</p>";
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth - 20, 40)];
    titleLabel.text = _titleText;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_textView addSubview:titleLabel];
    
    UILabel *otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, kScreenWidth - 20, 20)];
    otherLabel.text = [NSString stringWithFormat:@"%@ %@", _jsonDic[@"source"], _jsonDic[@"ptime"]];
    [_textView addSubview:otherLabel];
    otherLabel.textColor = [UIColor grayColor];
    otherLabel.font = [UIFont systemFontOfSize:14];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 75, kScreenWidth - 20, 200)];
    [imageView sd_setImageWithURL:[_imgaeArr firstObject][@"src"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [_textView addSubview:imageView];
    imageView.tag = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    
    NSString *textStr = [self getTheStringWithSourceString:htmlString regexString:regex2];
    textStr = [NSString stringWithFormat:@"\n\n\n%@", textStr];
    if (_imgaeArr.count != 0) {
        
        textStr = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n%@", textStr];
    }
    _textView.text = textStr;

}

- (NSString *)getTheStringWithSourceString:(NSString *)sourceString regexString:(NSString *)regex
{
    NSArray *items = [sourceString componentsMatchedByRegex:regex];
    NSString *textStrings = nil;
    for (NSString *string in items) {
        NSString *tempString = textStrings;
        if (textStrings.length == NULL) {
            textStrings = [NSString stringWithFormat:@"%@ \n\n", [string substringWithRange:NSMakeRange(5, string.length - 9)]];
            _textView.font = [UIFont systemFontOfSize:15];
        } else {
            textStrings = [NSString stringWithFormat:@"%@%@ \n\n", tempString, [string substringWithRange:NSMakeRange(5, string.length - 9)]];
        }
    }
    
    return textStrings;
}

- (NSMutableArray *)matchRangeArrWithSourceRanger:(NSString *)sourceString
{
    NSMutableArray *matchRangeArr = [NSMutableArray array];
    NSString *regexString = @"<strong>[^<]*?</strong>";
    NSRange matchedRange = NSMakeRange(NSNotFound, 0UL);
    NSRange searchRange = NSMakeRange(0, sourceString.length);
    matchedRange = [sourceString rangeOfRegex:regexString inRange:searchRange];
    [matchRangeArr addObject:[NSValue valueWithRange:matchedRange]];
    while (matchedRange.length != NULL) {
        searchRange = NSMakeRange(matchedRange.length + matchedRange.location, sourceString.length - matchedRange.length - matchedRange.location);
        matchedRange = [sourceString rangeOfRegex:regexString inRange:searchRange];
        [matchRangeArr addObject:[NSValue valueWithRange:matchedRange]];
    }
    
    return matchRangeArr;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"dddd");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
