//
//  NewsTextView.m
//  项目三
//
//  Created by Chrismith on 16/5/30.
//  Copyright © 2016年 Chrismith. All rights reserved.
//

#import "NewsTextView.h"

@implementation NewsTextView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.editable = NO;
    }
    return self;
    
}



- (void)imageAttachment{
    if (!self.imageAttachmentRegex) {
        return;
    }
    NSString *imgregex = self.imageAttachmentRegex;
    NSRegularExpression *imgregular = [NSRegularExpression regularExpressionWithPattern:imgregex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *imgresultSet = [imgregular matchesInString:self.text options:NSMatchingReportProgress range:NSMakeRange(0, self.text.length)];
    
    
    //[哈哈][馋嘴][大笑]
    //读取表情配置字典
//    NSArray *faceArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoticons.plist" ofType:nil]];
    
    [imgresultSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSTextCheckingResult *item = obj;
        
        //取得检索到的文本范围
//        NSRange range = item.range;
        
        //获取表情名[哈哈]
//        NSString *resultStr = [self.text substringWithRange:range];
        
        //使用谓词过滤出符合条件的字典
//        NSString *s = [NSString stringWithFormat:@"chs = '%@'",resultStr];
//        NSArray *result = [faceArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:s]];
//        NSDictionary *dic = [result firstObject];
        //取出对应的图片
//        NSString *imgName = dic[@"png"];

        
        
        
//        if (idx == 0) {
//            
//            [self.attString replaceCharactersInRange:range withAttributedString:imgAttString];
//        }else{
//            
//            [self.attString replaceCharactersInRange:NSMakeRange(range.location - (range.length - 1) * idx, range.length) withAttributedString:imgAttString];
//        }
        
    }];
    
}

@end
