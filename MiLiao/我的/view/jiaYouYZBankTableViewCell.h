

#import <UIKit/UIKit.h>

@interface jiaYouYZBankTableViewCell : UITableViewCell

@property (assign, nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UIImageView *bankImage;
@property (weak, nonatomic) IBOutlet UILabel *bankTitle;
@property (weak, nonatomic) IBOutlet UIImageView *bankSelect;
@property (weak, nonatomic) IBOutlet UILabel *tuijian;
@end
