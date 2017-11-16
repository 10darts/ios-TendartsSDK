
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
		if ( parent == nil) {
			//finished, no ancestor conforms to protocol
			return nil;
		}
		//if current child doesn't conforms protocol, search parent
		return  searchAncestorImplementingProtocol(parent, protocol);
    } else {
		return child;
	}
}

NSArray* getChilds(Class parentClass) {
	
	int count = objc_getClassList(NULL, 0);
	
	Class *classes = (Class*)malloc(sizeof(Class)* count);
	
	objc_getClassList(classes, count);
	
	NSMutableArray *rv = [NSMutableArray array];
	
	//for each class declared
	for (int i = 0; i < count; i++) {
		//get the parent class and check if is the searched parent class
		Class parent = classes[i];
		do
		{
			parent = class_getSuperclass(parent);
		} while(parent != nil  && parent != parentClass);
		
		if (parent != nil) {
			[rv addObject:classes[i]];
		}
	}
	
	free(classes);
	return rv;
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
