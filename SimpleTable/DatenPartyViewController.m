#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1
#import "DatenPartyViewController.h"
#import "DatenPartyCell.h"
#import "DatenPartyCategory.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "KLCPopup/KLCPopup.h"
#import "BEMCheckBox/BEMCheckBox.h"

@interface ViewController ()

@end
@implementation ViewController
{
    NSArray *NameData;
    NSArray *CategoryData;
    NSArray *TimeData;
    NSArray *TextData;
    NSArray *LinkData;
    NSArray *YesData;
    NSArray *NoData;
    NSArray *IdData;
}
UIAlertController *networkAlert;
NSTimer *updateTimer;
NSTimer *networkTimer;
UISwipeGestureRecognizer *topSwipeGesture;
UISwipeGestureRecognizer *downSwipeGesture;
UITapGestureRecognizer *tapGesture;
//UIView *popupView;
KLCPopup* popup;
bool makeEmpty=NO;
bool upBool=NO;
bool downBool=NO;
int cellColorChange;
int reload = 0;
int cellHeight = 200;
int noArray[999999];
int yesArray[999999];
int a = 0;
int option = 0;
NSData* jsonData;
int scroll = 0;
int rating = 0;
UIView *categoryView[10];
UIImageView *swipeIcon[10];
UILabel *categoryLabel[10];
UITableView *newsView[10];

@synthesize headerView, reloadButton, optionView, ratingButton, popupView, startButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor colorWithRed:0.13 green:0.14 blue:0.16 alpha:1.0];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    startButton.layer.cornerRadius = 7;
    
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.frame = CGRectMake(0, 0, 217, 225);
    popupView.layer.cornerRadius = 10;
    popup = [KLCPopup popupWithContentView:popupView];
    [popup show];
    
    optionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, self.view.frame.size.height)];
    optionView.layer.zPosition = -1;
    optionView.tag = 161;
    
    for(int x = 0; x<=4; x++){
        swipeIcon[x] = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20, 200+x*30, 15, 15)];
        swipeIcon[x].layer.zPosition = 3;
        swipeIcon[x].image=[UIImage imageNamed:@"SwipeIconDisabled.png"];
        [self.view addSubview:swipeIcon[x]];
        
        categoryView[x] = [[UIView alloc] initWithFrame:self.view.frame];
        categoryLabel[x] = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 400, 30)];
        categoryLabel[x].textColor = [UIColor whiteColor];
        categoryLabel[x].font = [UIFont fontWithName:@"GujaratiSangamMN-Bold" size:25];
        newsView[x] = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, self.view.frame.size.height-270) style:UITableViewStylePlain];
        newsView[x].contentSize = CGSizeMake(self.view.frame.size.width-40, self.view.frame.size.height-370);
        [newsView[x] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        newsView[x].layer.position = CGPointMake(155, 190);
        newsView[x].delegate = self;
        newsView[x].dataSource = self;
        newsView[x].backgroundColor = [UIColor clearColor];
        newsView[x].layer.cornerRadius = 10;
        newsView[x].scrollEnabled = NO;
        newsView[x].tag = x;
        
        switch(x){
            case 0: categoryView[x].backgroundColor = [UIColor colorWithRed:0.13 green:0.14 blue:0.16 alpha:1.0];
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x, categoryView[x].layer.position.y);
                categoryLabel[x].text = @"Anschlag in Berlin";
                swipeIcon[x].image=[UIImage imageNamed:@"SwipeIconActive.png"];
                newsView[x].scrollEnabled = YES;
                break;
            case 1: categoryView[x].backgroundColor = [UIColor colorWithRed:0.19 green:0.20 blue:0.22 alpha:1.0];
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x, categoryView[x].layer.position.y+350);
                categoryLabel[x].text = @"Nobelpreisverleihung";
                break;
            case 2: categoryView[x].backgroundColor = [UIColor colorWithRed:0.25 green:0.26 blue:0.28 alpha:1.0];
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x, categoryView[x].layer.position.y+400);
                categoryLabel[x].text = @"Trumps Ernennung";
                break;
            case 3: categoryView[x].backgroundColor = [UIColor colorWithRed:0.31 green:0.32 blue:0.34 alpha:1.0];
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x, categoryView[x].layer.position.y+450);
                categoryLabel[x].text = @"G20 Gipfel";
                break;
            case 4: categoryView[x].backgroundColor = [UIColor colorWithRed:0.37 green:0.38 blue:0.40 alpha:1.0];
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x, categoryView[x].layer.position.y+600);
                categoryLabel[x].text = @"Flugzeugunglück";
                newsView[x].frame = CGRectMake(newsView[x].frame.origin.x, newsView[x].frame.origin.y, newsView[x].frame.size.width, self.view.frame.size.height-70);
                break;
        }
        categoryView[x].layer.cornerRadius = 10;
        categoryView[x].layer.zPosition = 1;
        categoryView[x].layer.shadowOffset = CGSizeMake(0, 2);
        categoryView[x].layer.shadowColor = [UIColor blackColor].CGColor;
        categoryView[x].layer.shadowRadius = 8.0f;
        categoryView[x].layer.shadowOpacity = 0.7f;
        categoryView[x].layer.shadowPath = [[UIBezierPath bezierPathWithRect:categoryView[x].layer.bounds] CGPath];
        [self.view addSubview:categoryView[x]];
        [categoryView[x] addSubview:categoryLabel[x]];
        [categoryView[x] addSubview:newsView[x]];
    }
    
    newsView[scroll].hidden = NO;
    
    topSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlesSwipe:)];
    downSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlesSwipe:)];
    
    topSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    downSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:topSwipeGesture];
    [self.view addGestureRecognizer:downSwipeGesture];
    
    headerView.layer.zPosition = 2;
    headerView.layer.shadowOffset = CGSizeMake(0, 2);
    headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.layer.shadowRadius = 8.0f;
    headerView.layer.shadowOpacity = 0.7f;
    headerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:headerView.layer.bounds] CGPath];
    [self.view addSubview:headerView];
    
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadAction) userInfo:nil repeats:NO];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tweets" ofType:@"plist"];
        
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NameData = [dict objectForKey:@"author"];
        TimeData = [dict objectForKey:@"date"];
        LinkData = [dict objectForKey:@"link"];
        CategoryData = [dict objectForKey:@"category"];
        YesData = [dict objectForKey:@"yes"];
        NoData = [dict objectForKey:@"no"];
        TextData = [dict objectForKey:@"article"];
        IdData = [dict objectForKey:@"id"];
        makeEmpty = YES;
        for(int x = 0; x<=5; x++){
            [newsView[x] reloadData];
        }
        makeEmpty = NO;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001"]] encoding:NSUTF8StringEncoding error:&error];
            if(jsonString==NULL){
                networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This service is currently unavailable.1" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:networkAlert animated:YES completion:nil];
                networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
                jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\",\"category\":\"\"}]"];
            }
            jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
            for (int i=0; i<[allKeys count]; i++) {
                NSDictionary *arrayResult = [allKeys objectAtIndex:i];
                NameData = [dict objectForKey:@"author"];
                TimeData = [dict objectForKey:@"date"];
                LinkData = [dict objectForKey:@"link"];
                YesData = [dict objectForKey:@"yes"];
                NoData = [dict objectForKey:@"no"];
                TextData = [dict objectForKey:@"article"];
                IdData = [dict objectForKey:@"id"];
                CategoryData = [dict objectForKey:@"category"];
            }
        });
    }else{
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadAction) userInfo:nil repeats:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\",\"category\":\"\"}]"];
            jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
            for (int i=0; i<[allKeys count]; i++) {
                NSDictionary *arrayResult = [allKeys objectAtIndex:i];
                TimeData = [TimeData arrayByAddingObject:[arrayResult objectForKey:@"date"]];
                NameData = [NameData arrayByAddingObject:[arrayResult objectForKey:@"author"]];
                LinkData = [LinkData arrayByAddingObject:[arrayResult objectForKey:@"link"]];
                TextData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"article"]];
                IdData = [IdData arrayByAddingObject:[arrayResult objectForKey:@"id"]];
                CategoryData = [CategoryData arrayByAddingObject:[arrayResult objectForKey:@"category"]];
                YesData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"yes"]];
                NoData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"no"]];
                yesArray[a] = [[arrayResult objectForKey:@"yes"] floatValue];
                noArray[a] = [[arrayResult objectForKey:@"no"] floatValue];
                a++;
            }
        });
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)networkTimer{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        [networkAlert dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)refreshTable {
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your network status." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:networkAlert animated:YES completion:nil];
        networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
    }else{
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001"]] encoding:NSUTF8StringEncoding error:&error];
        if(jsonString==NULL){
            networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This service is currently unavailable.2" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:networkAlert animated:YES completion:nil];
            networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
                jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\",\"category\":\"\"}]"];
        }
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        for(int x = 0; x<=5; x++){
            [newsView[x] setContentOffset:CGPointZero animated:YES];
        }
        makeEmpty = YES;
        for(int x = 0; x<=5; x++){
            [newsView[x] reloadData];
        }
        makeEmpty = NO;
        for(int x = 0; x<=5; x++){
            [newsView[x] endUpdates];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        NSError *error;
        NSError *jsonError;
        NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001"]] encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"JSON: %@", jsonString);
        if(jsonString==NULL){
            networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This service is currently unavailable." preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:networkAlert animated:YES completion:nil];
            networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
            jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\",\"category\":\"\"}]"];
        }
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"Data 1");
        id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    if(makeEmpty){
        return [allKeys count];
    }else{
        return [NameData count];
    }
    }else{
        NSString *jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\",\"category\":\"\"}]"];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateHeightForConfiguredSizingCell:indexPath];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable){
        static NSString *DatenPartyIdentifier = @"DatenPartyCell";
        
        DatenPartyCell *cell = (DatenPartyCell *)[tableView dequeueReusableCellWithIdentifier:DatenPartyIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DatenPartyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        float length = ceil(([[TextData objectAtIndex:indexPath.row] length]/37.0f));
        if(length>=8){
            length = 8;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.NameLabel.text = [NameData objectAtIndex:indexPath.row];
        cell.thumbnailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [NameData objectAtIndex:indexPath.row]]];
        cell.thumbnailImageView.layer.cornerRadius = 5;
        cell.thumbnailImageView.layer.masksToBounds = YES;
        cell.TimeLabel.text = [TimeData objectAtIndex:indexPath.row];
        cell.TextLabel.text = [TextData objectAtIndex:indexPath.row];
        cell.TextLabel.frame = CGRectMake(60, 18, cell.TextLabel.frame.size.width, (length+1)*13.5);

        cell.cellView.layer.cornerRadius = 5;
        if(rating == 0){
            cell.trustBar.hidden = YES;
            cell.trustButton.hidden = YES;
            cell.untrustButton.hidden = YES;
            cell.middleView.hidden = YES;
            cell.cellView.frame = CGRectMake(cell.cellView.frame.origin.x, cell.cellView.frame.origin.y, cell.cellView.frame.size.width, (length+1.8)*13.5);
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, (length+13)*13.5);
            cellHeight=cell.TextLabel.frame.size.height+20;
        }else{
            cell.trustBar.hidden = NO;
            cell.trustButton.hidden = NO;
            cell.untrustButton.hidden = NO;
            cell.middleView.hidden = NO;
            cell.cellView.frame = CGRectMake(cell.cellView.frame.origin.x, cell.cellView.frame.origin.y, cell.cellView.frame.size.width, (length+4.8)*13.5);
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, (length+10)*13.5);
            cellHeight=cell.TextLabel.frame.size.height+60;
        }
        cell.trustButton.tag = indexPath.row;
        [cell.trustButton addTarget:self
                             action:@selector(trustButtonDown:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        cell.untrustButton.tag = indexPath.row;
        [cell.untrustButton addTarget:self
                               action:@selector(untrustButtonDown:)
                     forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *linkButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        linkButton.tag=indexPath.row;
        [linkButton addTarget:self
                       action:@selector(linkDown:) forControlEvents:UIControlEventTouchUpInside];
        linkButton.frame = CGRectMake(30, 40, 265, cell.TextLabel.frame.size.height+20);
        [cell.contentView addSubview:linkButton];
        
        cell.layer.cornerRadius = 10;
        cell.trustBar.layer.cornerRadius = 2;
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [cell.trustBar.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
        float trust = (float)yesArray[indexPath.row]/(float)(yesArray[indexPath.row]+noArray[indexPath.row]);
        NSLog(@"Tag: %@", [CategoryData objectAtIndex:indexPath.row]);
        if(trust<=0.5){
            cell.trustBar.backgroundColor = [UIColor colorWithRed:1 green:2*trust blue:0 alpha:1];
        }else{
            cell.trustBar.backgroundColor = [UIColor colorWithRed:2*(1-trust) green:1 blue:0 alpha:1];
        }
        reload = 1;
        sleep(0.1);
        switch((int)tableView.tag){
        case 0:
            if([[CategoryData objectAtIndex:indexPath.row] isEqual: @"Politik"]){
                return cell;
            }else{
                cellHeight = 0;
                cell.hidden = YES;
                return cell;
            }
            break;
        case 1:
            if([[CategoryData objectAtIndex:indexPath.row] isEqual: @"Wirtschaft"]){
                return cell;
            }else{
                cellHeight = 0;
                cell.hidden = YES;
                return cell;
            }
            break;
        case 2:
            if([[CategoryData objectAtIndex:indexPath.row] isEqual: @"Kultur"]){
                return cell;
            }else{
                cellHeight = 0;
                cell.hidden = YES;
                return cell;
            }
            break;
        case 3:
            if([[CategoryData objectAtIndex:indexPath.row] isEqual: @"Sport"]){
                return cell;
            }else{
                cellHeight = 0;
                cell.hidden = YES;
                return cell;
            }
            break;
        case 4:
            if([[CategoryData objectAtIndex:indexPath.row] isEqual: @"Politik"]){
                return cell;
            }else{
                cellHeight = 0;
                cell.hidden = YES;
                return cell;
            }
            break;
        }
        makeEmpty = YES;
        for(int x = 0; x<=5; x++){
            [newsView[x] reloadData];
        }
    }
}

- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration
        direction:(int)direction
{
    CABasicAnimation* rotationAnimation;
    
    // Rotate about the z axis
    rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // Rotate 360 degress, in direction specified
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * direction];
    
    // Perform the rotation over this many seconds
    rotationAnimation.duration = inDuration;
    
    // Set the pacing of the animation
    rotationAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Add animation to the layer and make it so
    [inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)linkDown:(UIButton*)sender
{
    if(option==0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[LinkData objectAtIndex:sender.tag]]];
    }else{
        option = 0;
        [UIView animateWithDuration:1 animations:^{
            for(int x=0; x<=5; x++){
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x-160, categoryView[x].layer.position.y);
            }
            headerView.layer.position = CGPointMake(headerView.layer.position.x-160, headerView.layer.position.y);
        }];
    }
}

-(void)trustButtonDown:(UIButton*)sender
{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your network status." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:networkAlert animated:YES completion:nil];
        networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
    }else{
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001/up?%@", [IdData objectAtIndex:sender.tag]]];
        NSError *error;
        NSString *result = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
        makeEmpty = YES;
        makeEmpty = YES;
        for(int x = 0; x<=5; x++){
            [newsView[x] reloadData];
        }
        makeEmpty = NO;
    }
}

-(void)untrustButtonDown:(UIButton*)sender
{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your network status." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:networkAlert animated:YES completion:nil];
        networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
    }else{
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001/down?%@", [IdData objectAtIndex:sender.tag]]];
        NSError *error;
        NSString *result = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
        makeEmpty = YES;
        makeEmpty = YES;
        for(int x = 0; x<=5; x++){
            [newsView[x] reloadData];
        }
        makeEmpty = NO;
    }
}

- (IBAction)reload:(id)sender {
    [self spinLayer:reloadButton.layer duration:1 direction:SPIN_CLOCK_WISE];
    [self reloadAction];
}

-(void)reloadAction{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your network status." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:networkAlert animated:YES completion:nil];
        networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
    }else{
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maschini.de:5001"]] encoding:NSUTF8StringEncoding error:&error];
        if(jsonString==NULL){
            networkAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This service is currently unavailable.4" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:networkAlert animated:YES completion:nil];
            networkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(networkTimer) userInfo:nil repeats:YES];
                jsonString = [NSString stringWithFormat:@"[{\"date\":\"\",\"no\":0,\"yes\":0,\"author\":\"FAZ\",\"link\":\"\",\"id\":\"\",\"article\":\"\",\"category\":\"\"}]"];
        }
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONWritingPrettyPrinted error:&jsonError];
        for (int i=0; i<[allKeys count]; i++) {
            NSDictionary *arrayResult = [allKeys objectAtIndex:i];
            TimeData = [TimeData arrayByAddingObject:[arrayResult objectForKey:@"date"]];
            NameData = [NameData arrayByAddingObject:[arrayResult objectForKey:@"author"]];
            LinkData = [LinkData arrayByAddingObject:[arrayResult objectForKey:@"link"]];
            TextData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"article"]];
            YesData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"yes"]];
            NoData = [TextData arrayByAddingObject:[arrayResult objectForKey:@"no"]];
            IdData = [IdData arrayByAddingObject:[arrayResult objectForKey:@"id"]];
            CategoryData = [CategoryData arrayByAddingObject:[arrayResult objectForKey:@"category"]];
            yesArray[a] = [[arrayResult objectForKey:@"yes"] floatValue];
            noArray[a] = [[arrayResult objectForKey:@"no"] floatValue];
            a++;
        }
        for(int x = 0; x<=5; x++){
            [newsView[x] setContentOffset:CGPointZero animated:YES];
        }
        makeEmpty = YES;
        for(int x = 0; x<=5; x++){
            [newsView[x] reloadData];
        }
        makeEmpty = NO;
        for(int x = 0; x<=5; x++){
            [newsView[x] endUpdates];
        }
    }
}

-(float)roundUp:(float)input{
    float z=1.0f;
    while(input>=13.333*z){
        z++;
    }
    return 13.333*z;
}

-(void)handlesSwipe:(UISwipeGestureRecognizer *) sender{
    if(option == 1){
        option = 0;
        [UIView animateWithDuration:1 animations:^{
            for(int x=0; x<=5; x++){
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x-160, categoryView[x].layer.position.y);
            }
            headerView.layer.position = CGPointMake(headerView.layer.position.x-160, headerView.layer.position.y);
        }];
    }else{
    NSLog(@"%d", scroll);
    newsView[scroll].scrollEnabled = NO;
    swipeIcon[scroll].image = [UIImage imageNamed:@"SwipeIconDisabled.png"];
    if(sender.direction == UISwipeGestureRecognizerDirectionUp){
        NSLog(@"Up");
        if(scroll < 5){
            [UIView animateWithDuration:1 animations:^{
                for(int u = scroll+1; u>=0; u--){
                    categoryView[u].layer.position = CGPointMake(categoryView[u].layer.position.x, categoryView[0].frame.size.height/2);NSLog(@"Scroll1");
                }
                for(int u = 5; u>scroll+1; u--){
                    categoryView[u].layer.position = CGPointMake(categoryView[u].layer.position.x, categoryView[u].layer.position.y-50);
                }
            }];
            scroll++;
            for(int u = 5; u>=0; u--){
                //newsView[u].hidden = YES;
            }
            newsView[scroll].hidden = NO;
            newsView[scroll].scrollEnabled = YES;
        }
    }else if(sender.direction == UISwipeGestureRecognizerDirectionDown){
        NSLog(@"Down");
        if(scroll > 0){
            for(int u = 5; u>=0; u--){
                //newsView[u].hidden = YES;
            }
            newsView[scroll].hidden = NO;
            [UIView animateWithDuration:1 animations:^{
                /*for(int u = scroll; u>=0; u--){
                    categoryView[u].layer.position = CGPointMake(categoryView[u].layer.position.x, categoryView[u].layer.position.y+categoryView[u].frame.size.height);
                }*/
                categoryView[scroll].layer.position = CGPointMake(categoryView[scroll].layer.position.x, categoryView[scroll].layer.position.y+350);
                for(int u = 5; u>scroll; u--){
                    categoryView[u].layer.position = CGPointMake(categoryView[u].layer.position.x, categoryView[u].layer.position.y+50);
                }
            }];
            scroll--;
        }
            newsView[scroll].hidden = NO;
            newsView[scroll].scrollEnabled = YES;
        }
        swipeIcon[scroll].image = [UIImage imageNamed:@"SwipeIconActive.png"];
    }
}

-(void)handleTap:(UITapGestureRecognizer *) sender{
    NSLog(@"%ld", sender.view.tag);
    if(option != 0&&[sender locationInView:self.view].x >= 160){
        option = 0;
        [UIView animateWithDuration:1 animations:^{
            for(int x=0; x<=5; x++){
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x-160, categoryView[x].layer.position.y);
            }
            headerView.layer.position = CGPointMake(headerView.layer.position.x-160, headerView.layer.position.y);
        }];
    }
}
    
- (IBAction)loadOptions:(id)sender {
    if(option != 1){
        option = 1;
        [UIView animateWithDuration:1 animations:^{
            for(int x=0; x<=5; x++){
                categoryView[x].layer.position = CGPointMake(categoryView[x].layer.position.x+160, categoryView[x].layer.position.y);
            }
            headerView.layer.position = CGPointMake(headerView.layer.position.x+160, headerView.layer.position.y);
        }];
    }
}

- (IBAction)infoDown:(id)sender {
    popupView = [[UIView alloc] initWithFrame:self.view.frame];
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.frame = CGRectMake(0, 0, 200, 239);
    popupView.layer.cornerRadius = 10;
    popup = [KLCPopup popupWithContentView:popupView];
    [popup show];
}

- (IBAction)ratingChange:(id)sender {
    if(ratingButton.isOn==TRUE){
        rating = 1;
    }else{
        rating = 0;
    }
    for(int x = 0; x<=4; x++){
        [newsView[x] reloadData];
    }
}
- (IBAction)startDown:(id)sender {
    [popup dismiss:YES];
}
@end

