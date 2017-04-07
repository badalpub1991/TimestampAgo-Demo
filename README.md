# TimestampAgo-Demo

#Coredata Overview

//Some times getting Error for Coredata so , create instance of Appdelegate like this in nsmanageobjectMethod

```
- (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    return context;
}
```

//Check if Duplicate Value is Already Available or Not in Coredata

```
-(BOOL)isduplicateavailablewithEntityname :(NSString*)entityname :(NSInteger)tag
{BOOL isavailable;
    NSString *name=[[dictJsonResponse objectAtIndex:tag]objectForKey:@"Title"];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest  *fetchrequest = [NSFetchRequest fetchRequestWithEntityName:entityname];
    [fetchrequest setPredicate:[NSPredicate predicateWithFormat:@"title = %@", name]];
    [fetchrequest setFetchLimit:1];
    NSError *error;
    NSUInteger count = [context countForFetchRequest:fetchrequest error:&error];
    if (count == NSNotFound) {
        // some error occurred
    }
    else if (count == 0)
    {
        isavailable=NO;
    }
    else
    { // at least one matching object exists
        isavailable=YES;
    }
    return isavailable;
    
}
```

//Save Value in Coredata \n

#pragma mark ---> Save Value in Coredata

```

  -(BOOL)setcoredatavalueForEntityname :(NSString*)Entityname :(NSInteger)tag
    {BOOL storedsuccess;
    NSManagedObjectContext *context = [self managedObjectContext];
     NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:Entityname inManagedObjectContext:context];
    [newDevice setValue:[[dictJsonResponse objectAtIndex:tag]objectForKey:@"Title"] forKey:@"title"];
    [newDevice setValue:[[dictJsonResponse objectAtIndex:tag]objectForKey:@"Location"] forKey:@"location"];
    NSString *landmark =[[dictJsonResponse objectAtIndex:tag]objectForKey:@"Landmark"] ;
    [newDevice setValue:landmark forKey:@"landmark"];
    [newDevice setValue:[aryImagedata objectAtIndex:tag] forKey:@"image"];
    storedsuccess=YES;
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        storedsuccess=NO;
    }
    return storedsuccess;
}

```

//Fetch All the Value from Coredata 
```
  NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contacts"];
    self.SavedContacts = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if (_SavedContacts.count>0) {
        NorecordFound.hidden=YES;
        [self.tblData reloadData];
    }
    else
    {
        NorecordFound = [[UILabel alloc] init];
        //set text of label
        // stringWithFormat is useful in this case ;)
        NSString *welcomeMessage = [NSString stringWithFormat:@"No Record Found"];
        NorecordFound.text = welcomeMessage;
        //set color
        NorecordFound.backgroundColor = [UIColor clearColor];
        NorecordFound.textColor = [UIColor redColor];
        //properties
        NorecordFound.textAlignment = NSTextAlignmentCenter;
        [NorecordFound sizeToFit];
        //add the components to the view
        [self.view addSubview: NorecordFound];
        NorecordFound.center = self.view.center;
    }
```
// Use Coredata To show Value in UITableview
```- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HomeTableViewCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:bgColorView];

    
    // Configure the cell...
    NSManagedObject *contact = [self.SavedContacts objectAtIndex:indexPath.row];
    cell.lblMainLabel.text=[contact valueForKey:@"Title"];
    cell.lblSubcategory.text=[contact valueForKey:@"Location"];
    cell.lblLandmark.text=[contact valueForKey:@"landmark"];
    
    UIImage *image = [UIImage imageWithData:[contact valueForKey:@"image"]];
    cell.imgvw.image=image;
    
        
    return cell;
}
```

#Searchbar Intigration

==> in Appdelegate.h
```
@property (weak, nonatomic) IBOutlet UISearchBar *srchbar;
@property (nonatomic, strong) NSMutableArray *searchResult; //SearchResult Array
 
```
==> in Appdelegate.m
```
@interface HomeViewController ()
{
    NSArray *dictJsonResponse; [mainArray]
 }
 @property (nonatomic, assign) BOOL searching;
@property (nonatomic, assign) BOOL letUserSelectRow;


#pragma mark --> UITableview Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searching)
    {
        return [self.searchResult count];
    }
    else
    {
        return [[dictJsonResponse valueForKey:@"Title"]count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MainTableIdentifier = @"HomeTableViewCell";
    HomeTableViewCell  *cell = [_tblData dequeueReusableCellWithIdentifier:MainTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor clearColor];
        [cell setSelectedBackgroundView:bgColorView];
    
    }
        cell.btnContact.tag=indexPath.row;
    cell.btnFavourite.tag=indexPath.row;
        if (self.searching) //SearchArray
    {
        cell.lblMainLabel.text=[[self.searchResult objectAtIndex:indexPath.row]objectForKey:@"Title"];
        cell.lblSubcategory.text=[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"Location"];
        cell.lblLandmark.text=[[self.searchResult objectAtIndex:indexPath.row] objectForKey:@"Landmark"];
      
    }
    else  // MainArray
    {
        cell.lblMainLabel.text=[[dictJsonResponse objectAtIndex:indexPath.row]objectForKey:@"Title"];
        cell.lblSubcategory.text=[[dictJsonResponse objectAtIndex:indexPath.row] objectForKey:@"Location"];
        cell.lblLandmark.text=[[dictJsonResponse objectAtIndex:indexPath.row] objectForKey:@"Landmark"];
    }
    
    return cell;
}


#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
    self.searching = YES;
    self.letUserSelectRow = NO;
    // self.tableView.scrollEnabled = NO;
    [self.srchbar setShowsCancelButton:YES animated:YES];
}
- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    //Remove all objects first.
    [self.searchResult removeAllObjects];
    if ([searchText length] != 0) {
        self.searching = YES;
        self.letUserSelectRow = YES;
        self.tblData.scrollEnabled = YES;
        [self searchTableView];
    } else {
        self.searching = NO;
        self.letUserSelectRow = NO;
        //  self.tableView.scrollEnabled = NO;
    }
    [self.tblData reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [self searchTableView];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self didPressedDoneSearch];
}
- (void)searchTableView
{
    NSString *searchText = self.srchbar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Title Contains %@)",searchText];
    NSArray *filtered  = [dictJsonResponse filteredArrayUsingPredicate:predicate];
    self.searchResult = [filtered mutableCopy];
}

- (void)didPressedDoneSearch
{
    self.srchbar.text = @"";
    [self.srchbar resignFirstResponder];
    self.letUserSelectRow = YES;
    self.searching = NO;
    //   [self showFilterBtn];
    self.tblData.scrollEnabled = YES;
    [self.tblData reloadData];
    [self.srchbar setShowsCancelButton:NO animated:YES];
}
- (NSMutableArray *)searchResults{
    if (!_searchResult)
        _searchResult = [[NSMutableArray alloc]init];
    return _searchResult;
}


    
```
