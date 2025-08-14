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

    // Detect file type and save with appropriate extension
    let fileExtension = ".bin"; // default for unknown types
    let fileName = "uploaded_file";
    
    // Check for common file types by examining the file header
    if (uploadedData.length >= 8) {
      const header = Array.from(uploadedData.subarray(0, 8));
      
      // PNG signature: 89 50 4E 47 0D 0A 1A 0A
      if (header[0] === 0x89 && header[1] === 0x50 && header[2] === 0x4E && header[3] === 0x47) {
        fileExtension = ".png";
      }
      // PDF signature: 25 50 44 46 (which is %PDF)
      else if (header[0] === 0x25 && header[1] === 0x50 && header[2] === 0x44 && header[3] === 0x46) {
        fileExtension = ".pdf";
      }
      // JPEG signature: FF D8 FF
      else if (header[0] === 0xFF && header[1] === 0xD8 && header[2] === 0xFF) {
        fileExtension = ".jpg";
      }
      // Check if it looks like text (all bytes are printable ASCII)
      else if (uploadedData.every((byte: number) => (byte >= 0x20 && byte <= 0x7E) || byte === 0x09 || byte === 0x0A || byte === 0x0D)) {
        fileExtension = ".txt";
      }
    }
    
    const uploadPath = join(__dirname, `../${fileName}${fileExtension}`);
    writeFileSync(uploadPath, uploadedData);
    
    console.log(`File saved as: ${fileName}${fileExtension}`);

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
