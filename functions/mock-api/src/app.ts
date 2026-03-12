import type { LambdaFunctionURLEvent, LambdaFunctionURLResult } from 'aws-lambda';
import { getCallerIdentity } from './utils.js';

async function handler(event: LambdaFunctionURLEvent): Promise<LambdaFunctionURLResult> {
  console.log('Received request:', event.requestContext.http.method, event.rawPath);

  const identity = await getCallerIdentity();
  console.log(JSON.stringify(identity));

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: 'OK',
    }),
  };
}

export { handler };
