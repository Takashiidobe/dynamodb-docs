# Query a DynamoDB table by batch using PartiQL and an AWS SDK<a name="example_dynamodb_BatchExecuteStatement_section"></a>

The following code example shows how to query a DynamoDB table by batch using PartiQL\.

**Note**  
The source code for these examples is in the [AWS Code Examples GitHub repository](https://github.com/awsdocs/aws-doc-sdk-examples)\. Have feedback on a code example? [Create an Issue](https://github.com/awsdocs/aws-doc-sdk-examples/issues/new/choose) in the code examples repo\. 

------
#### [ JavaScript ]

**SDK for JavaScript V3**  
Create the client\.  

```
// Create the DynamoDB service client module using ES6 syntax.
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
// Set the AWS Region.
export const REGION = "eu-west-1"; // For example, "us-east-1".
// Create an Amazon DynamoDB service client object.
export const ddbClient = new DynamoDBClient({ region: REGION });
```
Create the document client\.  

```
// Create a service client module using ES6 syntax.
import { DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";
import { ddbClient } from "./ddbClient.js";
// Set the AWS Region.
const REGION = "eu-west-1"; // For example, "us-east-1".

const marshallOptions = {
  // Whether to automatically convert empty strings, blobs, and sets to `null`.
  convertEmptyValues: false, // false, by default.
  // Whether to remove undefined values while marshalling.
  removeUndefinedValues: false, // false, by default.
  // Whether to convert typeof object to map attribute.
  convertClassInstanceToMap: false, // false, by default.
};

const unmarshallOptions = {
  // Whether to return numbers as a string instead of converting them to native JavaScript numbers.
  wrapNumbers: false, // false, by default.
};

const translateConfig = { marshallOptions, unmarshallOptions };

// Create the DynamoDB document client.
const ddbDocClient = DynamoDBDocumentClient.from(ddbClient, translateConfig);

export { ddbDocClient };
```
Query items by batch\.  

```
*/
import fs from "fs";
// A practical functional library used to split the data into segments.
import * as R from "ramda";
import { ddbClient } from "../libs/ddbClient.js";
import { ddbDocClient } from "../libs/ddbDocClient.js";
import { BatchWriteCommand } from "@aws-sdk/lib-dynamodb";
import {
  CreateTableCommand,
  BatchExecuteStatementCommand,
} from "@aws-sdk/client-dynamodb";
if (process.argv.length < 6) {
  console.log(
    "Usage: node partiQL_basics.js <tableName> <movieTitle1> <movieYear1> <movieTitle1> <movieYear1> <producer1> <producer2> \n" +
      "Example: node partiQL_basics.js Movies_batch 2006 'The Departed' 2013 '2 Guns' 'New View Films' 'Old Thyme Films'"
  );
}

const tableName = process.argv[2];
const movieYear1 = parseInt(process.argv[3]);
const movieTitle1 = process.argv[4];
const movieYear2 = parseInt(process.argv[5]);
const movieTitle2 = process.argv[6];
const producer1 = process.argv[7];
const producer2 = process.argv[8];

// Helper function to delay running the code while the AWS service calls wait for responses.
function wait(ms) {
  var start = Date.now();
  var end = start;
  while (end < start + ms) {
    end = Date.now();
  }
}
// Set the parameters.

export const run = async (
  tableName,
  movieYear1,
  movieTitle1,
  movieYear2,
  movieTitle2,
  producer1,
  producer2
) => {
  try {
    console.log("Creating table ...");
    // Set the parameters.
    const params = {
      AttributeDefinitions: [
        {
          AttributeName: "title",
          AttributeType: "S",
        },
        {
          AttributeName: "year",
          AttributeType: "N",
        },
      ],
      KeySchema: [
        {
          AttributeName: "title",
          KeyType: "HASH",
        },
        {
          AttributeName: "year",
          KeyType: "RANGE",
        },
      ],
      ProvisionedThroughput: {
        ReadCapacityUnits: 5,
        WriteCapacityUnits: 5,
      },
      TableName: tableName,
    };
    const data = await ddbClient.send(new CreateTableCommand(params));
    console.log("Waiting for table to be created...");
    wait(10000);
    console.log(
      "Table created. Table name is ",
      data.TableDescription.TableName
    );
    try {
      // Before you run this example, download 'movies.json' from https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStarted.Js.02.html,
      // and put it in the same folder as the example.
      // Get the movie data parse to convert into a JSON object.
      const allMovies = JSON.parse(fs.readFileSync("moviedata.json", "utf8"));
      // Split the table into segments of 25.
      const dataSegments = R.splitEvery(25, allMovies);
      // Loop batch write operation 10 times to upload 250 items.
      console.log("Writing movies in batch to table...");
      for (let i = 0; i < 10; i++) {
        const segment = dataSegments[i];
        for (let j = 0; j < 25; j++) {
          const params = {
            RequestItems: {
              [tableName]: [
                {
                  // Destination Amazon DynamoDB table name.
                  PutRequest: {
                    Item: {
                      year: segment[j].year,
                      title: segment[j].title,
                      info: segment[j].info,
                    },
                  },
                },
              ],
            },
          };
          const data = ddbDocClient.send(new BatchWriteCommand(params));
        }
      }
      wait(10000);
      console.log("Success, movies written to table.");
      try {
        console.log("Getting movie....");
        const params = {
          Statements: [
            {
              Statement:
                "SELECT * FROM " + tableName + " where title=? and year=?",
              Parameters: [{ S: movieTitle1 }, { N: movieYear1 }],
            },
            {
              Statement:
                "SELECT * FROM " + tableName + " where title=? and year=?",
              Parameters: [{ S: movieTitle2 }, { N: movieYear2 }],
            },
          ],
        };
        const data = await ddbDocClient.send(
          new BatchExecuteStatementCommand(params)
        );
        console.log("Success. The query return the following data.", data);
        for (let i = 0; i < data.Responses.length; i++) {
          console.log(data.Responses[i].Item.year);
          console.log(data.Responses[i].Item.title);
        }
        try {
          const params = {
            Statements: [
              {
                Statement:
                  "DELETE FROM " + tableName + " where title=? and year=?",
                Parameters: [{ S: movieTitle1 }, { N: movieYear1 }],
              },
              {
                Statement:
                  "DELETE FROM " + tableName + " where title=? and year=?",
                Parameters: [{ S: movieTitle2 }, { N: movieYear2 }],
              },
            ],
          };
          const data = await ddbDocClient.send(
            new BatchExecuteStatementCommand(params)
          );
          console.log("Success. Items deleted by batch.");
          try {
            const params = {
              Statements: [
                {
                  Statement:
                    "INSERT INTO " +
                    tableName +
                    " value  {'title':?, 'year':?}",
                  Parameters: [{ S: movieTitle1 }, { N: movieYear1 }],
                },
                {
                  Statement:
                    "INSERT INTO " +
                    tableName +
                    " value  {'title':?, 'year':?}",
                  Parameters: [{ S: movieTitle2 }, { N: movieYear2 }],
                },
              ],
            };
            const data = await ddbDocClient.send(
              new BatchExecuteStatementCommand(params)
            );
            console.log("Success. Items added by batch.");
            try {
              const params = {
                Statements: [
                  {
                    Statement:
                      "UPDATE " +
                      tableName +
                      " SET Producer=? where title=? and year=?",
                    Parameters: [
                      { S: producer1 },
                      { S: movieTitle1 },
                      { N: movieYear1 },
                    ],
                  },
                  {
                    Statement:
                      "UPDATE " +
                      tableName +
                      " SET Producer=? where title=? and year=?",
                    Parameters: [
                      { S: producer2 },
                      { S: movieTitle2 },
                      { N: movieYear2 },
                    ],
                  },
                ],
              };
              console.log("Updating movies...");
              const data = await ddbDocClient.send(
                new BatchExecuteStatementCommand(params)
              );
              console.log("Success. Items updated by batch.");
              return "Run successfully"; // For unit tests.
            } catch (err) {
              console.log("Error updating items by batch. ", err);
            }
          } catch (err) {
            console.log("Error adding items to table by batch. ", err);
          }
        } catch (err) {
          console.log("Error deleting movies by batch. ", err);
        }
      } catch (err) {
        console.log("Error getting movies by batch. ", err);
      }
    } catch (err) {
      console.log("Error adding movies by batch. ", err);
    }
  } catch (err) {
    console.log("Error creating table. ", err);
  }
};
run(
  tableName,
  movieYear1,
  movieTitle1,
  movieYear2,
  movieTitle2,
  producer1,
  producer2
);
```
+  Find instructions and more code on [GitHub](https://github.com/awsdocs/aws-doc-sdk-examples/tree/main/javascriptv3/example_code/dynamodb#code-examples)\. 
+  For API details, see [BatchExecuteStatement](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-dynamodb/classes/batchexecutestatementcommand.html) in *AWS SDK for JavaScript API Reference*\. 

------

For a complete list of AWS SDK developer guides and code examples, see [Using DynamoDB with an AWS SDK](sdk-general-information-section.md)\. This topic also includes information about getting started and details about previous SDK versions\.