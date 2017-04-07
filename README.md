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
