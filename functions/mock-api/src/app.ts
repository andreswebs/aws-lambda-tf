import type { LambdaFunctionURLEvent, LambdaFunctionURLResult } from 'aws-lambda';
import { getCallerIdentity } from './utils.js';

async function handler(event: LambdaFunctionURLEvent): Promise<LambdaFunctionURLResult> {
  console.log('Received request:', event.requestContext.http.method, event.rawPath);

  const identity = await getCallerIdentity();

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: 'OK',
      callerIdentity: identity,
      requestPath: event.rawPath,
      method: event.requestContext.http.method,
    }),
  };
}

export { handler };
