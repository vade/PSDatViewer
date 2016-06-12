//
//  PNGParser.m
//  PSIconDatParser
//
//  Created by vade on 6/12/16.
//  Copyright © 2016 vade. All rights reserved.
//

#import "PNGParser.h"


@interface PNGParser ()

@property (atomic, readwrite, strong) NSData* datData;

@property (atomic, readwrite, strong) NSData* pngHeaderData;
@property (atomic, readwrite, strong) NSData* pngFooterData;


@property (assign) NSUInteger nextHeaderByteOffset;
@property (assign) NSUInteger nextFooterByteOffset;

@property (assign) NSUInteger numberOfFoundPNGs;
@property (readwrite, strong) NSArray<NSArray*>* offsetArray;

@end

@implementation PNGParser

- (instancetype) initWithDatFile:(NSURL*)url
{
    self = [super init];
    if(self)
    {
        if(![url isFileURL])
            return nil;
        
        self.nextFooterByteOffset = 0;
        self.nextFooterByteOffset = 0;
        
        unsigned char header[8];
        header[0] = 0x89;
        header[1] = 0x50;
        header[2] = 0x4E;
        header[3] = 0x47;
        header[4] = 0x0D;
        header[5] = 0x0A;
        header[6] = 0x1A;
        header[7] = 0x0A;
        // ".png + CRLF + EOF + LF
        self.pngHeaderData = [NSData dataWithBytes:header length:8];
        

        unsigned char footer[8];
        footer[0] = 0x49;
        footer[1] = 0x45;
        footer[2] = 0x4E;
        footer[3] = 0x44;
        footer[4] = 0xAE;
        footer[5] = 0x42;
        footer[6] = 0x60;
        footer[7] = 0x82;
        self.pngFooterData = [NSData dataWithBytes:footer length:8];

        
        NSError* error;
        self.datData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        
        
    }
    return self;
}


- (void) parseNextPNG
{
   }



- (NSImage*) copyNextImage
{
    BOOL foundHeader = false;
    BOOL foundFooter = false;
    
    NSRange headerRange = {self.nextHeaderByteOffset, self.pngHeaderData.length};
    NSRange footerRange = {self.nextFooterByteOffset, self.pngFooterData.length};
    
    while(1)
    {
        if(!foundHeader)
        {
            NSData* testHeader = [self.datData subdataWithRange:headerRange];
            
            if([self.pngHeaderData isEqualToData:testHeader])
            {
                foundHeader = YES;
            }
        }
        
        if(!foundFooter)
        {
            NSData* testFooter = [self.datData subdataWithRange:footerRange];
            
            if([self.pngFooterData isEqualToData:testFooter])
            {
                foundFooter = YES;
            }
        }
        
        if(foundFooter && foundHeader)
        {
            
            NSLog(@"Found Image Header: %lu, Footer: %lu", self.nextHeaderByteOffset, (unsigned long)self.nextFooterByteOffset);
            
            
            NSRange pngRange = {self.nextHeaderByteOffset, self.nextFooterByteOffset + footerRange.length};
            
            NSData* pngData = [self.datData subdataWithRange:pngRange];
            
            NSBitmapImageRep * imageRep = [NSBitmapImageRep imageRepWithData:pngData];
            NSSize imageSize = NSMakeSize(CGImageGetWidth([imageRep CGImage]), CGImageGetHeight([imageRep CGImage]));
            
            NSImage * image = [[NSImage alloc] initWithSize:imageSize];
            [image addRepresentation:imageRep];

            foundFooter = false;
            foundHeader = false;

            if (image)
            {

                return image;
            }
            
        }
        
        self.nextHeaderByteOffset += 1;//headerRange.length;
        headerRange.location = self.nextHeaderByteOffset;

        self.nextFooterByteOffset += 1;//footerRange.length;
        footerRange.location = self.nextFooterByteOffset;

        
        if(footerRange.location >= self.datData.length)
            break;
    }
    
    if( headerRange.location == footerRange.location)
        return nil;
    
    if((self.nextFooterByteOffset + footerRange.length) >= self.datData.length)
        return nil;
    
    return nil;
}

@end
