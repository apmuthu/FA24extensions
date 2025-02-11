<?php

/**
 * Helper function to calculate due dates for a delivery within a date range.
 */
function calculate_due_dates($delivery, $start_date, $end_date) {
    $due_dates = [];
    $start = new DateTime(max($delivery['start_date'], $start_date));
    $end = $delivery['end_date'] ? new DateTime(min($delivery['end_date'], $end_date)) : new DateTime($end_date);
    $interval = new DateInterval('P1D'); // Default to 1 day

    switch ($delivery['recurrence_type']) {
        case 'daily':
            $interval = new DateInterval('P' . $delivery['custom_interval'] . 'D');
            break;
        case 'weekly':
            $interval = new DateInterval('P' . ($delivery['custom_interval'] * 7) . 'D');
            break;
        case 'monthly':
            $interval = new DateInterval('P' . $delivery['custom_interval'] . 'M');
            break;
        case 'yearly':
            $interval = new DateInterval('P' . $delivery['custom_interval'] . 'Y');
            break;
        default:
            if ($delivery['recurrence_type'] === null) {
                // One-time delivery
                if ($delivery['start_date'] >= $start_date && $delivery['start_date'] <= $end_date) {
                    $due_dates[] = $delivery['start_date'];
                }
                return $due_dates;
            }
            break;
    }

    $current = $start;
    while ($current <= $end) {
        // Handle specific rules (e.g., days of week, day of month, etc.)
        if (is_due($current, $delivery)) {
            $due_dates[] = $current->format('Y-m-d');
        }
        $current->add($interval);
    }

    return $due_dates;
}

/**
 * Helper function to determine if a date matches the recurrence rules.
 */
function is_due($date, $delivery) {
    $day_of_week = $date->format('N'); // 1 (Monday) to 7 (Sunday)
    $day_of_month = $date->format('j'); // Day of month
    $month_of_year = $date->format('n'); // Month of year

    // Check days of week
    if ($delivery['days_of_week'] && !in_array($day_of_week, explode(',', $delivery['days_of_week']))) {
        return false;
    }

    // Check day of month
    if ($delivery['day_of_month'] && $delivery['day_of_month'] != $day_of_month) {
        return false;
    }

    // Check month of year
    if ($delivery['month_of_year'] && $delivery['month_of_year'] != $month_of_year) {
        return false;
    }

    return true;
}
