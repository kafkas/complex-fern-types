import { SeedApiClient } from "../sdks/typescript/dist/cjs/index";

const client = new SeedApiClient({
  environment: "http://localhost:8080",
});

async function main() {
  const binaryResponse = await client.service.downloadFile();
  console.log(binaryResponse);
}

void main();
