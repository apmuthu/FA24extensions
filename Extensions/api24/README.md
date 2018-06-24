# Simple API for Front Accounting

* This is used for some basic integration functions to other software applications.
* It is a Slim 2.x based REST API for Front Accounting v2.4.x.
* The original author for the REST API adaptation for FrontAccounting is Andres Amaya Diaz.
* This is a [derived fork of it](https://github.com/andresamayadiaz/FrontAccountingSimpleAPI).

## API Quick Start

# Just copy the files into the modules directory under a folder called "api" or anything you want.
# Edit the file util.php and change the $company, $username and $password variables so you can test. Use it at your own risk, to provide login from another software you need to send X-COMPANY, X-USER and X-PASSWORD headers in the request and the API will use those credentials, if they're wrong you will get a nice message stating "Bad Login"
# Try to access the API

* To GET the Items Category List browse to:
````
http://YOUR_FA_URL/modules/api/category
````
You should see a JSON with all you're items categories, if not check the `util.php` file for test login credentials.

## Documentation

See the [API Documentation](https://andresamayadiaz.github.io/FrontAccountingSimpleAPI/) for descriptions of each endpoint.

## Methods

The following API endpoints have been implemented:

- Sales
- Customers
- Items / Inventory
- Items Categories
- Suppliers
- Inventory Movements
- Locations
- Tax Groups
- Tax Types
- Bank Accounts
- GL Accounts
- GL Account Types
- Dimensions
- Journal
- Purchases (work in progress)

* Some of them have not been tested yet so be careful.
* Checkout the evolving [documentation](http://cambell-prince.github.io/FrontAccountingSimpleAPI/) and the code at [Github](https://github.com/cambell-prince/FrontAccountingSimpleAPI).
* Support for json sent in requests using `Content-Type: application/json` with json encoded data in the body.

## REST Clients
* [Jsonium](http://jsonium.org)
* [SoapUI](https://www.soapui.org)
* [I'm only RESTing](http://downloads.swensensoftware.com/im-only-resting/im-only-resting-1.4.0.zip)
* [REST Client for windows](https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rest-client/restclient-ui-3.2.2-jar-with-dependencies.jar)
* [Postman](https://www.getpostman.com/) | [Sitepoint Tutorial](https://www.sitepoint.com/api-building-and-testing-made-easier-with-postman/)
* [Firefox Addin - Poster](https://addons.mozilla.org/en-US/firefox/addon/poster/)
* [Codeception](http://codeception.com/builds)

## How to Help

Report issues you find with as much detail as you can.

## Fork It!
Want to contribute code? Go right ahead, fork the project on GitHub. Pull requests are welcome.
