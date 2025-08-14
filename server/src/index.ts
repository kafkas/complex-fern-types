import cors from "cors";
import express from "express";
import { readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

import { middleware } from "./middleware";

const expressApp = express();

expressApp.use(cors());

expressApp.post("/download-file", middleware, async (req, res) => {
  console.log("Serving file download request", Date.now());
  const fileContent = readFileSync(join(__dirname, "../homework.pdf"));
  res.setHeader("Content-Type", "application/pdf");
  res.setHeader("Content-Disposition", 'attachment; filename="homework.pdf"');
  res.setHeader("Content-Length", fileContent.length);
  res.status(200).send(fileContent);
});

expressApp.post(
  "/upload-file",
  middleware,
  express.raw({ type: "application/octet-stream", limit: "50mb" }),
  async (req, res) => {
    console.log("Receiving file upload request", Date.now());

    const uploadedData = req.body;

    if (!uploadedData || uploadedData.length === 0) {
      res.status(400).send("No file data received");
      return;
    }

    console.log(`Received file upload: ${uploadedData.length} bytes`);

    // Save the uploaded file (optional - for verification)
    const uploadPath = join(__dirname, "../uploaded_file.pdf");
    writeFileSync(uploadPath, uploadedData);

    res
      .status(200)
      .send(
        `File uploaded successfully! Received ${uploadedData.length} bytes and saved to ${uploadPath}`
      );
  }
);

const PORT = 8080;
const TIMEOUT_SECONDS = 60;

const server = expressApp.listen(PORT, () => {
  console.log(`main: listening on port ${PORT}`);
});

server.setTimeout(TIMEOUT_SECONDS * 1000);
