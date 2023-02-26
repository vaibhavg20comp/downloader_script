#!/bin/bash


function cleanup() {
    echo "Exiting gracefully. Writing the status of the remaining files to output.txt"
    exit_status=130 # Exit status when interrupted by SIGINT
    for ((i=$counter;i<$num_lines;i++)); do
        url=$(sed -n "${i}p" "$input_file")
        header=$(wget --spider --server-response --content-disposition "$url" 2>&1 | grep -i 'content-disposition')
        filename=$(echo "$header" | sed -e 's/^.*filename=//' -e 's/^"//' -e 's/"$//')
        filesize=$(wget --spider --server-response "$url" 2>&1 | awk '/Content-Length:/ {print $2}')
        if [[ -f "$filename" ]]; then
            size=$(du -h "$filename" | cut -f 1)
            if [[ "$size" == "$filesize" ]]; then
                echo "$filename | Downloaded | $size" >> "$output_file"
            else
                echo "$filename | Partially Downloaded | $size" >> "$output_file"
            fi
        else
            echo "$filename | Failed" >> "$output_file"
        fi
    done
    exit "$exit_status"
}

trap cleanup INT

if [ $# -eq 0 ]
then
    echo "Error: Input file not specified!"
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="output.txt"

echo "Filename | Status | Size" > "$output_file"
echo "-------- | ------ | ----" >> "$output_file"

num_lines=$(wc -l "$input_file" | awk '{print $1}')
urls=()

while read url; do
    ((counter++))
    urls+=("$url")
    header=$(wget --spider --server-response --content-disposition "$url" 2>&1 | grep -i 'content-disposition')
    filename=$(echo "$header" | sed -e 's/^.*filename=//' -e 's/^"//' -e 's/"$//')
    if [[ -n "$filename" ]]; then
        wget -q --show-progress --content-disposition -O "$filename" "$url"
        size=$(du -h "$filename" | cut -f 1)
        if [[ -s "$filename" ]]; then
            echo "$filename | Downloaded | $size" >> "$output_file"
        else
            echo "$filename | Partially Downloaded | $size" >> "$output_file"
        fi
    else
        wget -q --show-progress -O "$(basename "$url")" "$url"
        size=$(du -h "$(basename "$url")" | cut -f 1)
        if [[ -s "$(basename "$url")" ]]; then
            echo "$(basename "$url") | Downloaded | $size" >> "$output_file"
        else
            echo "$(basename "$url") | Failed | $size" >> "$output_file"
        fi
    fi
done < "$input_file"

echo "All downloads completed successfully"

