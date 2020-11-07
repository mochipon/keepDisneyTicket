# disneyTicket

Scripts that tries to keep disney tickets.

## buyTicket.bash

```
Usage: ./buyTicket.bash DATE COMMODITY
    DATE:       Slash-separated date. e.g. 2020/12/05
    COMMODITY:  Commodity 'land' or 'sea'.
```

It prints a result in JSON format:

```
{
    "httpCode": HTTP_CODE
    "redirectUrl": REDIRECT_URL
    "cookiejar": PATH_TO_COOKIEJAR
}
```

When it successfully keeps a ticket, the expected parameters are:

```
{
    "httpCode": "302",
    "redirectUrl": "https://reserve.tokyodisneyresort.jp/online/login/?receiptNO=$RECEIPT_NU",
    "cookiejar": "./cookies/$COOKIE_JAR"
}
```

* When the httpCode is "200", it implies it was full of reservations.
* When the httpCode is "403", it implies you have sent too much request to the server and the server denies your requests for a while.
* When the redirectUrl ends with "/overflow/ticket", it says the server's got too much requests at the moment.

## Cookie manager

Once you successfully keeps a receipt for your ticket, you want to place your order.
You import the cookiejar to your chrome browser and go to the redirectUrl.

There are not many cookie managers which accept cookiejar in the RFC6265 (it was Netscape format originally).

My recommendation is the following:
https://github.com/Rob--W/cookie-manager#readme

Download, unzip and import it to chrome.
