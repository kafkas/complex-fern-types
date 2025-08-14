import cors from "cors";
import express from "express";
import { readFileSync } from "node:fs";
import { join } from "node:path";

import { middleware } from "./middleware";

const expressApp = express();

expressApp.use(cors());

expressApp.use("/download-file", middleware, async (req, res) => {
  console.log("Serving file download request", Date.now());
  const fileContent = readFileSync(join(__dirname, "../homework.pdf"));
  res.setHeader("Content-Type", "application/pdf");
  res.setHeader("Content-Disposition", 'attachment; filename="homework.pdf"');
  res.setHeader("Content-Length", fileContent.length);
  res.status(200).send(fileContent);
});

const PORT = 8080;
const TIMEOUT_SECONDS = 60;

const server = expressApp.listen(PORT, () => {
  console.log(`main: listening on port ${PORT}`);
});

server.setTimeout(TIMEOUT_SECONDS * 1000);
