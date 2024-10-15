use aws_lambda_events::event::sqs::SqsEvent;
use lambda_runtime::{run, service_fn, tracing, Error, LambdaEvent};


/// This is the main body for the function.
/// Write your code inside it.
/// There are some code example in the following URLs:
/// - https://github.com/awslabs/aws-lambda-rust-runtime/tree/main/examples
/// - https://github.com/aws-samples/serverless-rust-demo/
#[tracing::instrument(skip(event), fields(req_id = %event.context.request_id))]
async fn function_handler(event: LambdaEvent<SqsEvent>) -> Result<(), Error> {
    log::info!("ok");

    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing_subscriber::fmt().json()
        .with_max_level(tracing::Level::INFO)
        .with_current_span(false)
        .with_ansi(false)
        .without_time()
        .with_target(false)
        .init();

    run(service_fn(function_handler)).await
}
