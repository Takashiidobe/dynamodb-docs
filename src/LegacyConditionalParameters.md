# Legacy Conditional Parameters<a name="LegacyConditionalParameters"></a>

This section compares the legacy conditional parameters with expression parameters in DynamoDB\.

With the introduction of expression parameters \(see [Using Expressions in DynamoDB](Expressions.md)\), several older parameters have been deprecated\. New applications should not use these legacy parameters, but should use expression parameters instead\. \(For more information, see [Using Expressions in DynamoDB](Expressions.md)\.\) 

**Note**  
DynamoDB does not allow mixing legacy conditional parameters and expression parameters in a single call\. For example, calling the `Query` operation with `AttributesToGet` and `ConditionExpression` will result in an error\. 

The following table shows the DynamoDB APIs that still support these legacy parameters, and which expression parameter to use instead\. This table can be helpful if you are considering updating your applications so that they use expression parameters instead\.


****  
[\[See the AWS documentation website for more details\]](./LegacyConditionalParameters.html)

The following sections provide more information about legacy conditional parameters\.

**Topics**
+ [AttributesToGet](LegacyConditionalParameters.AttributesToGet.md)
+ [AttributeUpdates](LegacyConditionalParameters.AttributeUpdates.md)
+ [ConditionalOperator](LegacyConditionalParameters.ConditionalOperator.md)
+ [Expected](LegacyConditionalParameters.Expected.md)
+ [KeyConditions](LegacyConditionalParameters.KeyConditions.md)
+ [QueryFilter](LegacyConditionalParameters.QueryFilter.md)
+ [ScanFilter](LegacyConditionalParameters.ScanFilter.md)
+ [Writing Conditions With Legacy Parameters](LegacyConditionalParameters.Conditions.md)