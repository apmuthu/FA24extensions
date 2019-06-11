<?php
$tax_rates = array();

function  do_init_rate() {
   global $path_to_root, $tax_rates;
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
        $location=trim($value['Location']);
        if ($location == "UNINCORPORATED NO PHYSICAL LOCATION")
            $value['Location'] = $location = strtoupper(trim($value['County']) . " COUNTY");
        else if ($location == "UNINCORPORATED")
            $value['Location'] = $location = strtoupper("UNINCORPORATED " . trim($value['County']) . " COUNTY");
        for ($i=0; $value[$i] != null; $i +=3)
            $value['total'] += $value[$i+1];
        $tax_rates[$location] = $value;
    }
    $tax_rates['GRAND JUNCTION'] = $tax_rates['UNINCORPORATED MESA COUNTY'];
    $tax_rates['ENGLEWOOD'] = $tax_rates['UNINCORPORATED DOUGLAS COUNTY'];
}

    function get_tax_rates($tax_group_name, $address)
    {
        global $tax_rates;
        if ($tax_group_name == "Colorado Sales Tax") {
            if ($tax_rates == array())
                do_init_rate();
//display_notification(print_r($tax_rates, true));
            $i = strpos($address, ",");
            $j = strrpos($address, "\n", -(strlen($address)-$i));
            $k = substr($address, $j+1, $i-$j+1);
            $city = trim($k);
            $city = strtoupper(str_replace(',','', $city));

            if (isset($tax_rates[$city]))
                return $tax_rates[$city];
        }
    }

    function get_tax_rate($tax_group_name, $address)
    {
//display_notification($tax_group_name);
        if ($tax_group_name == "Colorado Sales Tax" && date('Ym') >= "201906")
            return get_tax_rates($tax_group_name, $address)['total'];
    }
?>
