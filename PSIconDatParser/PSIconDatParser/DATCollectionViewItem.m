//
//  DATCollectionViewItem.m
//  PSIconDatParser
//
//  Created by vade on 6/12/16.
//  Copyright © 2016 vade. All rights reserved.
//

#import "DATCollectionViewItem.h"

@interface DATCollectionViewItem ()

@end

@implementation DATCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    
    self.imageView.image = representedObject;
}

@end
