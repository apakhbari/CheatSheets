# HTTP Status Codes

```

         _____  _____  ___   __ _        _                 ___          _           
  /\  /\/__   \/__   \/ _ \ / _\ |_ __ _| |_ _   _ ___    / __\___   __| | ___  ___ 
 / /_/ /  / /\/  / /\/ /_)/ \ \| __/ _` | __| | | / __|  / /  / _ \ / _` |/ _ \/ __|
/ __  /  / /    / / / ___/  _\ \ || (_| | |_| |_| \__ \ / /__| (_) | (_| |  __/\__ \
\/ /_/   \/     \/  \/      \__/\__\__,_|\__|\__,_|___/ \____/\___/ \__,_|\___||___/
                                                                                    
```


## Table of Contents
- [Overview of Status Codes](#overview-of-status-codes)
- [1xx Informational Status Codes](#1xx-informational-status-codes)
- [2xx Successful Status Codes](#2xx-successful-status-codes)
- [3xx Redirection Status Codes](#3xx-redirection-status-codes)
- [4xx Client Error Status Codes](#4xx-client-error-status-codes)
- [5xx Server Error Status Codes](#5xx-server-error-status-codes)
- [HTTP Status Codes & SEO](#http-status-codes--seo)

## Overview of Status Codes

| **Status Code** | **Meaning**                                  |
|:---------------:|:---------------------------------------------|
|      1xx       | Informational                                |
|      100       | Continue                                     |
|      101       | Switching protocols                          |
|      102       | Processing                                   |
|      103       | Early Hints                                  |
|      2xx       | Successful                                   |
|      200       | OK                                           |
|      201       | Created                                      |
|      202       | Accepted                                     |
|      203       | Non-Authoritative Information                |
|      204       | No Content                                   |
|      205       | Reset Content                                |
|      206       | Partial Content                              |
|      207       | Multi-Status                                 |
|      208       | Already Reported                             |
|      226       | IM Used                                      |
|      3xx       | Redirection                                   |
|      300       | Multiple Choices                             |
|      301       | Moved Permanently                            |
|      302       | Found (Previously "Moved Temporarily")      |
|      303       | See Other                                    |
|      304       | Not Modified                                 |
|      305       | Use Proxy                                    |
|      306       | Switch Proxy                                 |
|      307       | Temporary Redirect                           |
|      308       | Permanent Redirect                           |
|      4xx       | Client Error                                  |
|      400       | Bad Request                                  |
|      401       | Unauthorized                                 |
|      402       | Payment Required                             |
|      403       | Forbidden                                    |
|      404       | Not Found                                    |
|      405       | Method Not Allowed                           |
|      406       | Not Acceptable                               |
|      407       | Proxy Authentication Required                 |
|      408       | Request Timeout                              |
|      409       | Conflict                                     |
|      410       | Gone                                         |
|      411       | Length Required                              |
|      412       | Precondition Failed                          |
|      413       | Payload Too Large                            |
|      414       | URI Too Long                                 |
|      415       | Unsupported Media Type                       |
|      416       | Range Not Satisfiable                        |
|      417       | Expectation Failed                           |
|      418       | I'm a Teapot                                 |
|      421       | Misdirected Request                          |
|      422       | Unprocessable Entity                          |
|      423       | Locked                                       |
|      424       | Failed Dependency                             |
|      425       | Too Early                                    |
|      426       | Upgrade Required                              |
|      428       | Precondition Required                         |
|      429       | Too Many Requests                            |
|      431       | Request Header Fields Too Large              |
|      451       | Unavailable For Legal Reasons                 |
|      5xx       | Server Error                                  |
|      500       | Internal Server Error                         |
|      501       | Not Implemented                              |
|      502       | Bad Gateway                                  |
|      503       | Service Unavailable                           |
|      504       | Gateway Timeout                              |
|      505       | HTTP Version Not Supported                   |
|      506       | Variant Also Negotiates                      |
|      507       | Insufficient Storage                         |
|      508       | Loop Detected                                |
|      510       | Not Extended                                 |
|      511       | Network Authentication Required               |

## 1xx Informational Status Codes

A `1xx Informational` status code means that the server has received the request and is continuing the process. A `1xx` status code is temporary and given while the request processing continues. For most tasks, you won't encounter these often, as they are not the final response to the request.

- **100 Continue**: The initial part of the request has been received; the client should proceed with the request or ignore the response if the request is complete.
- **101 Switching Protocols**: The server understands the Upgrade header field request and indicates which protocol it is switching to.
- **102 Processing**: The server has accepted the full request but has not yet completed it, and no response is available as of yet.
- **103 Early Hints**: Intended to allow the user agent to preload resources while the server prepares a response, primarily used with the Link Header.

## 2xx Successful Status Codes

A `2xx Successful` status code means the request was successful and the browser has received the expected information. This is generally the code to look for, indicating that the request was received, understood, and accepted.

- **200 OK**: The request was successful. Its meaning depends on the request method:
  - **GET**: The requested resource has been fetched and transmitted to the message body.
  - **HEAD**: The header fields from the requested resource are sent without the message body.
  - **POST/PUT**: A description of the result of the action is transmitted to the message body.
  - **TRACE**: The request messages, as received by the server, will be included in the message body.
  
- **201 Created**: The request was successfully fulfilled and resulted in one or more new resources being created.
- **202 Accepted**: The request has been accepted for processing, but the processing has not been finished yet.
- **203 Non-Authoritative Information**: The request was successful, but the meta-information received differs from that on the origin server.
- **204 No Content**: The request was fulfilled, but there is no content available.
- **205 Reset Content**: The user should reset the document that sent this request.
- **206 Partial Content**: A response to a Range header sent from the client requesting only part of the resource.
- **207 Multi-Status**: Conveys information about multiple resources, where multiple status codes are appropriate.
- **208 Already Reported**: Used inside a response element DAV:propstat, to avoid enumerating internal members of multiple bindings to the same collection.
- **226 IM Used**: Response means the server successfully fulfilled a GET request, and the response represents the result of one or more instance manipulations.

## 3xx Redirection Status Codes

A `3xx Redirection` status code means you have been redirected, and completing the request requires further action. Redirects are a natural part of the internet, indicating that while the request was received successfully, the resource was found elsewhere.

- **300 Multiple Choices**: The request has multiple possible responses; the user or user agent should choose one.
- **301 Moved Permanently**: The target resource has a new permanent URL; future references should use this new URL.
- **302 Found**: The URI of the request has changed temporarily; future requests should use the effective request URI.
- **303 See Other**: Directs the client to get the requested resource at another URI with a GET request.
- **304 Not Modified**: The response has not been modified; the client can use the cached version of the response.
- **305 Use Proxy**: Instructs the client to connect to a proxy; this response code is deprecated due to security concerns.
- **306 Switch Proxy**: No longer in use; previously informed clients that subsequent requests should use the specified proxy.
- **307 Temporary Redirect**: Directs the client to the requested resource at another URI; the request method must not change.
- **308 Permanent Redirect**: The requested resource has been permanently assigned a new URI; future references should use this new URI.

## 4xx Client Error Status Codes

A `4xx Client Error` status code means that the website or page could not be reached, either because the page is unavailable or the request contains bad syntax. As a website owner, it's vital to avoid these errors to help users find what they need.

- **400 Bad Request**: The server could not understand the request due to invalid syntax.
- **401 Unauthorized**: The request has not been applied because the server requires user authentication.
- **402 Payment Required**: A response reserved for future use, not commonly used.
- **403 Forbidden**: The client request has been rejected because the client does not have rights to access the content.
- **404 Not Found**: The server did not find a current representation for the requested resource.
- **405 Method Not Allowed**: The server knows the request method, but the method has been disabled and cannot be used.
- **406 Not Acceptable**: The server does not find any content that meets the criteria given by the user agent.
- **407 Proxy Authentication Required**: The client must first be authenticated by a proxy.
- **408 Request Timeout**: The server did not receive a complete request in the time that it was prepared to wait.
- **409 Conflict**: The request could not be fulfilled due to a conflict with the current state of the target resource.
- **410 Gone**: The target resource has been deleted, and this condition is permanent.
- **411 Length Required**: The server rejected the request because it requires the Content-Length header field.
- **412 Precondition Failed**: The server does not meet one or more preconditions indicated in the request header fields.
- **413 Payload Too Large**: The server refuses to process the request because the payload is larger than the server is willing to process.
- **414 URI Too Long**: The server is refusing to service the request because the request-target was too long.
- **415 Unsupported Media Type**: The server is rejecting the request because it does not support the media format of the requested data.
- **416 Range Not Satisfiable**: The range specified in the Range header field can't be fulfilled.
- **417 Expectation Failed**: The expectation indicated by the Expect request-header field could not be met by the server.
- **418 I'm a Teapot**: The server refuses to brew coffee because it is a teapot (part of an April Fools' joke).
- **421 Misdirected Request**: The client request was directed at a server that cannot produce a response.
- **422 Unprocessable Entity**: The request was well-formed, but the server was unable to follow it due to semantic errors.
- **423 Locked**: The resource being accessed is locked.
- **424 Failed Dependency**: The request failed due to a failure of a previous request.
- **425 Too Early**: The server is not willing to risk processing a request that might be replayed.
- **426 Upgrade Required**: The server refuses to perform the request using the current protocol but might after an upgrade.
- **428 Precondition Required**: The origin server requires the request to be conditional.
- **429 Too Many Requests**: The user has sent too many requests in a given time.
- **431 Request Header Fields Too Large**: The server is not willing to process the request because its header fields are too large.
- **451 Unavailable For Legal Reasons**: The user has requested an illegal resource.

## 5xx Server Error Status Codes

A `5xx Server Error` status code means that while the request appears to be valid, the server could not complete the request. If you experience `5xx` server errors on your website, immediately investigate the server.

- **500 Internal Server Error**: The server has encountered a situation that it doesn't know how to handle.
- **501 Not Implemented**: The request cannot be handled because it is not supported by the server.
- **502 Bad Gateway**: The server received an invalid response while working as a gateway.
- **503 Service Unavailable**: The server is currently not ready to handle the request; often due to maintenance or overload.
- **504 Gateway Timeout**: The gateway did not get a timely response from the upstream server.
- **505 HTTP Version Not Supported**: The version of HTTP used in the request is not supported by the server.
- **506 Variant Also Negotiates**: Indicates an internal configuration error regarding transparent negotiation.
- **507 Insufficient Storage**: The method could not be performed because the server is unable to store the representation needed to complete the request.
- **508 Loop Detected**: The server has detected an infinite loop while processing the request.
- **510 Not Extended**: Further extensions are required for the server to fulfill the request.
- **511 Network Authentication Required**: The client needs to authenticate to gain network access.

## HTTP Status Codes & SEO

If you want great results with your SEO, it's essential to handle response codes properly to ensure your website is crawled correctly by Googlebot and returns the proper response codes when requested.

### Key Status Codes for SEO

- **200 OK**: The goal for 99% of your content; confirms everything works as it should, essential for a well-functioning website.
  
- **301 Moved Permanently**: Use to redirect users and bots from old URLs to new URLs. It's critical when a page has changed its URL permanently.

- **302 Found**: Use when a page is temporarily unavailable. This tells crawlers to check back later without affecting link value.

- **404 Not Found**: Indicates a page is not found. It's important to monitor these as they can hurt SEO if not fixed quickly—set up 301 redirects where necessary.

- **410 Gone**: Best used when content is intentionally removed and you want to ensure crawlers know it is gone forever.

- **5xx Server Errors**: Indicates a server-side problem; these should be addressed immediately to ensure your site remains accessible.


# acknowledgment
## Contributors

APA 🖖🏻

## Links

```
  aaaaaaaaaaaaa  ppppp   ppppppppp     aaaaaaaaaaaaa
  a::::::::::::a p::::ppp:::::::::p    a::::::::::::a
  aaaaaaaaa:::::ap:::::::::::::::::p   aaaaaaaaa:::::a
           a::::app::::::ppppp::::::p           a::::a
    aaaaaaa:::::a p:::::p     p:::::p    aaaaaaa:::::a
  aa::::::::::::a p:::::p     p:::::p  aa::::::::::::a
 a::::aaaa::::::a p:::::p     p:::::p a::::aaaa::::::a
a::::a    a:::::a p:::::p    p::::::pa::::a    a:::::a
a::::a    a:::::a p:::::ppppp:::::::pa::::a    a:::::a
a:::::aaaa::::::a p::::::::::::::::p a:::::aaaa::::::a
 a::::::::::aa:::ap::::::::::::::pp   a::::::::::aa:::a
  aaaaaaaaaa  aaaap::::::pppppppp      aaaaaaaaaa  aaaa
                  p:::::p
                  p:::::p
                 p:::::::p
                 p:::::::p
                 p:::::::p
                 ppppppppp
```