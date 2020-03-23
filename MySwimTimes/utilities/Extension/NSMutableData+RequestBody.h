//
//  NSMutableArray+RequestBody.h
//
//  Created by Cliff Viegas on 12/12/12.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (RequestBody)

#pragma mark - === Create body request ===
/**
 Add a parameter value to request body
 @param parameter the parameter value
 @param parameterName the parameter name
 */
- (void) addParameter:(NSString *) parameter name:(NSString *) parameterName;

/**
 Add a image parameter to request body
 @param imageData the image data value
 @param imageName the image name
 */
- (void) addImageParameter:(NSData *) imageData fileName:(NSString *) imageName mineType:(NSString *) mineType parameterName:(NSString *) parameterName;

/**
 Auto add end boundary request to body request
 */
- (void) endBodyRequest;

@end
