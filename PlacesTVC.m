//
//  PlacesTVC.m
//  PlacesApi
//
//  Created by Merritt Tidwell on 12/28/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//

#import "PlacesTVC.h"
#import "Places.h"
#import <CoreLocation/CoreLocation.h>
#define kGOOGLE_API_KEY @  "AIzaSyCJIz2tX1lN8qKmgaExadKaF35BiWq-L9I"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)



@interface PlacesTVC () <CLLocationManagerDelegate>

@end

@implementation PlacesTVC {
    
    CLLocationManager * locationManager;
    CLLocationCoordinate2D currentLocation;
    

}



@synthesize placesArray;

- (void)viewDidLoad {
 
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   
    [super viewDidLoad];

    [self.tableView reloadData];

}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary * prediction;
    prediction = [self.placesArray objectAtIndex:indexPath.row];

    cell.textLabel.text = [prediction objectForKey:@"description"];
    return cell;



}

#pragma mark - UITableViewDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
   
    NSLog(@"button was pressed");
    
    NSString * searchString = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    
    
    
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%f,%f&language=en&key=%@",searchString,currentLocation.latitude,currentLocation.longitude,kGOOGLE_API_KEY];
    
    NSLog(@"searchText: %@", searchText);
    NSLog(@"searchBar.text: %@", searchBar.text);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
      dispatch_async(dispatch_get_main_queue(), ^{
          [self fetchedData:data];
      });
        
      
    });
   

}



-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
  
    placesArray = [json objectForKey:@"predictions"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", placesArray);

    [self.tableView reloadData];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

  
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    UIAlertView *messageAlert = [[UIAlertView alloc]
                                               initWithTitle: cell.textLabel.text message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [messageAlert show];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

    
    currentLocation = newLocation.coordinate;



}



@end
