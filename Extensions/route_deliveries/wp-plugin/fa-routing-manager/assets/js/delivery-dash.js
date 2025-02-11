// Function to enable editing of the delivery row when the edit button is clicked
document.querySelectorAll('.edit-btn').forEach(button => {
    button.addEventListener('click', function() {
        const rowId = button.getAttribute('data-row-id');
        const editRow = document.getElementById('edit-form-' + rowId);

        // Check if the edit form row is currently visible
        if (editRow.style.display === 'table-row') {
            // Hide the edit form row
            editRow.style.display = 'none';

            // Enable the edit button when hidden (optional)
            button.disabled = false;
        } else {
            // Show the edit form row
            editRow.style.display = 'table-row';

            // Disable the edit button after clicking (optional)
            button.disabled = true;
        }
    });
});

// Function to get the current GPS location (latitude and longitude)
function getGPS() {
    return new Promise((resolve, reject) => {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                function(position) {
                    resolve({
                        lat: position.coords.latitude,
                        lon: position.coords.longitude
                    });
                },
                function(error) {
                    reject('Error getting location');
                }
            );
        } else {
            reject('Geolocation not supported');
        }
    });
}

// Handle form submission and append GPS coordinates
document.querySelectorAll('.edit-delivery-form').forEach(form => {
    form.addEventListener('submit', function(event) {
        event.preventDefault(); // Prevent default form submission

        // Get the GPS location at the time of submission
        getGPS()
            .then(gps => {
                // Ensure the form contains a hidden input for gps_coordinates
                let gpsInput = form.querySelector('#gps_coordinates');
                
                // If the hidden input is not found, create it
                if (!gpsInput) {
                    gpsInput = document.createElement('input');
                    gpsInput.type = 'hidden';
                    gpsInput.name = 'gps_coordinates';
                    form.appendChild(gpsInput);
                }

                // Set the GPS coordinates in the hidden field
                gpsInput.value = `${gps.lat},${gps.lon}`;

                // Now submit the form (e.g., using AJAX or a normal form submission)
                // Here, we're submitting the form normally:
                form.submit();
            })
            .catch(error => {
                alert(error);
            });
    });
});

// Cancel the edit form row display when the cancel button is clicked
document.querySelectorAll('.cancel-btn').forEach(button => {
    button.addEventListener('click', function() {
        const editRow = button.closest('.edit-form-row');
        
        // Hide the edit form row
        editRow.style.display = 'none';

        // Enable the edit button again
        const editButton = document.querySelector(`.edit-btn[data-row-id="${editRow.id.replace('edit-form-', '')}"]`);
        if (editButton) editButton.disabled = false;
    });
});
