<?php
$tax_rates = array();
$tax_rates_by_code = array();

function  do_init_rate() {
   global $path_to_root, $tax_rates, $tax_rates_by_code;
   $csv = array_map('str_getcsv', file($path_to_root . "/modules/tax_rate" . "/ColoradoJurisdictionCodesRates.csv"));
   foreach ($csv[0] as $key =>$value)
    $csv[0][$key]=preg_replace( '/\s*/m', '',$value);

$csv[0] = array_slice($csv[0], 0, 7);
//display_notification(print_r($csv[0], true));

    array_walk($csv, function(&$a) use ($csv) {
      $a = array_merge(array_combine($csv[0], array_slice($a, 0, 7)), array_slice($a,7));
    });
    array_shift($csv); # remove column header

    foreach ($csv as $value) {
        $value['total'] = 0;
        $location = $value['Location'] = trim($value['Location']);
// Note: The ColoradoJurisdictionCodesRates.csv has entries for UNINCORPORATED PHYSICAL LOCATION
// but these are not used.  For example, the wwhsitenumbers.csv file has entries like
// 470206,AURORA-DOUGLAS (0206),15144190004,Multi Loc (Non-Physical) but not for 470207
        if ($location == "UNINCORPORATED")
            $value['Location'] = $location = strtoupper(trim($value['County']) . " COUNTY");
        for ($i=0; $value[$i] != null; $i +=3) {
            if (strpos($value[$i], 'food') === false
                && $value[$i] != 'LID')  // Local improvement district, probably small area
                $value['total'] += $value[$i+1];
        }

        // Use highest tax rate if location is duplicate
        // applies to DENVER
        if (!isset($tax_rates[$location])
            || $tax_rates[$location]['total'] < $value['total'])
            $tax_rates[$location] = $value;

        $tax_rates_by_code[$value['JurisdictionCode']] = $value;
    }
    $tax_rates['GRAND JUNCTION'] = $tax_rates['MESA COUNTY'];
    $tax_rates['ENGLEWOOD'] = $tax_rates['DOUGLAS COUNTY'];
}

    function get_tax_rates($tax_group_name, $address)
    {
        global $tax_rates;
        if ($tax_group_name == "Colorado Sales Tax") {
            if ($tax_rates == array())
                do_init_rate();
//display_notification(print_r($tax_rates, true));
            $i = strrpos($address, ",");
            $j = strrpos($address, "\n", -(strlen($address)-$i));
            $k = substr($address, $j+1, $i-$j+1);
            $city = trim($k);
            $city = strtoupper(str_replace(',','', $city));

            if (isset($tax_rates[$city]))
                return $tax_rates[$city];
            else {
                $best_city = 0;
                $best_sim = -1;
                foreach ($tax_rates as $maybe_city => $rate) {
                    $sim = levenshtein(substr($maybe_city,0,strlen($city)), $city);
                    if ($best_sim == -1
                        || $sim < $best_sim
                        || $sim == $best_sim && $rate['total'] > $tax_rates[$best_city]['total']) {
                        $best_city = $maybe_city;
                        $best_sim = $sim;
                    }
                }
//display_notification($best_city);
                return $tax_rates[$best_city];
            }
        }
    }

    function get_tax_rate($tax_group_name, $address)
    {
//display_notification($tax_group_name);
        if ($tax_group_name == "Colorado Sales Tax" && date('Ym') >= "201906")
            return get_tax_rates($tax_group_name, $address)['total'];
    }

    function get_tax_rate_by_code($j)
    {
        global $tax_rates_by_code;
        if ($tax_rates_by_code == array())
            do_init_rate();
        return $tax_rates_by_code[$j];
    }
?>
