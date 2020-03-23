

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "JSStoreObserver.h"

#define IAP_REMOVEADS   @"com.swimsync.product2"
#define IAP_ShareResult   @"com.swimsync.shareResult"

@protocol JSStoreManagerDelegate <NSObject>
@required
-(void)Failed:(NSString*)errMsg;
-(void)SuccessedWithIdentifier:(NSString*)identifier;
@end

@interface JSStoreManager : NSObject<SKProductsRequestDelegate> {
    BOOL isRestored;
    NSString*   m_buyingItem;
}
@property (nonatomic, retain) id<JSStoreManagerDelegate> delegate;
@property (nonatomic, retain) JSStoreObserver *storeObserver;
@property (strong, nonatomic) NSMutableSet * _purchasedProducts;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSSet *_productIdentifiers;
@property (strong, nonatomic) SKProductsRequest *request;

+ (JSStoreManager*)sharedManager;

-(void)SuccessfullyPurchased:(NSString*)productIdentifier;
-(void)Restored:(NSString*)productIdentifier;
-(BOOL)IsProductsAvailable;
-(void)Failed:(NSString*)msg;
-(void)Restore;

/// Custom Methods, These are different in every project. ////////
-(void)BuyRemoveAds;

-(void)BuyShareSwimSyncResult;

@end
