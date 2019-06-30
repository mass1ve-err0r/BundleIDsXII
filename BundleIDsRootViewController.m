//BundleIDs Originally created by @NoahSaso
//Updated in 2018 by @TD_Advocate
//Huge thanks to @TheTomMetzger and @Skittyblock for their massive amounts of help with updating and adding new features
//Shoutout to @xanDesign_ for making the new icon for the update
//Redone the icon @saadat603

#import "BundleIDsRootViewController.h"
#import <AppList/AppList.h>

//Determine device screen boundaries
#define kBounds [[UIScreen mainScreen] bounds]

@implementation BundleIDsRootViewController

//Set showID alert to nil for auto dismiss
UIAlertController *showID = nil;

//Set copyAllAlert alert to nil for auto dismiss
UIAlertController *copyAllAlert = nil;

//Create array of bundleIDs to be used for copyAllButton
NSMutableArray *bundleIDs;

//Application view’s initial load?
- (void)loadView {
    
    //Drawing tableView and it’s boundaries
    tabView = [[UITableView alloc] initWithFrame:(CGRect) kBounds];
    tabView.delegate = self;
    tabView.dataSource = self;
    [tabView setAlwaysBounceVertical:YES];
    //Displaying the tableView
    self.view = tabView;
    //Setting Navbar Title text
    self.title = @"Bundle IDs";
    
    //Defining how the bundleIDs array works
    bundleIDs = [[NSMutableArray alloc] init];
    
    
}

//Auto dismiss for the showID alert
- (void) dismissIDAlert
{
    if (showID != nil)
    {
        [showID dismissViewControllerAnimated:true completion:nil];
    }
    else {
        NSLog(@"showID is nil");
    }
}

//Auto dismiss for the copyAllAlert alert
- (void) dismissAllAlert
{
    if (copyAllAlert != nil)
    {
        [copyAllAlert dismissViewControllerAnimated:true completion:nil];
    }
    else {
        NSLog(@"copyAllAlert is nil");
    }
}


- (void)viewDidLoad {
    
    //Create copyAllButton on right side of the navbar
    UIBarButtonItem *copyAllButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Copy All"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(copyAllButton:)];
    self.navigationItem.rightBarButtonItem = copyAllButton;
    
    //Apps that are to be hidden from the view as they aren’t normally meant to be seen by the end user
    NSArray* excludedApps = [[NSArray alloc] initWithObjects:
                             @"AACredentialRecoveryDialog",
                             @"AccountAuthenticationDialog",
                             @"AskPermissionUI",
                             @"CompassCalibrationViewService",
                             @"DDActionsService",
                             @"DataActivation",
                             @"DemoApp",
                             @"FacebookAccountMigrationDialog",
                             @"FieldTest",
                             @"MailCompositionService",
                             @"MessagesViewService",
                             @"MusicUIService",
                             @"Print Center",
                             @"Setup",
                             @"Siri",
                             @"SocialUIService",
                             @"AXUIViewService",
                             @"Ad Platforms Diagnostics",
                             @"CTCarrierSpaceAuth",
                             @"CheckerBoard",
                             @"Diagnostics",
                             @"DiagnosticsService",
                             @"Do Not Disturb While Driving",
                             @"Family",
                             @"FieldTestMenu",
                             @"Game Center UI Service",
                             @"HealthPrivacyService",
                             @"HomeUIService",
                             @"InCallService",
                             //@"Magnifier",
                             @"PhotosViewService",
                             @"PreBoard",
                             //@"Print Centre",
                             @"SLGoogleAuth",
                             @"SLYahooAuth",
                             @"SafariViewService",
                             @"ScreenSharingViewService",
                             @"ScreenshotServicesService",
                             @"Server Drive",
                             @"SharedWebCredentialViewService",
                             @"SharingViewService",
                             @"SoftwareUpdateUIService",
                             @"StoreDemoViewService",
                             @"User Authentication",
                             @"iCloud",
                             @"SafeMode",
                             @"VideoSubscriberAccountViewService",
                             @"WLAccessService",
                             @"Workbench Ad Tester",
                             @"TencentWeiboAccountMigrationDialog",
                             @"TrustMe",
                             @"WebContentAnalysisUI",
                             @"WebSheet",
                             @"WebViewService",
                             @"iAd",
                             @"iAdOptOut",
                             @"iOS Diagnostics",
                             @"iTunes",
                             @"quicklookd",
                             @"Continuity Camera",
                             @"SIMSetupUIService",
                             nil];
    
    //Using applist to gather installed app information
    ALApplicationList* apps = [ALApplicationList sharedApplicationList];
    
    //Creating Dictionary to pull app list
    theApps = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [apps.applications allKeys].count; i++) {
        NSString* name = [[apps.applications allValues] objectAtIndex:i];
        if([excludedApps containsObject:name]) {
            continue;
        }
        theApps[[[apps.applications allKeys] objectAtIndex:i]] = name;
    }
    
    appNames = [[NSMutableArray alloc] init];
    
    for(NSString* i in [theApps allValues]) {
        [appNames addObject:i];
    }
    
    appNames = [[appNames sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    [tabView reloadData];
    
    
    //How the full list of installed bundle IDs is grabbed and placed into the bundleIDs array
    for (int i = 0; i < [theApps count]; i++)
    {
        NSString *bundleID = [theApps allKeysForObject:[appNames objectAtIndex:i]][0];
        bundleID = [NSString stringWithFormat:@"%@\n", bundleID];
        [bundleIDs addObject: bundleID];
    }
    
}

//Defining what happens when you tap on an app in the table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* str = [theApps allKeysForObject:[appNames objectAtIndex:indexPath.row]][0];
    //copy bundle ID to clipboard
    [UIPasteboard generalPasteboard].string = str;
    
    //show single bundle ID alert
    showID = [UIAlertController alertControllerWithTitle:str message:@"Copied to the clipboard" preferredStyle:UIAlertControllerStyleAlert];
    
    //Commenting out until I can fix the crash caused by OK button dismissing the alert and dismissAlert causing crash trying to dismiss something that is no longer there
    //UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^ (UIAlertAction *_Nonnull action) {
    //NSLog(@"OK button is pressed");
    //}];
    //[showID addAction:actionOK];
    
    //Allowing the alert to actually be displayed
    [self presentViewController:showID animated:YES completion:nil];
    //Setting the timer for auto dismissing the alert
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:NSSelectorFromString(@"dismissIDAlert")
                                   userInfo:nil
                                    repeats:NO];
}

//Defining the amount of rows in the tableView?
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appNames count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//Defining how the table cells work
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Getting the name of the app for the table cell
    cell.textLabel.text = [appNames objectAtIndex:indexPath.row];
    
    
    //Setting the app icon size, colour, shape, and image
    UIImageView *imgAppIcon=[[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
    imgAppIcon.backgroundColor=[UIColor clearColor];
    [imgAppIcon.layer setCornerRadius:0.0f];
    [imgAppIcon.layer setMasksToBounds:YES];
    [imgAppIcon setImage:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:[theApps allKeysForObject:[appNames objectAtIndex:indexPath.row]][0]]];
    [cell.contentView addSubview:imgAppIcon];
    
    //Show app icon on table
    cell.accessoryView = imgAppIcon;
    
    return cell;
    
}

//How the Copy All button works
-(void)copyAllButton:(id)sender {
    
    //show copy all bundle IDs alert
    copyAllAlert = [UIAlertController alertControllerWithTitle:@"All Bundle IDs" message:@"Copied to the clipboard" preferredStyle:UIAlertControllerStyleAlert];
    
    //Commenting out until I can fix the crash caused by OK button dismissing the alert and dismissAlert causing crash trying to dismiss something that is no longer there
    //UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^ (UIAlertAction *_Nonnull action) {
    //NSLog(@"OK button is pressed");
    //}];
    //[copyAllAlert addAction:actionOK];
    
    
    //Allowing the alert to actually be displayed
    [self presentViewController:copyAllAlert animated:YES completion:nil];
    //Setting the timer for auto dismissing the alert
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:NSSelectorFromString(@"dismissAllAlert")
                                   userInfo:nil
                                    repeats:NO];
    
    //All non-hidden bundle IDs to be copied
    NSString* copiedAllString = @"";
    for (int i=0; i < bundleIDs.count; i ++) {
        /*TOMEDIT*/
        NSString *bundleID = [NSString stringWithFormat:@"%@\n", bundleIDs[i]];
        copiedAllString = [copiedAllString stringByAppendingString:bundleID];
        //copiedAllString += "\n";
    }
    
    //copy all bundle IDs to clipboard
    [UIPasteboard generalPasteboard].string = copiedAllString;
    
}

@end
