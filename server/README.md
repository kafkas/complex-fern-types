# Server

API testing server for complex-fern-types project

## Available Endpoints

### Simple Endpoints
- **POST /snippet** - Simple endpoint that returns "Success"

### File Download
- **POST /download-file** - Downloads a PDF file

### File Upload (Binary)
- **POST /upload-file** - Uploads binary files with application/octet-stream content type

### Multipart File Upload Endpoints

#### POST /upload-single-document
Uploads a single document file.
- **Content-Type**: multipart/form-data
- **Fields**: 
  - `documentFile`: file

#### POST /upload-list-of-documents  
Uploads multiple document files.
- **Content-Type**: multipart/form-data
- **Fields**:
  - `documentFile1`: file
  - `documentFile2`: file 
  - `documentFiles`: file[] (array of files)

#### POST /upload-multiple-documents-and-fields
Uploads multiple document files along with additional form fields.
- **Content-Type**: multipart/form-data
- **Fields**:
  - `documentFile1`: file
  - `documentFile2`: file
  - `documentFiles`: file[] (array of files) 
  - `someString`: string
  - `someInteger`: integer
  - `someBoolean`: boolean

## Setup

```bash
yarn install
yarn build
yarn start
```

Server will run on http://localhost:8080
