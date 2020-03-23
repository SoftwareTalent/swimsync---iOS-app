//
//  NetworkingAPIClient.h
//  NetworkingDemo
//
//  Created by Krishna Kant Kaira on 11/05/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum HTTPMethodList {
    
    HTTPMethod_GET,
    HTTPMethod_POST,
    HTTPMethod_HEAD,
    HTTPMethod_PUT,
    HTTPMethod_PATCH,
    HTTPMethod_DELETE
    
} HTTPMethodType;

typedef enum NetworkingAPIMethod {
    
    APIMethodType_Login = 201,
    APIMethodType_SignUp,
    APIMethodType_ForgotPassword,
    APIMethodType_UserList,
    APIMethodType_ShareReport,
    APIMethodType_GetSharedReport,
    APIMethodType_ReportDownloaded,
    APIMethodType_UpdatePaymentStatus,
    APIMethodType_ChangePassword,
    APIMethodType_DeleteShareResult,
    
} APIMethodType;

@protocol NetworkingClientDelegate <NSObject>

@optional
-(void)didRecieveResponse:(id)response withError:(NSString*)errMessage errorCode:(NSInteger)code forMethod:(APIMethodType)methodType;

@end

@interface NetworkingClient : NSObject

+ (instancetype)sharedEngine;

@property (nonatomic, assign) id<NetworkingClientDelegate> clientDelegate;

-(void)requestServerForMethod : (APIMethodType)methodType
                withParameter : (NSMutableDictionary*)params
                   controller : (UIViewController*)controller
                forHTTPMethod : (HTTPMethodType)HTTPMethod;

-(void)requestServerForMethod : (APIMethodType)methodType
                withParameter : (NSMutableDictionary*)params
                   controller : (UIViewController*)controller
                forHTTPMethod : (HTTPMethodType)HTTPMethod
                      success : (void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure : (void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end


