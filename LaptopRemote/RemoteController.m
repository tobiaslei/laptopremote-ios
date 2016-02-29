//
//  RemoteController.m
//  LaptopRemote
//
//  Created by Tobias Lei on 2/28/16.
//  Copyright © 2016 Tobias Lei. All rights reserved.
//

#import "RemoteController.h"
#import "AFHTTPSessionManager.h"

@interface RemoteController ()
@property NSString *serverIP;
// Volume up
// Volume Down
// Mute / Unmute
// Space
@end

@implementation RemoteController

- (instancetype)initWithServerIP:(NSString *)serverIP{
    self = [super init];
    if(self){
        self.serverIP = serverIP;
    }
    return self;
}

- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:screen];
    [loadingLabel setFont:[UIFont systemFontOfSize:40]];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor blackColor];
    [loadingLabel setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height / 2.0)];
    status.textAlignment = NSTextAlignmentCenter;
    [status setFont:[UIFont systemFontOfSize:20]];
    
    UIButton *space = [[UIButton alloc] initWithFrame:CGRectMake(0, screen.size.height - 200, screen.size.width, 200)];
    [space setBackgroundColor:[UIColor blackColor]];
    [space.titleLabel setFont:[UIFont systemFontOfSize:25]];
    [space setTitle:@"SPACE" forState:UIControlStateNormal];
    [space addTarget:self action:@selector(space) forControlEvents:UIControlEventTouchUpInside];
    
    UISlider *volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(15, screen.size.height - 200 - 100, screen.size.width - 30, 100)];
    [volumeSlider setMaximumValue:100.0];
    [volumeSlider setMinimumValue:0.0];
    [volumeSlider addTarget:self action:@selector(slided:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:space];
    [self.view addSubview:volumeSlider];
    [self.view addSubview:status];
    [self.view addSubview:loadingLabel];
    
    loadingLabel.alpha = 1.0;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/", self.serverIP];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, NSDictionary *response) {
        [volumeSlider setValue:[response[@"volume"] floatValue    ]];
        loadingLabel.alpha = 0;
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)space{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/space", self.serverIP];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)slided:(UISlider *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/volume", self.serverIP];
    [manager GET:url parameters:@{@"v": [NSString stringWithFormat:@"%f", sender.value]} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
