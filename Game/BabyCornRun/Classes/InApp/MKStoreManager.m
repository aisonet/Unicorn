

#import "MKStoreManager.h"
#import "AppDelegate.h"
#import "globals.h"

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;

// all your features should be managed one and only by StoreManager
static NSString *featureAId = @"com.touhid.ur.removeadds";////ad
static NSString *featureBId = @"com.touhid.ur.10lives";///10 lifes
static NSString *featureCId = @"com.touhid.ur.1revive";//1 revive
static NSString *featureDId = @"com.touhid.ur.3revive";///3 revive

BOOL featureAPurchased = NO;
BOOL featureBPurchased = NO;
BOOL featureCPurchased = NO;
BOOL featureDPurchased = NO;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc
{
	[_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

+ (BOOL) featureAPurchased {
	return featureAPurchased;
}

+ (BOOL) featureBPurchased {
	return featureBPurchased;
}

+ (MKStoreManager*)sharedManager
{
	NSLog(@"pass sharedManager");
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
			[_sharedStoreManager requestProductData];
			
			[MKStoreManager loadPurchases];
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    
    return _sharedStoreManager;
}

#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedStoreManager == nil)
        {
            _sharedStoreManager = [super allocWithZone:zone];
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }

    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}


- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: 
								 [NSSet setWithObjects: featureAId, featureBId, featureCId, featureDId, nil]]; // add any other product here
	request.delegate = self;
	[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}
	
	[request autorelease];
}

//- (void) buyFeatureA
//{
//	[self buyFeature:featureAId];
//}

- (void) buyFeature:(NSString*) featureId
{
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Baby Horse Run" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (void) buyFeatureA
{
	[self buyFeature:featureAId];
}

- (void) buyFeatureB
{
	[self buyFeature:featureBId];
}

- (void) buyFeatureC
{
	[self buyFeature:featureCId];
}

- (void) buyFeatureD
{
	[self buyFeature:featureDId];
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

-(void) provideContent: (NSString*) productIdentifier
{
	if([productIdentifier isEqualToString:featureAId])
    {
		featureAPurchased = YES;
        
//        g_nSuccessLevelNum = 3;
//        [g_StageView gotoGameView];
    }
    if([productIdentifier isEqualToString:featureBId])
    {
		featureBPurchased = YES;
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        [prefs setBool:true forKey:@"buy10lives"];
    }
    if([productIdentifier isEqualToString:featureCId])
    {
		featureCPurchased = YES;
        revivesLeft += 1;
    }
    if([productIdentifier isEqualToString:featureDId])
    {
		featureDPurchased = YES;
        revivesLeft += 3;
    }
	
	[MKStoreManager updatePurchases];
}

+(void) loadPurchases 
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	featureAPurchased = [userDefaults boolForKey:featureAId]; 
	featureBPurchased = [userDefaults boolForKey:featureBId]; 
}


+(void) updatePurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:featureAPurchased forKey:featureAId];
	[userDefaults setBool:featureBPurchased forKey:featureBId];
}

-(void)restoreFunc
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
