import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import createBusboy from "busboy";
import cors from "cors";
import express from "express";

import { middleware } from "./middleware";

// Define types for our multipart files
interface MultipartFile {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  buffer: Buffer;
  size: number;
}

// Custom request interface for multipart parsing
interface CustomRequest extends express.Request {
  files?: { [fieldname: string]: MultipartFile };
  file?: MultipartFile;
}

const expressApp = express();

expressApp.use(cors());

// Ensure assets directory exists
const assetsDir = join(__dirname, "../assets");
if (!existsSync(assetsDir)) {
  mkdirSync(assetsDir, { recursive: true });
  console.log("📁 Created assets directory:", assetsDir);
}

// Custom middleware to parse multipart data without requiring filename
function customMultipartParser(
  req: CustomRequest,
  res: express.Response,
  next: express.NextFunction
) {
  if (!req.is("multipart/form-data")) {
    return next();
  }

  const busboy = createBusboy({
    headers: req.headers,
    limits: {
      fileSize: 50 * 1024 * 1024, // 50MB limit
      files: 10,
    },
  });

  req.files = {};
  req.body = {};

  busboy.on("file", (fieldname, file, info) => {
    const { filename, encoding, mimeType } = info;
    console.log(
      `📁 File field detected: ${fieldname}, filename: ${
        filename || "none"
      }, mimeType: ${mimeType}`
    );

    const chunks: Buffer[] = [];

    file.on("data", (chunk: Buffer) => {
      chunks.push(chunk);
    });

    file.on("end", () => {
      const buffer = Buffer.concat(chunks);

      // Create a multer-like file object
      const fileObj: MultipartFile = {
        fieldname: fieldname,
        originalname: filename || "uploaded-file",
        encoding: encoding,
        mimetype: mimeType,
        buffer: buffer,
        size: buffer.length,
      };

      if (!req.files) {
        req.files = {};
      }
      req.files[fieldname] = fileObj;

      // For single file endpoints, also set req.file
      if (!req.file) {
        req.file = fileObj;
      }
    });
  });

  busboy.on("field", (fieldname: string, value: string) => {
    console.log(`📝 Text field: ${fieldname} = ${value}`);
    req.body[fieldname] = value;
  });

  busboy.on("finish", () => {
    console.log("✅ Multipart parsing completed");
    next();
  });

  busboy.on("error", (err: Error) => {
    console.error("❌ Multipart parsing error:", err);
    res.status(400).send("Multipart parsing error");
  });

  req.pipe(busboy);
}

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
      if (
        header[0] === 0x89 &&
        header[1] === 0x50 &&
        header[2] === 0x4e &&
        header[3] === 0x47
      ) {
        fileExtension = ".png";
      }
      // PDF signature: 25 50 44 46 (which is %PDF)
      else if (
        header[0] === 0x25 &&
        header[1] === 0x50 &&
        header[2] === 0x44 &&
        header[3] === 0x46
      ) {
        fileExtension = ".pdf";
      }
      // JPEG signature: FF D8 FF
      else if (header[0] === 0xff && header[1] === 0xd8 && header[2] === 0xff) {
        fileExtension = ".jpg";
      }
      // Check if it looks like text (all bytes are printable ASCII)
      else if (
        uploadedData.every(
          (byte: number) =>
            (byte >= 0x20 && byte <= 0x7e) ||
            byte === 0x09 ||
            byte === 0x0a ||
            byte === 0x0d
        )
      ) {
        fileExtension = ".txt";
      }
    }

    const uploadPath = join(assetsDir, `${fileName}${fileExtension}`);
    writeFileSync(uploadPath, uploadedData);

    console.log(`File saved as: assets/${fileName}${fileExtension}`);

    res
      .status(200)
      .send(
        `File uploaded successfully! Received ${uploadedData.length} bytes and saved to ${uploadPath}`
      );
  }
);

// Simple endpoint for testing
expressApp.post("/snippet", middleware, async (req, res) => {
  console.log("Received simple request", Date.now());
  res.status(200).send("Success");
});

// Upload single document endpoint
expressApp.post(
  "/upload-single-document",
  customMultipartParser,
  async (req: CustomRequest, res) => {
    console.log("Receiving single document upload request", Date.now());
    console.log("Raw body type:", typeof req.body);
    console.log("Raw body length:", req.body ? req.body.length : "undefined");
    console.log("Files object:", req.files);
    console.log("File object:", req.file);
    console.log("Request headers:", req.headers);

    const file = req.file;
    if (!file) {
      console.log("❌ ERROR: No file received by multer");
      res.status(400).send("No documentFile provided");
      return;
    }

    console.log(
      `Received single document: ${file.originalname} (${file.size} bytes)`
    );

    // Save the uploaded file
    const fileName = file.originalname || "document.dat";
    const uploadPath = join(assetsDir, `single_${fileName}`);
    writeFileSync(uploadPath, file.buffer);

    console.log(`Single document saved as: assets/single_${fileName}`);
    res
      .status(200)
      .send(
        `Single document uploaded successfully! File: ${fileName} (${file.size} bytes)`
      );
  }
);

// Upload list of documents endpoint
expressApp.post(
  "/upload-list-of-documents",
  customMultipartParser,
  async (req: CustomRequest, res) => {
    console.log("Receiving list of documents upload request", Date.now());

    const files = req.files;

    if (
      !files ||
      (!files.documentFile1 && !files.documentFile2 && !files.documentFiles)
    ) {
      res.status(400).send("No document files provided");
      return;
    }

    let totalFiles = 0;
    let totalSize = 0;
    const uploadedFiles: string[] = [];

    // Process documentFile1
    if (files.documentFile1) {
      const file = files.documentFile1;
      const fileName = `list_doc1_${file.originalname || "document.dat"}`;
      const uploadPath = join(assetsDir, fileName);
      writeFileSync(uploadPath, file.buffer);
      uploadedFiles.push(fileName);
      totalFiles++;
      totalSize += file.size;
      console.log(`DocumentFile1 saved as: assets/${fileName}`);
    }

    // Process documentFile2
    if (files.documentFile2) {
      const file = files.documentFile2;
      const fileName = `list_doc2_${file.originalname || "document.dat"}`;
      const uploadPath = join(assetsDir, fileName);
      writeFileSync(uploadPath, file.buffer);
      uploadedFiles.push(fileName);
      totalFiles++;
      totalSize += file.size;
      console.log(`DocumentFile2 saved as: assets/${fileName}`);
    }

    // Note: For this example, documentFiles as array is not implemented in our custom parser
    // Individual files are handled above

    res
      .status(200)
      .send(
        `List of documents uploaded successfully! ${totalFiles} files (${totalSize} bytes total): ${uploadedFiles.join(
          ", "
        )}`
      );
  }
);

// Upload multiple documents and fields endpoint
expressApp.post(
  "/upload-multiple-documents-and-fields",
  customMultipartParser,
  async (req: CustomRequest, res) => {
    console.log(
      "Receiving multiple documents and fields upload request",
      Date.now()
    );

    const files = req.files;
    const { someString, someInteger, someBoolean } = req.body;

    if (
      !files ||
      (!files.documentFile1 && !files.documentFile2 && !files.documentFiles)
    ) {
      res.status(400).send("No document files provided");
      return;
    }

    console.log("Form fields received:");
    console.log(`  someString: ${someString}`);
    console.log(`  someInteger: ${someInteger}`);
    console.log(`  someBoolean: ${someBoolean}`);

    let totalFiles = 0;
    let totalSize = 0;
    const uploadedFiles: string[] = [];

    // Process files (same logic as upload-list-of-documents)
    if (files.documentFile1) {
      const file = files.documentFile1;
      const fileName = `multi_doc1_${file.originalname || "document.dat"}`;
      const uploadPath = join(assetsDir, fileName);
      writeFileSync(uploadPath, file.buffer);
      uploadedFiles.push(fileName);
      totalFiles++;
      totalSize += file.size;
      console.log(`DocumentFile1 saved as: assets/${fileName}`);
    }

    if (files.documentFile2) {
      const file = files.documentFile2;
      const fileName = `multi_doc2_${file.originalname || "document.dat"}`;
      const uploadPath = join(assetsDir, fileName);
      writeFileSync(uploadPath, file.buffer);
      uploadedFiles.push(fileName);
      totalFiles++;
      totalSize += file.size;
      console.log(`DocumentFile2 saved as: assets/${fileName}`);
    }

    // Note: For this example, documentFiles as array is not implemented in our custom parser
    // Individual files are handled above

    res
      .status(200)
      .send(
        `Multiple documents and fields uploaded successfully! Files: ${uploadedFiles.join(
          ", "
        )} | Fields: someString="${someString}", someInteger=${someInteger}, someBoolean=${someBoolean}`
      );
  }
);

const PORT = 8080;
const TIMEOUT_SECONDS = 60;

const server = expressApp.listen(PORT, () => {
  console.log(`main: listening on port ${PORT}`);
});

server.setTimeout(TIMEOUT_SECONDS * 1000);
