const ac = new AbortController();

const signals: Deno.Signal[] = ["SIGINT", "SIGTERM"];

signals.forEach((s) => {
  Deno.addSignalListener(s, () => {
    console.log(`\nReceived ${s}. Shutting down...`);
    ac.abort();
  });
});

const AWS_LWA_PORT = Deno.env.get("AWS_LWA_PORT");
const PORT = AWS_LWA_PORT ? AWS_LWA_PORT : Deno.env.get("PORT");
const port = parseInt(PORT ? PORT : "8080");

Deno.serve(
  { signal: ac.signal, port },
  (_req) => {
    return new Response("OK");
  },
);
