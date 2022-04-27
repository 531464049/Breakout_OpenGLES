//
//  NSString+MH.m
//  LS
//
//  Created by mahao on 2020/1/7.
//  Copyright © 2020 Xrobot. All rights reserved.
//

#import "NSString+MH.h"

@implementation NSString (MH)

#pragma mark - 根据字体及宽度计算文字高度 无行间距字间距
-(CGFloat)textForLabHeightWithTextWidth:(CGFloat)width font:(UIFont *)textFont
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.height + 5;
}
#pragma mark - 根据字体及高度计算文字宽度 无行间距字间距
-(CGFloat)textForLabWidthWithTextHeight:(CGFloat)height font:(UIFont *)textFont
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.width + 5;
}
#pragma mark - 根据字体及宽度计算文字宽度 行间距字间距
-(CGFloat)textHeight:(UIFont *)textFont width:(CGFloat)width lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming
{
    return [self textHeight:textFont width:width lineSpace:lineSpace keming:keming aligent:NSTextAlignmentLeft];
}
-(CGFloat)textHeight:(UIFont *)textFont width:(CGFloat)width lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming aligent:(NSTextAlignment )aligent
{
    if (self.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = aligent;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@(keming)};
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
}
#pragma mark - 转化为带行间距 字间距的attbutedStr
-(NSAttributedString *)attributedStr:(UIFont *)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming
{
    return [self attributedStr:textFont textColor:textColor lineSpace:lineSpace keming:keming aligent:NSTextAlignmentLeft];
}
-(NSAttributedString *)attributedStr:(UIFont *)textFont textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace keming:(CGFloat)keming aligent:(NSTextAlignment )aligent
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = aligent;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@(keming)};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self attributes:dic];
    
    return attributeStr;
}


// 十六进制转换为普通字符串的。
-(NSString *)hexStringToString;
{
    if(!self || [self isEqualToString:@""]){
        return self;
    }
    char *myBuffer = (char *)malloc((int)[self length] / 2 + 1);
    bzero(myBuffer, [self length] / 2 + 1);
    for (int i = 0; i < [self length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    free(myBuffer);
    return unicodeString;
}
#pragma mark - 转16进制字符串
-(NSString *)hexString
{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}
#pragma mark - json转dic
-(NSDictionary *)jsonToDic
{
    if (!self || self.length == 0) {
        return [NSDictionary dictionary];
    }

    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
