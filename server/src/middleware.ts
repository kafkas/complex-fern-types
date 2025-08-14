import type { NextFunction, Request, Response } from "express";

export const middleware = (req: Request, res: Response, next: NextFunction) => {
  console.log(`${req.method.toUpperCase()} ${req.url}`);
  console.log("-----REQUEST-HEADERS-START-----");
  console.log(req.headers);
  console.log("-----REQUEST-HEADERS-END-----");
  console.log("-----REQUEST-BODY-START-----");
  console.log(req.body);
  console.log("-----REQUEST-BODY-END-----");
  next();
};
