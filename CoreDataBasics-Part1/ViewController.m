//
//  ViewController.m
//  CoreDataBasics-Part1
//
//  Created by Catalin (iMac) on 08/02/2015.
//  Copyright (c) 2015 corsarus. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *booksLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateBookLabel];
}

#pragma mark - IBActions

- (IBAction)addBook:(id)sender {
    [self createBook];
    [self updateBookLabel];
}

#pragma mark - Populate Core Data

- (void)createBook
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSEntityDescription *bookEntityDescription = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSManagedObject *bookManagedObject = [[NSManagedObject alloc] initWithEntity:bookEntityDescription insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    [bookManagedObject setValue:@"The Old Man and The Sea" forKey:@"title"];
    [bookManagedObject setValue:@(128) forKey:@"pageCount"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *publishDate = [formatter dateFromString:@"1995/06/14"];
    [bookManagedObject setValue:publishDate forKey:@"datePublished"];
    
    [appDelegate saveContext];
}

- (void)updateBookLabel
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Book" inManagedObjectContext:appDelegate.managedObjectContext]];
    NSError *error = nil;
    NSArray *booksInStore = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error: %@\n%@", [error localizedDescription], [error userInfo]);
        return;
    }
    
    self.booksLabel.text = [NSString stringWithFormat:@"There are %lu books in the store", booksInStore.count];
}

@end
