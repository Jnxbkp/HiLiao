

#import "jiaYouYZBankTableViewCell.h"
@interface jiaYouYZBankTableViewCell ()

@property (strong, nonatomic) NSArray *payArray;

@end
@implementation jiaYouYZBankTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    self.payArray = @[@"支付宝"];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    NSString *str = self.payArray[index];
    self.bankTitle.text = str;
    self.bankImage.contentMode = UIViewContentModeScaleAspectFit;
    self.tuijian.layer.masksToBounds = YES;
    self.tuijian.layer.cornerRadius=3;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
         self.bankSelect.image = [UIImage imageNamed:@"order_pre_select"];
      
    } else {
         self.bankSelect.image = [UIImage imageNamed:@"order_nor_select"];
    }
    // Configure the view for the selected state
}

@end
