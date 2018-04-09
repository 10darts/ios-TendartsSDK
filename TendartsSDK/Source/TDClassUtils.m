
#import "TDClassUtils.h"

#import <objc/runtime.h>

@implementation TDClassUtils

@end

BOOL putMethodInTarget(Class originClass, SEL originMethod, Class targetClass, SEL targetSelector) {
	Method instanceMethod = class_getInstanceMethod(originClass, originMethod);
	IMP methodImplementation = method_getImplementation(instanceMethod);
	
	const char* methodTypeEncoding = method_getTypeEncoding(instanceMethod);
	
	Method existing = class_getInstanceMethod(targetClass, targetSelector);
	
	if (existing != NULL) {
		//add the new method as override
		class_addMethod(targetClass, originMethod, methodImplementation, methodTypeEncoding);
		//get the new added method
		Method newMethod = class_getInstanceMethod(targetClass, originMethod);
		//exchange call order
		method_exchangeImplementations(existing, newMethod);
    } else {
		class_addMethod(targetClass, targetSelector, methodImplementation, methodTypeEncoding);
	}
	
	return existing != NULL;
}

BOOL targetHasMethod( Class targetClass, SEL method) {
	
	Method existing = class_getInstanceMethod(targetClass, method);
	
	return existing != NULL;
}

Class searchAncestorImplementingProtocol(Class child, Protocol* protocol) {
    if (!class_conformsToProtocol(child, protocol)) {
        Class parent = [child superclass];
        if (parent == nil) {
            //finished, no ancestor conforms to protocol
            return nil;
        }
        //if current child doesn't conforms protocol, search parent
        Class foundClass =  searchAncestorImplementingProtocol(parent, protocol);
        if (foundClass)
            return foundClass;
        return child;
    }
    return child;
}

NSArray* getChilds(Class parentClass) {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = (Class*)malloc(sizeof(Class) * numClasses);
    
    objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSInteger i = 0; i < numClasses; i++) {
        Class superClass = classes[i];
        
        while(superClass && superClass != parentClass) {
            superClass = class_getSuperclass(superClass);
        }
        
        if (superClass)
            [result addObject:classes[i]];
    }
    
    free(classes);
    
    return result;
}

// override on the proper child or in the parent
void installOverrideMethod(Class originClass,SEL originMethod, Class targetClass, NSArray* childs,  SEL targetSelector) {

	//iterate childs to install in the one that overrides targetSelector
	for(Class child in childs) {
		
		//check if the instance selector is different from it's superclass, if it's different that means that the instance implements an override for the selector.
		IMP childSelector = [child instanceMethodForSelector: targetSelector];
		IMP superClassSelector = [[child superclass] instanceMethodForSelector: targetSelector];
		
		if (childSelector != superClassSelector) {
			putMethodInTarget(originClass, originMethod, child, targetSelector);
			return;
		}
	}
	
	//if none of the childs overrides it install on target Class
	putMethodInTarget(originClass, originMethod, targetClass, targetSelector);    
}
