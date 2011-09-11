//
//  PSEmbeddedVideoPDFViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 9/11/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import "PSEmbeddedVideoPDFViewController.h"

@implementation PSEmbeddedVideoPDFViewController

@synthesize moviePlayer = moviePlayer_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"VideoEx" image:[UIImage imageNamed:@"45-movie-1"] tag:4] autorelease];
        self.delegate = self; // set PSPDFViewControllerDelegate to self        
    }
    return self;
}

- (void)dealloc {
    [moviePlayer_ stop];
    [moviePlayer_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.moviePlayer pause];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.moviePlayer = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPage:(NSUInteger)page {
    self.title = @"VideoEx"; // keep title
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView; {

    // in a more complex example, you may wanna parse mockup data (e.g. from a JSON) and parse this to determine
    // which videos should be added where. There also be more than one player active, so you could use a dictionary to reference them.
    if (page == 1) {
        [self.moviePlayer stop];
        MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://km.support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1211/sample_iTunes.mov"]];
        self.moviePlayer = moviePlayer;
        CGRect pageRect = pdfScrollView.compoundView.frame;
        CGSize videoSize = CGSizeMake(500, 375);
        CGRect videoFrame = CGRectMake(floorf((pageRect.size.width-videoSize.width)/2), floorf((pageRect.size.width-videoSize.height)/2), videoSize.width, videoSize.height);
        moviePlayer.view.frame = videoFrame;
        moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [pdfScrollView.compoundView addSubview:moviePlayer.view];
        
        // auto-play
        [moviePlayer play];
        
        // add black border
        moviePlayer.view.layer.borderColor = [UIColor blackColor].CGColor;
        moviePlayer.view.layer.borderWidth = 1.f;
                
        // in your full featured app, you may wanna customized the controls
        //moviePlayer.controlStyle = MPMovieControlStyleNone;
        
        // animate movieplayer appearance
        /*
        self.moviePlayer.view.alpha = 0.f;
        [UIView animateWithDuration:0.25f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
            self.moviePlayer.view.alpha = 1.f;
        } completion:nil];
         */
        
        // you can also embeddd images (which may be replaced by an MPMoviePlayerController on click)
        //UIImageView *testImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]] autorelease];
        //[testImage sizeToFit];
        //[pdfScrollView.compoundView addSubview:testImage];
    }    
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didUnloadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView; {
    if (page == 1) {
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer = nil;
    }
}


@end