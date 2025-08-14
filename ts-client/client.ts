import { SeedApiClient } from "../sdks/typescript/src";

const client = new SeedApiClient({
  environment: "http://localhost:3000",
});

async function main() {
  const binaryResponse = await client.service.downloadFile();
  console.log(binaryResponse);
}

void main();
