#import "DatenPartyCell.h"

@implementation DatenPartyCell
@synthesize NameLabel = _NameLabel;
@synthesize TextLabel = _TextLabel;
@synthesize TimeLabel = _TimeLabel;
@synthesize AccountNameLabel = _AccountLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}


@end
