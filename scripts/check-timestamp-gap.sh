#!/bin/bash

# Function to convert timestamp to seconds since the epoch
convert_to_epoch() {
  # Extract timestamp part and convert to epoch time
  timestamp=$(echo "$1" | grep -oP '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}')
  date -d "$timestamp" +"%s"
}

log_lines=$(echo $(sudo journalctl | grep flightctl))

# Loop through the log lines and compare timestamps
previous_epoch=""
for log_line in "${log_lines[@]}"; do
  current_epoch=$(convert_to_epoch "$log_line")

  # If there is a previous timestamp, calculate the difference
  if [ -n "$previous_epoch" ]; then
    # Calculate time difference in seconds
    time_diff=$(( current_epoch - previous_epoch ))

    # Check if the difference is greater than 600 seconds (10 minutes)
    if (( time_diff > 600 )); then
      echo "Time difference between log lines is greater than 10 minutes: $time_diff seconds."
    else
      echo "Time difference is less than or equal to 10 minutes: $time_diff seconds."
    fi
  fi

  # Store the current timestamp for the next comparison
  previous_epoch=$current_epoch
done

