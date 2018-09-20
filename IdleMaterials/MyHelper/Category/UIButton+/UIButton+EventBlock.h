
#import <UIKit/UIKit.h>
#import <objc/runtime.h>


typedef void (^EventBlock)(UIButton * button);

@interface UIButton(EventBlock)

@property (readonly) NSMutableDictionary *event;

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(EventBlock)action;


@end
