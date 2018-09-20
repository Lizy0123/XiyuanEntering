
#import "UIButton+EventBlock.h"


@implementation UIButton(EventBlock)

static char overviewKey;
@dynamic event;


- (void)handleControlEvent:(UIControlEvents)event withBlock:(EventBlock)block
{
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    EventBlock block = (EventBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block(self);
    }
}


@end
