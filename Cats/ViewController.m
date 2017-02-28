//
//  ViewController.m
//  Cats
//
//  Created by Hyung Jip Moon on 2017-02-27.
//  Copyright © 2017 leomoon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property NSDictionary *photoDictionary;
@property NSMutableArray  *storeAllPhotos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.photoTitles = [NSMutableArray new];
    self.storeAllPhotos = [NSMutableArray new];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=500a485bcdb5d40ef46da98c4c7f8806&tags=cat"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        NSError *jsonError = nil;
        self.photoDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(jsonError) {
            //Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return ;
        }
        
        NSDictionary *photos = [[self.photoDictionary objectForKey:@"photos"] objectForKey:@"photo"];
        // If we reach this point, we have successfully retrieved the JSON from the API
        for(NSDictionary *tempPhotoDictionary in photos) {
            
            NSString *title = [tempPhotoDictionary objectForKey:@"title"];

            
            Photo *newPhoto = [[Photo alloc] initWithServer:[tempPhotoDictionary objectForKey:@"server"] initWithFarm:[tempPhotoDictionary objectForKey:@"farm"] initWithID:[tempPhotoDictionary objectForKey:@"id"] initWithSecret:[tempPhotoDictionary objectForKey:@"secret"] initWithTitle:title initWithURL:url];
            
            [self.storeAllPhotos addObject:newPhoto];

            
            NSLog(@"%@",self.storeAllPhotos);


        }
        [self.collectionView reloadData];

    }];
    
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.storeAllPhotos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CatsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.photo = self.storeAllPhotos[indexPath.item];
    return cell;
    
}

@end
