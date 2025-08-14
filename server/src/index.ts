import cors from "cors";
import express from "express";
import { middleware } from "./middleware";

const expressApp = express();

expressApp.use(cors());

expressApp.use("/download-file", middleware, async (req, res) => {
  console.log("hello", Date.now());

  res.status(200).send("hello");
});

const PORT = 8080;
const TIMEOUT_SECONDS = 60;

const server = expressApp.listen(PORT, () => {
  console.log(`main: listening on port ${PORT}`);
});

server.setTimeout(TIMEOUT_SECONDS * 1000);
