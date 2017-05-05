#import "IapAne.h"

/*
 *  utils function
 */
/*--------------------------------string------------------------------------*/
NSString * getStringFromFREObject(FREObject obj)
{
    uint32_t length;
    const uint8_t *value;
    FREGetObjectAsUTF8(obj, &length, &value);
    return [NSString stringWithUTF8String:(const char *)value];
}

FREObject createFREString(NSString * string)
{
    const char *str = [string UTF8String];
    FREObject obj;

    FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &obj);
    return obj;
}
/*-------------------------------double-----------------------------------*/
double getDoubleFromFREObject(FREObject obj)
{
    double number;
    FREGetObjectAsDouble(obj, &number);
    return number;
}
FREObject createFREDouble(double value)
{
    FREObject obj = nil;
    FRENewObjectFromDouble(value, &obj);
    return obj;
}
/*---------------------------------int---------------------------------*/
int getIntFromFREObject(FREObject obj)
{
    int32_t number;
    FREGetObjectAsInt32(obj, &number);
    return number;
}
FREObject createFREInt(int value)
{
    FREObject obj = nil;
    FRENewObjectFromInt32(value, &obj);
    return obj;
}
/*------------------------------bool----------------------------------------*/
BOOL getBoolFromFREObject(FREObject obj)
{
    uint32_t boolean;
    FREGetObjectAsBool(obj, &boolean);
    return boolean;
}

FREObject createFREBool(BOOL value)
{
    FREObject obj = nil;
    FRENewObjectFromBool(value, &obj);
    return obj;
}
/*--------------------------------------------------------------------------*/
/***********************event dispatcher***************************/
void dispatchStatusEventAsync(NSString * code, NSString * level){
	if(context!= nil){
        FREDispatchStatusEventAsync(context, (const uint8_t *) [code UTF8String], (const uint8_t *) [level UTF8String]);
    }else{
        NSLog(@"===IapAne dispatchStatusEventAsync error FREContext is null");
    }
}
/**************************************************/

void ExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    NSLog(@"===IapAne Entering ExtensionInitializer()");
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer; //传入Context初始化方法
    *ctxFinalizerToSet = &ContextFinalizer; //传入Context结束方法

    NSLog(@"===IapAne Exiting ExtensionInitializer()");}

void ExtensionFinalizer(void* extData) {
    NSLog(@"===IapAne Entering ExtensionFinalizer()");
    // 可以做清理工作.
    NSLog(@"===IapAne Exiting ExtensionFinalizer()");
}

void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {

    static FRENamedFunction func[] =
    {
        MAP_FUNCTION(initialize, NULL),
        MAP_FUNCTION(buyProduct,NULL),
        MAP_FUNCTION(setTesting, NULL)
    };

    *numFunctionsToSet = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
}

void ContextFinalizer(FREContext ctx) {
    NSLog(@"===IapAne Entering ContextFinalizer()");
    // 可以做清理工作
    NSLog(@"===IapAne Exiting ContextFinalizer()");
}


ANE_FUNCTION(initialize){
	context=ctx;
    isTesting=false;
	dispatchStatusEventAsync(@"initialized",@"by kingBook");
    return NULL;
}

ANE_FUNCTION(buyProduct){
	NSString* productID=getStringFromFREObject(argv[0]);
	//
    if(![IAPShare sharedHelper].iap){
		NSSet* dataSet = [[NSSet alloc] initWithObjects:productID, nil];
		[IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
	}
	//[IAPShare sharedHelper].iap.production = !isTesting;
	//请求商品信息
	[[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response){
		if(response>0){
	       	SKProduct* product=[[IAPShare sharedHelper].iap.products objectAtIndex:0];
	       	//NSLog(@"Price: %@",[[IAPShare sharedHelper].iap getLocalePrice:product]);
	       	//NSLog(@"Title: %@",product.localizedTitle);
			
			//发出购买请求
	        [[IAPShare sharedHelper].iap buyProduct:product onCompletion:^(SKPaymentTransaction* trans){
				if(trans.error){
					//交易出错
				  	//NSLog(@"Fail %@",[trans.error localizedDescription]);
				  	dispatchStatusEventAsync(@"fail",[NSString stringWithFormat: @"%@",[trans.error localizedDescription]]);
				}else if(trans.transactionState==SKPaymentTransactionStatePurchased){
					//交易成功
                    //NSLog(@"success %@",[IAPShare sharedHelper].iap.purchasedProducts);
                    dispatchStatusEventAsync(@"success",[NSString stringWithFormat:@"%@",[IAPShare sharedHelper].iap.purchasedProducts]);
				}else if(trans.transactionState == SKPaymentTransactionStateFailed) {
					//交易失败
					//NSLog(@"Fail SKPaymentTransactionStateFailed");
					dispatchStatusEventAsync(@"fail",@"SKPaymentTransactionStateFailed");
				}
	        }];//end of buy product
        }
	}];
    return NULL;
}

ANE_FUNCTION(setTesting){
    isTesting=getBoolFromFREObject(argv[0]);
    return NULL;
}