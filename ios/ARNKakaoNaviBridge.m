//
//  ARNKakaoNaviBridge.m
//  ARNKakaoNavi
//
//  Created by Suhan Moon on 2020/08/30.
//

#import "ARNKakaoNaviBridge.h"
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ARNKakaoNavi, NSObject)

RCT_EXTERN_METHOD(	
				isInstalled: (RCTPromiseResolveBlock) resolve
				rejector: (RCTPromiseRejectBlock) reject);
                
RCT_EXTERN_METHOD(share: (NSDictionary *)location
                  options: (NSDictionary *)options
                  viaList: (NSArray *)viaList
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejector: (RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(navigate: (NSDictionary *)location
                  options: (NSDictionary *)options
                  viaList: (NSArray *)viaList
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejector: (RCTPromiseRejectBlock) reject);

@end
