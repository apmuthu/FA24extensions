# Route Deliveries - FrontAccounting Plugin

Route Deliveries is a FrontAccounting plugin designed to enhance delivery  
management for businesses, particularly in service industries. It adds GPS  
locations for branches to sort and optimize deliveries by shipper. It also  
provides a shipper portal to log delivery timestamps and GPS locations for  
tracking and proof of delivery. The plugin is fully functional, with more  
features planned for future updates.

## Dependencies
None

## Screenshot
* `Screenshot.png`

## Installation
1. Unzip the files into your FrontAccounting modules directory, or install  
   it directly from the repository on FrontAccounting (if available).  
2. In FrontAccounting, activate the module under `Install/Activate Extensions`  
   in the `Setup` tab.  
3. If needed, adjust `Access Setup` to enable reports.  

## Shipper Dashboard Installation (Optional)
1. On a WordPress website, unzip`wp-plugin.zip` to  
   `/wp-content/plugins/`.  
2. Activate the FA Route Deliveries plugin and connect your FA database in the  
   new settings menu in the WordPress admin area.  
3. Create user logins with the proper role, then create a page and place  
   the provided shortcode `[display_shipper_dash_page]` 
   - By default, the dashboard will display:  
     - Driver greeting  
     - Unlogged deliveries from the last week  
     - Current day deliveries with logging options  
     - Past log search  

## Usage
### Adding Geocodes for Clients
- Each branch must have GPS coordinates (latitude, longitude).  
  Example: `-118.265376,34.376487`  
- Use at least 4 decimal places for accuracy; 6 decimal places provide  
  precision within 4 square inches.  
- The plugin includes tools to help collect geocodes:  
  - **Google Maps** (for international addresses)  
  - **US Census API** (batch updates up to 10,000 addresses)  
  - CSV export/import for larger datasets or non-US locations  

### Running Route Deliveries Report
1. Navigate to `Reports` → `Customer` → `Route Deliveries`.  
2. By default, the plugin uses the public OSRM instance for routing.  
   - This instance has limitations, but you can host your own OSRM server  
     for unlimited routing requests.  

## Configuration (Setup Tab)
Located in the `Setup` section of the `rep_route_deliveries` directory,  
this section allows customization of core plugin settings.

### `home_point`
- GPS location for the starting point of routes.  
- Default behavior: round trip starting and ending at `home_point`.  

### `osrm_url`
- API URL for the OSRM instance used for routing.  
- The public OSRM instance supports up to 100 locations at a time.  
- Self-hosting OSRM removes request limits.  

### `km`
- Set to `true` for kilometers (default is miles).  

## Configuration (In Report)

### Route Deliveries
- Enables routing and adds a route log to the report.  
- Sorts delivery slips in the optimal route order.  
- Allows printing by date (a feature missing from default FrontAccounting).  

### Remove Home Location
- Removes the `home_point` from routing.  
- Useful when starting from the first delivery location instead of a  
  designated home base.  

### Route Linear, Not Roundtrip
- By default, routing is round-trip (home → deliveries → home).  
- Enable this option to create a one-way route from the first delivery  
  (oldest) to the last (newest).  

## Known Limitations
- **Single trip only** – All locations must be connected by road.  
  - Example: Deliveries in France and England can't be routed together.  
- **Single shipping location** – Multi-depot routing is not yet supported.  

## To-Do List
- Add a GPS table for shippers with possible extra settings.  
- Implement recurring deliveries for service industries and subscriptions.  
  - Store in SQL with iCal-compatible format for future calendar sync.  
- Add a routing matrix for efficient delivery grouping over multiple days.  
- Improve statistics, including average delivery time and ETA calculations.  
- Automate certain transactions for certain log updates (e.g., invoice, void).  

