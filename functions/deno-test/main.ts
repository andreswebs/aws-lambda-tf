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

async function runCmd(cmd: string[]) {
  const command = new Deno.Command(cmd[0], {
    args: cmd.slice(1),
    stdout: "piped",
    stderr: "piped",
  });
  const { code, stdout, stderr } = await command.output();

  if (code != 0) {
    throw new Error(new TextDecoder("utf-8").decode(stderr));
  }

  return new TextDecoder("utf-8").decode(stdout);
}

Deno.serve(
  { signal: ac.signal, port },
  (_req) => {
    runCmd([
      "aws",
      "sts",
      "get-caller-identity",
    ]).then(console.log).catch(console.error);
    return new Response("OK");
  },
);
