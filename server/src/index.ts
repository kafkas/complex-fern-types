import cors from "cors";
import express from "express";
import multer from "multer";
import { readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

import { middleware } from "./middleware";

const expressApp = express();

expressApp.use(cors());

// Configure multer for multipart form data handling
const upload = multer({ 
  storage: multer.memoryStorage(),
  limits: { 
    fileSize: 50 * 1024 * 1024, // 50MB limit
    files: 10 // Max 10 files
  }
});

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

// Simple endpoint for testing
expressApp.post("/snippet", middleware, async (req, res) => {
  console.log("Received simple request", Date.now());
  res.status(200).send("Success");
});

// Upload single document endpoint
expressApp.post("/upload-single-document", middleware, upload.single('documentFile'), async (req, res) => {
  console.log("Receiving single document upload request", Date.now());
  console.log("Raw body type:", typeof req.body);
  console.log("Raw body length:", req.body ? req.body.length : 'undefined');
  console.log("Files object:", req.files);
  console.log("File object:", req.file);
  console.log("Request headers:", req.headers);
  
  const file = req.file;
  if (!file) {
    console.log("❌ ERROR: No file received by multer");
    res.status(400).send("No documentFile provided");
    return;
  }
  
  console.log(`Received single document: ${file.originalname} (${file.size} bytes)`);
  
  // Save the uploaded file
  const fileName = file.originalname || 'document';
  const uploadPath = join(__dirname, `../uploaded_${fileName}`);
  writeFileSync(uploadPath, file.buffer);
  
  console.log(`Single document saved as: uploaded_${fileName}`);
  res.status(200).send(`Single document uploaded successfully! File: ${fileName} (${file.size} bytes)`);
});

// Upload list of documents endpoint  
expressApp.post("/upload-list-of-documents", middleware, upload.fields([
  { name: 'documentFile1', maxCount: 1 },
  { name: 'documentFile2', maxCount: 1 },
  { name: 'documentFiles', maxCount: 10 }
]), async (req, res) => {
  console.log("Receiving list of documents upload request", Date.now());
  
  const files = req.files as { [fieldname: string]: Express.Multer.File[] };
  
  if (!files || (!files.documentFile1 && !files.documentFile2 && !files.documentFiles)) {
    res.status(400).send("No document files provided");
    return;
  }
  
  let totalFiles = 0;
  let totalSize = 0;
  const uploadedFiles: string[] = [];
  
  // Process documentFile1
  if (files.documentFile1 && files.documentFile1.length > 0) {
    const file = files.documentFile1[0]!;
    const fileName = `doc1_${file.originalname || 'document'}`;
    const uploadPath = join(__dirname, `../uploaded_${fileName}`);
    writeFileSync(uploadPath, file.buffer);
    uploadedFiles.push(fileName);
    totalFiles++;
    totalSize += file.size;
    console.log(`DocumentFile1 saved as: uploaded_${fileName}`);
  }
  
  // Process documentFile2
  if (files.documentFile2 && files.documentFile2.length > 0) {
    const file = files.documentFile2[0]!;
    const fileName = `doc2_${file.originalname || 'document'}`;
    const uploadPath = join(__dirname, `../uploaded_${fileName}`);
    writeFileSync(uploadPath, file.buffer);
    uploadedFiles.push(fileName);
    totalFiles++;
    totalSize += file.size;
    console.log(`DocumentFile2 saved as: uploaded_${fileName}`);
  }
  
  // Process documentFiles array
  if (files.documentFiles) {
    files.documentFiles.forEach((file, index) => {
      const fileName = `docs_${index}_${file.originalname || 'document'}`;
      const uploadPath = join(__dirname, `../uploaded_${fileName}`);
      writeFileSync(uploadPath, file.buffer);
      uploadedFiles.push(fileName);
      totalFiles++;
      totalSize += file.size;
      console.log(`DocumentFiles[${index}] saved as: uploaded_${fileName}`);
    });
  }
  
  res.status(200).send(`List of documents uploaded successfully! ${totalFiles} files (${totalSize} bytes total): ${uploadedFiles.join(', ')}`);
});

// Upload multiple documents and fields endpoint
expressApp.post("/upload-multiple-documents-and-fields", middleware, upload.fields([
  { name: 'documentFile1', maxCount: 1 },
  { name: 'documentFile2', maxCount: 1 },
  { name: 'documentFiles', maxCount: 10 }
]), async (req, res) => {
  console.log("Receiving multiple documents and fields upload request", Date.now());
  
  const files = req.files as { [fieldname: string]: Express.Multer.File[] };
  const { someString, someInteger, someBoolean } = req.body;
  
  if (!files || (!files.documentFile1 && !files.documentFile2 && !files.documentFiles)) {
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
  if (files.documentFile1 && files.documentFile1.length > 0) {
    const file = files.documentFile1[0]!;
    const fileName = `multi_doc1_${file.originalname || 'document'}`;
    const uploadPath = join(__dirname, `../uploaded_${fileName}`);
    writeFileSync(uploadPath, file.buffer);
    uploadedFiles.push(fileName);
    totalFiles++;
    totalSize += file.size;
    console.log(`DocumentFile1 saved as: uploaded_${fileName}`);
  }
  
  if (files.documentFile2 && files.documentFile2.length > 0) {
    const file = files.documentFile2[0]!;
    const fileName = `multi_doc2_${file.originalname || 'document'}`;
    const uploadPath = join(__dirname, `../uploaded_${fileName}`);
    writeFileSync(uploadPath, file.buffer);
    uploadedFiles.push(fileName);
    totalFiles++;
    totalSize += file.size;
    console.log(`DocumentFile2 saved as: uploaded_${fileName}`);
  }
  
  if (files.documentFiles) {
    files.documentFiles.forEach((file, index) => {
      const fileName = `multi_docs_${index}_${file.originalname || 'document'}`;
      const uploadPath = join(__dirname, `../uploaded_${fileName}`);
      writeFileSync(uploadPath, file.buffer);
      uploadedFiles.push(fileName);
      totalFiles++;
      totalSize += file.size;
      console.log(`DocumentFiles[${index}] saved as: uploaded_${fileName}`);
    });
  }
  
  res.status(200).send(`Multiple documents and fields uploaded successfully! Files: ${uploadedFiles.join(', ')} | Fields: someString="${someString}", someInteger=${someInteger}, someBoolean=${someBoolean}`);
});

const PORT = 8080;
const TIMEOUT_SECONDS = 60;

const server = expressApp.listen(PORT, () => {
  console.log(`main: listening on port ${PORT}`);
});

server.setTimeout(TIMEOUT_SECONDS * 1000);
