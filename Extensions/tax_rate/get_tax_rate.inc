<?php

function  do_init_rate() {
   global $path_to_root;
    $_SESSION['tax_rates'] = array();
    $_SESSION['tax_rates_by_code'] = array();
   $csv = array_map('str_getcsv', file($path_to_root . "/modules/tax_rate" . "/ColoradoJurisdictionCodesRates.csv"));
   foreach ($csv[0] as $key =>$value)
    $csv[0][$key]=preg_replace( '/\s*/m', '',$value);

$csv[0] = array_slice($csv[0], 0, 8);
//display_notification(print_r($csv[0], true));

    array_walk($csv, function(&$a) use ($csv) {
      $a = array_merge(array_combine($csv[0], array_slice($a, 0, 8)), array_slice($a,8));
    });
    array_shift($csv); # remove column header

    foreach ($csv as $value) {
        $value['total'] = 0;
        $value['Location'] = $value['LocationCode'];
        $location = $value['Location'] = trim($value['Location']);
// Note: The ColoradoJurisdictionCodesRates.csv has entries for UNINCORPORATED PHYSICAL LOCATION
// but these are not used.  For example, the wwhsitenumbers.csv file has entries like
// 470206,AURORA-DOUGLAS (0206),15144190004,Multi Loc (Non-Physical) but not for 470207
        if ($location == "UNINCORPORATED")
            $value['Location'] = $location = strtoupper(trim($value['County']) . " COUNTY");
        for ($i=0; $value[$i] != null; $i +=3) {
            if (strpos($value[$i], 'food') === false)
                $value['total'] += $value[$i+1];
        }

        // Use highest tax rate if location is duplicate
        // applies to DENVER
        if (!isset($_SESSION['tax_rates'][$location])
            || $_SESSION['tax_rates'][$location]['total'] < $value['total'])
            $_SESSION['tax_rates'][$location] = $value;

        $_SESSION['tax_rates_by_code'][$value['JurisdictionCode']] = $value;
    }

/* FA ONLY */

    // ---------------------------------------------------------------------

    global $db_connections;
    $cur_prefix = $db_connections[$_SESSION["wa_current_user"]->cur_con]['tbpref'];

    $sql          = "SHOW TABLES";
    $result       = db_query($sql, "could not show tables");
    $found        = 0;
    $config_found = 0;
    while (($row = db_fetch_row($result))) {
        if ($row[0] == $cur_prefix."address_map") $found = 1;
        if ($row[0] == $cur_prefix."address_map_config") $config_found = 1;
    }

    if (!$found) {
            $sql = "DROP TABLE IF EXISTS ".TB_PREF."address_map";
            db_query($sql, "Error dropping table");
            $sql = "CREATE TABLE ".TB_PREF."address_map (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `address` varchar(255) NOT NULL,
                `latlong` varchar(32) NOT NULL default '',
                `lookup_date` date NOT NULL default '0000-00-00',
                `jurisdiction` varchar(32) NOT NULL default '',
                UNIQUE(address),
                PRIMARY KEY  (`id`)) ENGINE=InnoDB";
            db_query($sql, "Error creating table");
    }

/* */
}

    function getJurisdictionByFile($address)
    {
        $sql = "SELECT jurisdiction, lookup_date
            FROM ".TB_PREF."address_map
            WHERE address =".db_escape($address);
        $result = db_query($sql,"No transactions were returned");
    //  display_notification($sql);
        $row = db_fetch($result);
        return $row == false ? false : $row['jurisdiction'];
    }

    function setJurisdiction($address, $jurisdiction)
    {
        // address_map is used for both GPS and tax jurisdiction caching
        // so duplicate keys are possible

        $sql = "INSERT INTO ".TB_PREF."address_map (address, jurisdiction)
            VALUES (" . db_escape($address) . "," . db_escape($jurisdiction) .")
            ON DUPLICATE KEY UPDATE jurisdiction=" . db_escape($jurisdiction);
    //  display_notification($sql);
        db_query($sql,"insert failed");
    }

    // Get tax rate based on the city, which is only a guess.
    function get_tax_rates_by_city($address)
    {
        if (!isset($_SESSION['tax_rates']))
            do_init_rate();
//display_notification(print_r($_SESSION['tax_rates'], true));
        $i = strrpos($address, ",");
        $j = strrpos($address, "\n", -(strlen($address)-$i));
        $k = substr($address, $j+1, $i-$j+1);
        $city = trim($k);
        $city = strtoupper(str_replace(',','', $city));

        if (isset($_SESSION['tax_rates'][$city]))
            return $_SESSION['tax_rates'][$city];
        else {
            $best_city = 0;
            $best_sim = -1;
            foreach ($_SESSION['tax_rates'] as $maybe_city => $rate) {
                $sim = levenshtein(substr($maybe_city,0,strlen($city)), $city);
                if ($best_sim == -1
                    || $sim < $best_sim
                    || $sim == $best_sim && $rate['total'] > $_SESSION['tax_rates'][$best_city]['total']) {
                    $best_city = $maybe_city;
                    $best_sim = $sim;
                }
            }
// display_notification($best_city);
            return $_SESSION['tax_rates'][$best_city];
        }
    }

/*
    The API provides only tax collection info
    and does not have sufficient information for filing (service fees, home rule status, exemptions)
*/

    function updateTaxRates($obj, $j)
    {
        $t = get_tax_rate_by_code($j);
        if (abs($t["total"] - $obj->totalSalesTax * 100) > .01)
            display_error("Inconsistent API/spreadsheet taxes for jurisdiction " . $j . ":" . $t["total"] . " != "  . $obj->totalSalesTax * 100);
    }

    function getJurisdictionByAPI($address)
    {
        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, 'https://api.ttr.services/v1/automation.rates.list');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, "{\"address\": \"$address\"}");

        $headers = array();
        $headers[] = 'Content-Type: application/json';
        $headers[] = 'Accept: application/json';
        $headers[] = 'Authorization: Bearer ' . get_company_pref("ttr_services_bearer_token");
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

        $result = curl_exec($ch);
        if (curl_errno($ch)) {
            display_error('Error:' . curl_error($ch));
            return null;
        }
        curl_close($ch);

        $obj = json_decode($result);

        // display_notification(print_r($obj, true));
        // display_notification($obj->totalSalesTax);

        $jurisdiction = str_replace("-", "", $obj->jurisdictionCode);
        setJurisdiction($address, $jurisdiction);
/* FA only */
        updateTaxRates($obj, $jurisdiction);
/* */
        return $jurisdiction;
    }

    function get_tax_rate_by_code($j)
    {
        if (!isset($_SESSION['tax_rates_by_code']))
            do_init_rate();
        return $_SESSION['tax_rates_by_code'][$j];
    }

    // get_tax_rates() uses a postal address to lookup the jurisdiction tax rate.
    function get_tax_rates($address)
    {
        $orig_address = $address;
        $address = trim($address);

        // strip off name
        $address = preg_replace("/^[^0-9]*/", "", $address);
        $address = str_replace(array("\r\n", "\n", "\r"), ' ', $address);
        $address = str_replace(array(" United States"), '', $address);

        $code = getJurisdictionByFile($address);
        if (!$code)
            $code = getJurisdictionByAPI($address);
        if ($code)
            return get_tax_rate_by_code($code);

        return get_tax_rates_by_city($orig_address);
    }

    function get_tax_rate($tax_group_name, $address)
    {
//display_notification($tax_group_name);
        if ($tax_group_name == "Colorado Sales Tax" && date('Ym') >= "201906")
            return get_tax_rates($address)['total'];
    }
?>
