
/****
 VOORBEELDEN
 
 [UIColor colorWithRGBHex:0xff00ff];
 [UIColor colorWithHexString:@"0xff00ff"]
 *******/

#import <UIKit/UIKit.h>

#define SUPPORTS_UNDOCUMENTED_API	0

@interface UIColor (UIColor_Expanded)
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;

@property (nonatomic, readonly) UInt32 RGBHex; // Get rgb hex value of the color.
@property (nonatomic, readonly) UInt32 ARGBHex; // Get argb hex value of the color.


+ (UIColor *)randomColor; // Generate a random color.
+ (UIColor *)colorWithRGBHex:(UInt32)hex; // Generate a color with RGB hex.
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha; // Generate a color with RGB hex and alpha value.
+ (UIColor *)colorWithARGBHex:(UInt32)hex; // Generate a color with ARGB hex.
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert; // Generate a color with string of RGB hex.
+ (UIColor *)colorWithString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithName:(NSString *)cssColorName;


- (NSString *)stringFromColor; // Return a string contained ARGB.
- (NSString *)hexStringFromColor; // Return a hex string contained ARGB.

- (UIColor *)highlightedColor; // Return a highlighted color.
- (UIColor *)shadowColor; // Return a shadow color.




- (NSString *)colorSpaceString;

- (NSArray *)arrayFromRGBAComponents;

- (BOOL)red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;

- (UIColor *)colorByLuminanceMapping;

- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)colorByAdding:(CGFloat)f;
- (UIColor *)colorByLighteningTo:(CGFloat)f;
- (UIColor *)colorByDarkeningTo:(CGFloat)f;

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)colorByAddingColor:(UIColor *)color;
- (UIColor *)colorByLighteningToColor:(UIColor *)color;
- (UIColor *)colorByDarkeningToColor:(UIColor *)color;

- (BOOL)isDark;
@end

#if SUPPORTS_UNDOCUMENTED_API
// UIColor_Undocumented_Expanded
// Methods which rely on undocumented methods of UIColor
@interface UIColor (UIColor_Undocumented_Expanded)
- (NSString *)fetchStyleString;
- (UIColor *)rgbColor; // Via Poltras
@end
#endif // SUPPORTS_UNDOCUMENTED_API
