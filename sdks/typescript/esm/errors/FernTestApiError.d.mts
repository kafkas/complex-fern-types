/**
 * This file was auto-generated by Fern from our API Definition.
 */
import * as core from "../core/index.mjs";
export declare class FernTestApiError extends Error {
    readonly statusCode?: number;
    readonly body?: unknown;
    readonly rawResponse?: core.RawResponse;
    constructor({ message, statusCode, body, rawResponse, }: {
        message?: string;
        statusCode?: number;
        body?: unknown;
        rawResponse?: core.RawResponse;
    });
}
