//
//  ListViewController.m
//  API demo
//
//  Created by Art Sevilla on 2/1/14.
//  Copyright (c) 2014 Art Sevilla. All rights reserved.
//

#define kMarvelBaseURL [NSURL URLWithString:@"https://gateway.marvel.com/v1/public/"]
#define kAPIKey @"052f8a61cb0d52c3bb82964ffa772de757e6154c"
#define kPublicKey @"a67c6c92345e52369baef1d4359ee461"

#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import "ListViewController.h"
#import "CharacterCell.h"

@interface NSString (MD5)

- (NSString *)MD5;

@end

@implementation NSString (MD5)

- (NSString *)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end

@interface NSData (MD5)

- (NSString *)MD5;

@end

@implementation NSData (MD5)

- (NSString *)MD5
{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, self.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end

@interface ListViewController ()

@property (nonatomic, strong) NSMutableArray *thumbnails;
@property (nonatomic, strong) NSMutableSet *shownIndexes;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation ListViewController

@synthesize elements, endString, titleString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.frame = CGRectMake(0, 0, 40.0, 40.0);
    self.indicatorView.center = CGPointMake(self.view.center.x, self.view.center.y/2 + 75); //self.view.center;
    
    _shownIndexes = [NSMutableSet set];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purple_background"]];
    
    if (titleString) {
        self.navigationItem.title = self.titleString;
    }
    
    CGFloat rotationAngleDegrees = -10;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-15, -15);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformation = transform;
    
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"Dispatching the queue...");
        [self performSelectorOnMainThread:@selector(fetchData) withObject:nil waitUntilDone:YES];
    });
}

- (void)fetchData
{
    NSError *error;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh:MM:ss"];
    
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSString *apiKeyTimestamp = [NSString stringWithFormat:@"%@%@%@", timestamp, kAPIKey,kPublicKey];
    NSString *hashedString = [apiKeyTimestamp MD5];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@?ts=%@&apikey=%@&hash=%@", kMarvelBaseURL, endString, timestamp, kPublicKey, hashedString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLResponse *response;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        [self showAlertWithTitle:@"Oops!" andMessage:@"Something went wrong with the request."];
        
        [self.indicatorView stopAnimating];
        
        NSLog(@"Error: %@", error);
    } else {
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self readResponse:data];
            });
        }];
    }
}

- (void)readResponse:(NSData *)response
{
    NSError *error;
    
    id JSONdata = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    if (!error) {
        NSDictionary *secondDictionary = [JSONdata objectForKey:@"data"];
        
        NSArray *results = [secondDictionary objectForKey:@"results"];
        
        if (!self.elements) {
            NSLog(@"Elements initialized...");
            self.elements = [NSArray arrayWithArray:results];
        }
        
        NSLog(@"Element 1: %@", [self.elements objectAtIndex:0]);
        
        [self fetchThumbnails];
        [self.tableView reloadData];
        [self.indicatorView stopAnimating];
    } else {
        [self showAlertWithTitle:@"Oops!" andMessage:@"Something went wrong with the respose."];
        
        [self.indicatorView stopAnimating];
        
        NSLog(@"Error: %@", error);
    }
}

- (void)fetchThumbnails
{
    if (!self.thumbnails) {
        NSLog(@"Initializing thumbnails...");
        self.thumbnails = [[NSMutableArray alloc] init];
    }
    NSLog(@"Fetching thumbnails...");
    
    NSDictionary *tempDict = [[NSDictionary alloc] init];
    
    for (int i = 0; i < self.elements.count; i++) {
        tempDict = [[self.elements objectAtIndex:i] objectForKey:@"thumbnail"];
        NSLog(@"Temp dict: %@", tempDict);
        NSString *URLString = [NSString stringWithFormat:@"%@/landscape_xlarge.%@", [tempDict objectForKey:@"path"], [tempDict objectForKey:@"extension"]];
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        [self.thumbnails addObject:img];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return elements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempDictionary = [[NSDictionary alloc] init];
    
    if ([self.endString isEqualToString:@"characters"]) {
        tempDictionary = @{@"name": [[self.elements objectAtIndex:indexPath.row] objectForKey:@"name"], @"image":[self.thumbnails objectAtIndex:indexPath.row], @"description":[[self.elements objectAtIndex:indexPath.row] objectForKey:@"description"]};
    }
    
    if ([self.endString isEqualToString:@"creators"]) {
        tempDictionary = @{@"name":[[self.elements objectAtIndex:indexPath.row] objectForKey:@"fullName"], @"image":[self.thumbnails objectAtIndex:indexPath.row], @"description":@"They have no descriptions."};
    }    
    
    if ([self.endString isEqualToString:@"comics"]) {
        tempDictionary = @{@"title":[[self.elements objectAtIndex:indexPath.row] objectForKey:@"title"], @"image":[self.thumbnails objectAtIndex:indexPath.row], @"description": [[self.elements objectAtIndex:indexPath.row] objectForKey:@"description"]};
    }
    
    if ([self.endString isEqualToString:@"events"]) {
        tempDictionary = @{@"title":[[self.elements objectAtIndex:indexPath.row] objectForKey:@"title"], @"image":[self.thumbnails objectAtIndex:indexPath.row], @"description":[[self.elements objectAtIndex:indexPath.row] objectForKey:@"description"]};
    }
    
    
    static NSString *CellIdentifier = @"Cell";
    CharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CharacterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell configureCellWithDictionary:tempDictionary];
    
    cell.imageView.image = [self.thumbnails objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.shownIndexes containsObject:indexPath]) {
        [self.shownIndexes addObject:indexPath];
        
        UIView *card = [(CharacterCell *)cell mainView];
        
        card.layer.transform = self.initialTransformation;
        card.layer.opacity = 0.5;
        
        [UIView animateWithDuration:0.7 animations:^{
            card.layer.transform = CATransform3DIdentity;
            card.layer.opacity = 1.0;
        }];
    }
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];
}

@end
