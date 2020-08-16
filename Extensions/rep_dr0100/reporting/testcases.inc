<?php
$testcases = array(
    "1" => array(
        "period" => "2020-01",
        "coacct" => "53133270",
        "name" => "AAA Sales",
        "sales" => array(
            array("site" => 531332700001,
                "code" => "010006",
                "description" => "Test Location",
                "gross" => 1000000,
                "OutsideOfColorado" => 50000
            ),

            array("site" => 531332700002,
                "code" => "070003",
                "description" => "Test Location",
                "gross" => 90000,
                "Service" => 4000,
                "AgriculturalSales" => 800
            ),

            array("site" => 531332700003,
                "code" => "100011",
                "description" => "Test Location",
                "gross" => 80000,
                "ExemptEntities" => 7000,
                "BadDebt" => 600,
                "UtilitiesRestaurant" => 500,
                "Tradeins" => 400
            ),

            array("site" => 531332700004,
                "code" => "570001",
                "description" => "Test Location",
                "gross" => 70000,
                "State" => array("SchoolRelatedSales" => 1000,
                    "LowEmitVehicle" => 15000,
                    "SpaceFlight" => 200),
                "RTA" => array("SchoolRelatedSales" => 1000,
                    "LowEmitVehicle" => 15000,
                    "SpaceFlight" => 200,
                    "Cigarettes" => 700),
                "County" => array(
                    "Cigarettes" => 700),
            )
        ),
    ),
    "2" => array(
        "period" => "2020-01",
        "coacct" => "52131415",
        "name" => "BBB Products",
        "sales" => array(
            array("site" => 521314150001,
                "code" => "070050",
                "description" => "Test Location",
                "gross" => 10000,
                "OutsideOfColorado" => 1100,
                "State" => array(
                    "Food" => 1000,
                    "Machinery" => 900,
                    "FarmEquipment" => 800),
                "RTD" => array(
                    "Food" => 1000,
                    "Machinery" => 900,
                    "FarmEquipment" => 800),
                "CD" => array(
                    "Food" => 1000,
                    "Machinery" => 900,
                    "FarmEquipment" => 800),
                "County" => array(
                    "Food" => 1000,
                    "Machinery" => 900,
                    "FarmEquipment" => 800),
            ),
            array("site" => 521314150002,
                "code" => "080044",
                "description" => "Test Location",
                "gross" => 9000,
                "WholesaleSales" => 1000,
                "State" => array(
                    "Electricity" => 500,
                    "SchoolRelatedSales" => 900,
                    "FarmEquipment" => 100),
                "County" => array(
                    "Electricity" => 500,
                    "SchoolRelatedSales" => 900,
                    "FarmEquipment" => 100),
                "PSI" => array(
                    "Electricity" => 500,
                    "SchoolRelatedSales" => 900,
                    "FarmEquipment" => 100),
            ),
            array("site" => 521314150003,
                "code" => "110150",
                "description" => "Test Location",
                "gross" => 8000,
                "Gas" => 800,
                "State" => array(
                    "RetailMarijuana" => 700),
                "MDT" => array(
                    "RetailMarijuana" => 700),
            ),
            array("site" => 221314150559,
                "code" => "430208",
                "description" => "Test Location",
                "gross" => 7000,
                "ComputerSoftware" => 600)
            ),
        ),
);

?>
