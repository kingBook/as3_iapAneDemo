#ifndef __IAP_ANE_H__
#define __IAP_ANE_H__

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "IAPShare.h"

#define ANE_FUNCTION(f) FREObject (f)(FREContext ctx, void *data, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(f, data) { (const uint8_t*)(#f), (data), &(f) }

/**************************************************/
NSString * getStringFromFREObject(FREObject obj);
FREObject createFREString(NSString * string);

double getDoubleFromFREObject(FREObject obj);
FREObject createFREDouble(double value);

int getIntFromFREObject(FREObject obj);
FREObject createFREInt(int value);

BOOL getBoolFromFREObject(FREObject obj);
FREObject createFREBool(BOOL value);
/**************************************************/
/***********************event dispatcher***************************/
FREContext context;
void dispatchStatusEventAsync(NSString * code, NSString * level);
/**************************************************/
void ExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);

void ExtensionFinalizer(void* extData);

void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet);

void ContextFinalizer(FREContext ctx);

bool isTesting;

ANE_FUNCTION(initialize);
ANE_FUNCTION(buyProduct);
ANE_FUNCTION(setTesting);

#endif

