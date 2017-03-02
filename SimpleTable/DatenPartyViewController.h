#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
- (IBAction)reload:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
- (IBAction)loadOptions:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *optionView;
- (IBAction)infoDown:(id)sender;
- (IBAction)ratingChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *ratingButton;
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startDown:(id)sender;


@end
