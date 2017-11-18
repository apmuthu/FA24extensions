# Simple API for Front Accounting

* This is used for some basic integration functions to other software applications.
* It is a Slim 2.x based REST API for Front Accounting v2.4.x.

## API Quick Start

# Just copy the files into the modules directory under a folder called "api" or anything you want.
# Edit the file util.php and change the $company, $username and $password variables so you can test. Use it at your own risk, to provide login from another software you need to send X-COMPANY, X-USER and X-PASSWORD headers in the request and the API will use those credentials, if they're wrong you will get a nice message telling "Bad Login"
# Try to access the API

* To GET the Items Category List browse to:
````
http://YOUR_FA_URL/modules/api/category
````
You should see a JSON with all you're items categories, if not check the `util.php` file for test login credentials.

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
- GL Account Types.

Some of them have not been tested yet so be careful.

## How to Help

Report issues you find with as much detail as you can.

## Fork It!
Want to contribute code? Go right ahead, fork the project on GitHub. Pull requests are welcome.
