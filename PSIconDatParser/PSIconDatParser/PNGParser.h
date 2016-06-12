//
//  PNGParser.h
//  PSIconDatParser
//
//  Created by vade on 6/12/16.
//  Copyright © 2016 vade. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PNGParser : NSObject

- (instancetype) initWithDatFile:(NSURL*)url;

- (NSImage*) copyNextImage;

@end
