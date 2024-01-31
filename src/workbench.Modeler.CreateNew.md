# Creating a New Data Model<a name="workbench.Modeler.CreateNew"></a>

Follow these steps to create a new data model in Amazon DynamoDB using NoSQL Workbench\.

**To create a new data model**

1. Open NoSQL Workbench, and in the navigation pane on the left side, choose the **Data modeler** icon\.  
![\[Console screenshot showing the data modeler icon in DynamoDB.\]](./images/DesignerChoose.png)

1. Choose **Create data model**\.  
![\[Console screenshot showing the Create data model button.\]](./images/DesignerCreateModel.png)

1. Enter a name, author and description for the data model, and then choose **Create**\.

1. Choose **Add table**\.  
![\[Console screenshot showing the add table button.\]](./images/DesignerAddTableButton.png)

   For more information about tables, see [Working with Tables in DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkingWithTables.html)\.

1. Specify the following:
   + **Table name** — Enter a unique name for the table\.
   + **Partition key** — Enter a partition key name and specify its type\.
   + If you want to add a sort key:

     1. Select **Add sort key**\.

     1. Specify the sort key name and its type\.  
![\[Console screenshot showing the table name and partition key boxes and the add sort key checkbox.\]](./images/DesignerCreateTable.png)

1. To add other attributes, do the following for each attribute:

   1. Choose **Add other attribute**\.

   1. Specify the attribute name and type\.   
![\[Console screenshot showing the add other attribute button.\]](./images/DesignerAddAttribute.png)

1. Add a facet:
**Note**  
*Facets* represent an application's different data access patterns for DynamoDB\.
   + Select **Add facets**\.
   + Choose **Add facet**\.  
![\[Console screenshot showing the add facets button and the add facet button.\]](./images/DesignerAddFacet.png)
   + Specify the following:
     + The **Facet name**\.
     + A **Partition key alias**\.
     + A **Sort key alias**\.
     + Choose the **Other attributes** that are part of this facet\.

   Choose **Add facet**\.  
![\[Console screenshot showing the facet details and the add facet button.\]](./images/DesignerAddFacetDetails.png)

   Repeat this step if you want to add more facets\.

1. If you want to add a global secondary index, choose **Add global secondary index**\.

   Specify the **Global secondary index name**, **Partition key** attribute, and **Projection type**\.  
![\[Console screenshot showing the add GSI button.\]](./images/DesignerAddIndexes.png)

   For more information about working with global secondary indexes in DynamoDB, see [Global Secondary Indexes](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.html)\.

1. By default, your table will use provisioned capacity mode with auto scaling enabled on both read and write capacity\. If you want to change these settings, uncheck "Default settings" under **Capacity settings**\.  
![\[Console screenshot showing the Capacity settings heading with "Default settings" selected.\]](./images/DesignerCapacityCheckbox.png)

   Select your desired capacity mode, read and write capacity, and auto scaling IAM role \(if applicable\)\.  
![\[Console screenshot showing the table capacity settings\]](./images/DesignerCapacitySettings.png)

   For more information about DynamoDB capacity settings, see [Read/Write Capacity Mode](HowItWorks.ReadWriteCapacityMode.md)\.

1.  Choose **Add table definition**\.  
![\[Console screenshot showing the add table definition button.\]](./images/designerAddTabledefinitionbutton.png)

For more information about the `CreateTable` API operation, see [CreateTable](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_CreateTable.html) in the *Amazon DynamoDB API Reference*\.