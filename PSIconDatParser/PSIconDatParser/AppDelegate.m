//
//  AppDelegate.m
//  PSIconDatParser
//
//  Created by vade on 6/12/16.
//  Copyright © 2016 vade. All rights reserved.
//

#import "AppDelegate.h"
#import "PNGParser.h"
#import "DATCollectionViewItem.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSCollectionView* collectionView;
@property (readwrite, strong) PNGParser* parser;

@property (readwrite, strong) NSMutableArray* imageArray;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    
    NSOpenPanel* open = [NSOpenPanel openPanel];
    
    open.treatsFilePackagesAsDirectories = YES;
    
    open.allowedFileTypes = @[@"dat"];
    
    [open beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
     
        switch (result) {
            case NSFileHandlingPanelOKButton:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.parser = [[PNGParser alloc] initWithDatFile: open.URLs[0] ];
                    
                    NSImage* anImage = [self.parser copyNextImage];
                    while(anImage) {
                        
                        [self.imageArray addObject:anImage];
                        
                        anImage = [self.parser copyNextImage];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^() {
                        [self.collectionView setItemPrototype:[DATCollectionViewItem new]];
                        [self.collectionView setContent:self.imageArray];
                    });

                });
                
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - Collection View Bullshit

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSCollectionViewItem* item = [collectionView makeItemWithIdentifier:@"DatItemView" forIndexPath:indexPath];
    
    item.representedObject = [self.imageArray objectAtIndex:[indexPath indexAtPosition:0]];
    
    return item;
}


@end
