//
//  IEDGolfRoundViewController.m
//  golfData
//
//  Created by Donald Chan on 24/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import "IEDGolfRoundViewController.h"
#import "IEDAppDelegate.h"
#import "Deduplicator.h"
#import "Round.h"


@interface IEDGolfRoundViewController ()

@end

@implementation IEDGolfRoundViewController


#pragma mark - DATA
-(void) configureFetch
{
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Round"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO],nil];
    [request setFetchBatchSize:15];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:cdh.context
                                                     sectionNameKeyPath:nil
                                                              cacheName:nil];
    self.frc.delegate = self;
}

#pragma mark - VIEW
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    [Deduplicator deDuplicateEntityWithName:@"Round"
                    withUniqueAttributeName:@"roundID"
                          withImportContext:cdh.importContext];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    //Respond to changes in underlying store
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFetch)
                                                 name:@"SomethingChanged"
                                               object:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Game Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    Round *round = [self.frc objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"From: %@", round.roundID];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:round.createdDate];
    cell.detailTextLabel.text = stringFromDate;
    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    [cdh backgroundSaveContext];
}


#pragma mark - INTERACTION
-(IBAction)add:(id)sender
{
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    Round  *object = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:cdh.context];
    NSError *error = nil;
    if (![cdh.context obtainPermanentIDsForObjects:[NSArray arrayWithObject:object] error:&error]) {
        NSLog(@"Couldn't obtain a permanent ID for object %@", error);
    }
    object.roundID = [NSString stringWithFormat:@"Game"];
    object.createdDate = [NSDate date];
    [cdh backgroundSaveContext];
}






@end
