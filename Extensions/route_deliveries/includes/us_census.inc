<?php

function fetch_geocode_from_census($address) {
    // Census API URL with the provided address
    $formatted_address = str_replace(["\r\n", "\n", "\r"], ', ', $address);
    $url = 'https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?' .
           'address=' . urlencode($formatted_address) .
           '&benchmark=Public_AR_Current&format=json';

    // Fetch response using file_get_contents
    $response = file_get_contents($url);
    if ($response === FALSE) {
        display_error(_("Unable to fetch geocode data from Census API."));
        return null;
    }

    // Decode the JSON response
    $data = json_decode($response, true);

    // Extract latitude and longitude if available
    if (isset($data['result']['addressMatches'][0])) {
        $coordinates = $data['result']['addressMatches'][0]['coordinates'];
        return [
            'latitude' => $coordinates['y'],
            'longitude' => $coordinates['x']
        ];
    } else {
        display_error(_("No geocode data found for the provided address."));
        return null;
    }
}

function generate_census_batch_csv($branch_data, $download = false) {
    // Generate a unique temporary file
    $tmpFilePath = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'census_batch_' . uniqid() . '.csv';

    // Open the file for writing
    $file = fopen($tmpFilePath, 'w');
    if (!$file) {
        display_error(_("Unable to create temporary CSV file."));
        return null;
    }

    // Write the header row
    fputcsv($file, ['Unique ID', 'Street Address', 'City', 'State', 'ZIP', 'Urbanization']);

    // Write the branch data to the CSV
    foreach ($branch_data as $data) {
        $uniqueId = $data['branch_id']; // Use branch_id as the unique identifier

        // Extract the address components
        $formatted_address = str_replace(["\r\n", "\n", "\r"], ', ', $data['address']);
        $fullAddress = $formatted_address; // e.g., "123 Main St, Los Angeles, CA 90001"
        $addressParts = explode(',', $fullAddress);

        // Handle missing parts gracefully
        $streetAddress = trim($addressParts[0] ?? ''); // Street Address
        $city = trim($addressParts[1] ?? '');          // City
        $stateZip = trim($addressParts[2] ?? '');      // State and ZIP

        // Split state and ZIP
        $stateZipParts = preg_split('/\s+/', $stateZip);
        $state = trim($stateZipParts[0] ?? ''); // State
        $zip = trim($stateZipParts[1] ?? '');   // ZIP

        // Urbanization (optional)
        $urbanization = $data['urbanization'] ?? '';

        // Write the row to the CSV
        fputcsv($file, [$uniqueId, $streetAddress, $city, $state, $zip, $urbanization]);
    }

    // Close the file
    fclose($file);

    // Optionally trigger file download
    if ($download) {
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="batch_geocodes.csv"');
        header('Pragma: no-cache');
        header('Expires: 0');
        readfile($tmpFilePath);
    }

    // Return the file path for further use
    return $tmpFilePath;
}

function fetch_batch_from_census($csvFilePath) {
    // Ensure the file exists
    if (!file_exists($csvFilePath)) {
        display_error(_("The file does not exist."));
        return null;
    }

    // Define the Census API endpoint and parameters
    $url = 'https://geocoding.geo.census.gov/geocoder/locations/addressbatch';
    $benchmark = 'Public_AR_Current'; // You can change this based on your requirements

    // Set up the cURL request
    $curl = curl_init();

    curl_setopt_array($curl, [
        CURLOPT_URL => $url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => [
            'addressFile' => new CURLFile($csvFilePath),
            'benchmark' => $benchmark,
        ],
        CURLOPT_HTTPHEADER => [
            'Accept: text/plain',
        ],
    ]);

    // Execute the request and get the response
    $response = curl_exec($curl);

    // Check for errors
    if (curl_errno($curl)) {
        $error = curl_error($curl);
        curl_close($curl);
        display_error(_("CURL Error: ") . $error);
        return null;
    }

    // Check HTTP response status
    $httpCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    if ($httpCode !== 200) {
        curl_close($curl);
        display_error(_("Error fetching data from Census API. HTTP Code: ") . $httpCode);
        return null;
    }

    // Close the cURL session
    curl_close($curl);

    // The response is in CSV format; parse it into an array
    $rows = array_map('str_getcsv', explode("\n", trim($response)));

    // Return the parsed CSV data
    return $rows;
}


