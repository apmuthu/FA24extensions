console.log("🔥 barcode_helper.js loaded");

document.addEventListener('DOMContentLoaded', function () {
    console.log("📦 DOM fully loaded");

    const barcodeInput = document.getElementById('barcode_input');

    if (!barcodeInput) {
        console.warn("❌ barcode_input not found!");
        return;
    }

    console.log("✅ Found barcode input");

    barcodeInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault(); // Prevent form submit
            const barcode = barcodeInput.value.trim();

            if (!barcode) {
                console.warn("⚠️ Barcode is empty");
                return;
            }

            console.log("📨 Fetching item for barcode:", barcode);

            fetch(`../barcode_sales_helper/get_item_from_barcode.php?barcode=${encodeURIComponent(barcode)}`)
                .then(response => {
                    if (!response.ok) throw new Error("Network response not OK");
                    return response.json();
                })
                .then(data => {
                    console.log("✅ Server response:", data);

                    if (!data.success || !data.stock_id) {
                        alert("❌ Item not found for barcode: " + barcode);
                        barcodeInput.value = '';
                        barcodeInput.focus();
                        return;
                    }

                    // Set the form fields
                    const stockIdField = document.getElementsByName('stock_id')[0];
                    const qtyField = document.getElementsByName('qty')[0];

                    if (!stockIdField || !qtyField) {
                        alert("❌ One or more input fields not found in the form.");
                        return;
                    }

                    stockIdField.value = data.stock_id;
                    qtyField.value = '1'; // default quantity

                    console.log("🛒 Adding item:", data.stock_id);

                    setTimeout(() => {
                        const addItemBtn = document.getElementById('AddItem');
                        if (addItemBtn) {
                            addItemBtn.click();
                            console.log("✅ AddItem clicked");
                        } else {
                            console.warn("❌ AddItem button not found");
                        }
                    
                        // First attempt to focus immediately
                        barcodeInput.value = '';
                        barcodeInput.focus();
                    
                        // In case FA redraws the DOM and steals focus, do it again after a short delay
                        setTimeout(() => {
                            barcodeInput.focus();
                            console.log("🔁 Refocused on barcode input");
                        }, 300); // Delay can be tweaked
                    
                    }, 100);
                    
                })
                .catch(err => {
                    console.error("❌ Error during barcode fetch:", err);
                    alert("⚠️ Failed to fetch item from barcode.");
                });
        }
    });
});
