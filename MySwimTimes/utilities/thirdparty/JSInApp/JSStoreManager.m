

#import "JSStoreManager.h"

@implementation JSStoreManager

static JSStoreManager* _sharedStoreManager; // self

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers{
    self = [super init];
    if(self){
        self._productIdentifiers = productIdentifiers;
        NSMutableSet *purchased = [NSMutableSet set];
        for(NSString * productId in self._productIdentifiers){
            BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:productId];
            if(flag){
                [purchased addObject:productId];
            }
        }
        self._purchasedProducts = purchased;
    }
    return self;
}

+ (JSStoreManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			NSSet *productIds = [NSSet setWithObjects:IAP_REMOVEADS, IAP_ShareResult, nil];
            _sharedStoreManager = [[self alloc] initWithProductIdentifiers:productIds]; // assignment not done here
			_sharedStoreManager.storeObserver = [[JSStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;

}

- (void)requestProducts {
    
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:self._productIdentifiers];
    self.request.delegate = self;
    [self.request start];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(Failed:)])
            [_delegate Failed:@"Product request failed."];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.products = response.products;
    self.request = nil;
    [self buyProduct:m_buyingItem];
}

-(BOOL)IsProductsAvailable
{
    if (self.products)
        return true;
    else
        return false;
}

- (void)buyProduct:(NSString*)productId
{
    if (!self.products)
    {
        m_buyingItem = productId;
        [self requestProducts];
        return;
    }
    m_buyingItem = nil;
	if ([SKPaymentQueue canMakePayments])
	{
        SKProduct* product = nil;
        for(SKProduct* pt in _products)
        {
//            NSLog(@"%@", pt.productIdentifier);
            if ([pt.productIdentifier isEqualToString:productId])
            {
                product = pt;
                break;
            }
        }
        if (!product)
        {
            if (_delegate)
            {
                if ([_delegate respondsToSelector:@selector(Failed:)])
                    [_delegate Failed:[NSString stringWithFormat:@"%@ product can not be found.", productId]];
            }
            return;
        }
		SKPayment *payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		[[[UIAlertView alloc] initWithTitle:nil message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"Try later" otherButtonTitles: nil] show];
	}
}

-(void)Restore
{
    isRestored = false;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)SuccessfullyPurchased:(NSString*)productIdentifier
{
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(SuccessedWithIdentifier:)])
            [_delegate SuccessedWithIdentifier:productIdentifier];
    }
}

-(void)Restored:(NSString*)productIdentifier
{
    if (!isRestored)
        isRestored = true;
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(SuccessedWithIdentifier:)])
            [_delegate SuccessedWithIdentifier:productIdentifier];
    }
}

-(void)Failed:(NSString*)msg
{
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(Failed:)])
            [_delegate Failed:msg];
    }
}

/// Custom Methods, These are different in every project. ////////
- (void) BuyRemoveAds
{
    [self buyProduct:IAP_REMOVEADS];
}

-(void)BuyShareSwimSyncResult
{
    [self buyProduct:IAP_ShareResult];
}

@end
