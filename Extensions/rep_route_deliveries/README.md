# README.md

## Dependencies
This plugin relies on the Additional Fields module to function. Please ensure 
it is installed before use.

## Installation
1. Unzip the files into your FrontAccounting modules directory, or
   Install it directly from the repository on FrontAccounting (if available).
2. In FrontAccounting, activate it in `Install/Active Extensions` under the 
   `Setup` tab.
3. If needed change the `access setup` to use reports.


## Usage
To use this plugin:
1. Add geocodes for clients as an additional field. 
- These geocodes should be set as long,lat (default) or lat,long format. 
  Example: -118.265376,34.376487
- For minimum accuracy, use GPS coordinates with at least 4 decimal places. 
  The industry standard is 6 decimal places, allowing accuracy within 4 square 
  inches on Earth. Avoid using more than 6 places to accommodate location 
  variations when the API calls OSRM. 
2. Run the new report `Route Deliveries` under `Customer` class in `reports`  
- By default, this plugin utilizes the public instance of OSRM, which may have 
data limitations. You can use your own instance if desired.

## Configuration (Config File)
You can adjust more permanent plugin options in the `route_config.php` file 
located in the root of the `rep_route_deliveries` directory. 
The Available options there are:

### field_label
Your custom label name in the FrontAccounting additional_fields extention where 
the GPS data is stored. The Default is 'Geocoding'.

### swap_cords
By default, OSRM expects GPS data in Long,Lat format. Set this to true if your 
data is in Lat,Long format, and the software will swap it accordingly. Ensure 
there are no spaces in your coordinates.

### home_point
GPS location to add to the start of your route. This location MUST be in 
Long,Lat order.

### osrm_url
The API URL of the OSRM instance used for routing data. Replace it with another 
URL if desired. Self hosted has no limits on request size and options.

### km
Set this to true to get kilometers. The default is miles

## Configuration (In App)

### Route Deliveries
With this it turns the routing function on, adds a route log to your report, 
and sorts the delivery slips in route order for you. This report does allow 
print by date that front accounting lacks by default.

### Remove Home Location
Remove the home_point location from the routing. Useful for starting at first 
delivery location.

### Route Linear, Not Roundtrip
By default, the route will be a round trip starting from the home_point or the 
first delivery stop. Set this to generate a route from the first stop 
(oldest delivery) to the last stop (newest).

## Known Limitations
- `additional fields` does not have branch support, So Only one geocode per 
client. If you have clients with more than one branch ie location they should be 
seperated.
- Only one trip is supported, the locations have to connect by roadway. You 
couldnt route deliveries in france and england at the same time.
- Doesn't support Shippers ie. Drivers. FrontAcconting core needs a small change 
I have submitted to the github mirror repo
- Doesn't support more than one shipping location (home point) This would be 
nice to add.
