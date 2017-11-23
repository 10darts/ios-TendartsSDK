
#import <Foundation/Foundation.h>

@interface TDClassUtils : NSObject
@end
BOOL targetHasMethod( Class targetClass, SEL method);
BOOL putMethodInTarget(Class originClass, SEL originMethod, Class targetClass, SEL targetSelector);
Class searchAncestorImplementingProtocol(Class child, Protocol* protocol);
NSArray* getChilds(Class parentClass);
void installOverrideMethod(Class originClass,SEL originMethod, Class targetClass, NSArray* childs,  SEL targetSelector);
