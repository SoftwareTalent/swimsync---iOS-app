//
//  NetworkingAPIClient.m
//  NetworkingDemo
//
//  Created by Krishna Kant Kaira on 11/05/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "NetworkingClient.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"

//Staging URL
//static NSString * const BaseURLString = @"http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/SwimSync/trunk/Service/";

//Production URL
static NSString * const BaseURLString = @"http://swimsyncapp.com/Service/";

@interface NetworkingManager : AFHTTPSessionManager <MBProgressHUDDelegate>


+ (instancetype) sharedClient;

@end

@implementation NetworkingManager

+ (instancetype) sharedClient {
    
    static NetworkingManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkingManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

@end
@interface NetworkingClient () <MBProgressHUDDelegate> {
    
    MBProgressHUD *hud;
}


@end
@implementation NetworkingClient

+ (instancetype)sharedEngine {
    
    static NetworkingClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkingClient alloc] init];
    });
    
    return _sharedClient;
}

-(void)requestServerForMethod : (APIMethodType)methodType
                withParameter : (NSMutableDictionary*)params
                   controller : (UIViewController*)controller
                forHTTPMethod : (HTTPMethodType)HTTPMethod {
    
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setValue:[self getActionNameForAPIType:methodType] forKey:@"action"];
    
//    NSLog(@"REQUEST PARAM : %@",paramDict);
//    NSLog(@"REQUEST URL : %@", [self getActionNameForAPIType:methodType]);

    [self addProcessingHUD:controller];
    NSURLSessionDataTask *dataTask = [[NetworkingManager sharedClient] dataTaskWithHTTPMethod:[self getHTTPMethod:HTTPMethod] URLString:@"web_services.php" parameters:paramDict success:^(NSURLSessionDataTask *task, id response) {
        [self removeProcessingHUD:controller];
        
        NSString *resCode = [response valueForKey:@"responseCode"];
        if (!self || !self.clientDelegate)
            return;
//        if (response)
//            NSLog(@"response: %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);

        if ([resCode integerValue] == 200) {
            if (self && self.clientDelegate && [self.clientDelegate respondsToSelector:@selector(didRecieveResponse:withError:errorCode:forMethod:)])
            [self.clientDelegate didRecieveResponse:response withError:nil errorCode:200 forMethod:methodType];
        }
        else {
            NSString *resMessage = [response valueForKey:@"responseMessage"];
            if (self && self.clientDelegate && [self.clientDelegate respondsToSelector:@selector(didRecieveResponse:withError:errorCode:forMethod:)])
                [self.clientDelegate didRecieveResponse:nil withError:resMessage errorCode:0 forMethod:methodType];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self removeProcessingHUD:controller];

        if (self && self.clientDelegate && [self.clientDelegate respondsToSelector:@selector(didRecieveResponse:withError:errorCode:forMethod:)])
            [self.clientDelegate didRecieveResponse:nil withError:error.localizedDescription errorCode:error.code forMethod:methodType];
    }];
    [dataTask resume];
}

-(void)requestServerForMethod : (APIMethodType)methodType
                withParameter : (NSMutableDictionary*)params
                   controller : (UIViewController*)controller
                forHTTPMethod : (HTTPMethodType)HTTPMethod
                      success : (void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure : (void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setValue:[self getActionNameForAPIType:methodType] forKey:@"action"];
    
    [self addProcessingHUD:controller];
    
    NSURLSessionDataTask *dataTask = [[NetworkingManager sharedClient] dataTaskWithHTTPMethod:[self getHTTPMethod:HTTPMethod] URLString:@"web_services.php" parameters:paramDict success:^(NSURLSessionDataTask *task, id response) {
        
        [self removeProcessingHUD:controller];
        success(task, response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self removeProcessingHUD:controller];
        failure(task, error);
    }];
    [dataTask resume];
}

#pragma mark - HUD processing methods

-(void)addProcessingHUD : (UIViewController *) controller {
    
    //add HUD to the passed view controller's view
    
    hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    [hud setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [hud setMinShowTime:0.3];
    [hud setColor:[UIColor clearColor]];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setDelegate:self];
}

-(void)removeProcessingHUD : (UIViewController *) controller {
    
    [hud hide:YES];
    [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
}

#pragma mark - Other private instance methods

/*
 Retunrs HTTP method name for defined 'httpMethod'
 */
-(NSString*)getHTTPMethod : (HTTPMethodType) httpMethod {
    
    NSString *httpMethodName = nil;
    
    switch (httpMethod) {
            
        case HTTPMethod_GET: httpMethodName = @"GET"; break;
        case HTTPMethod_POST: httpMethodName = @"POST"; break;
        case HTTPMethod_HEAD: httpMethodName = @"HEAD"; break;
        case HTTPMethod_PUT: httpMethodName = @"PUT"; break;
        case HTTPMethod_PATCH: httpMethodName = @"PATCH"; break;
        case HTTPMethod_DELETE: httpMethodName = @"DELETE"; break;
            
        default: break;
    }
    
    return httpMethodName;
}

/*
 Returns the URI for defined 'methodType'
 */
-(NSString*)getActionNameForAPIType:(APIMethodType)methodtype {
    
    NSString *actionName = nil;
    
    switch (methodtype) {
            
        case APIMethodType_Login: actionName = @"login"; break;
        case APIMethodType_SignUp: actionName = @"registration"; break;
        case APIMethodType_ForgotPassword: actionName = @"forgotPassword"; break;
        case APIMethodType_UserList: actionName = @"userList"; break;
        case APIMethodType_ShareReport: actionName = @"shareReport"; break;
        case APIMethodType_GetSharedReport: actionName = @"getSharedReport"; break;
        case APIMethodType_ReportDownloaded: actionName = @"isResultDownload"; break;
        case APIMethodType_UpdatePaymentStatus: actionName = @"updatePaymentStatus"; break;
        case APIMethodType_ChangePassword: actionName = @"resetPassword"; break;
        case APIMethodType_DeleteShareResult: actionName = @"deleteShareResult"; break;
            
        default: break;
    }
    
    return actionName;
}

@end
