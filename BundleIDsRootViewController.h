@interface BundleIDsRootViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView* tabView;
    NSMutableArray* appNames;
    NSMutableDictionary* theApps;
}

@end
