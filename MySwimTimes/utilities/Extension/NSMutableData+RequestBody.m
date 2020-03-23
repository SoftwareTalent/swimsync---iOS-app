//
//  NSMutableArray+RequestBody.m
//
//  Created by Cliff Viegas on 12/12/12.
//

#import "NSMutableData+RequestBody.h"

#define kBoundary @"------------------------Boundary---"

@implementation NSMutableData (RequestBody)

#pragma mark - === Create body request ===
- (void) addParameter:(NSString *) parameter name:(NSString *) parameterName {
    [self appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterName] dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void) addImageParameter:(NSData *) imageData fileName:(NSString *) imageName mineType:(NSString *) mineType parameterName:(NSString *) parameterName{
    [self appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", parameterName, imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mineType] dataUsingEncoding:NSUTF8StringEncoding]];
//    [self appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:imageData];
//    [self appendData:[@"Content-Transfer-Encoding: binary" dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)endBodyRequest {
    // close form
    [self appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
