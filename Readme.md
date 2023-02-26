# Script to Download Files from URLs

This script downloads files from URLs listed in an input file and writes the status of each download to an output file. The script uses wget to download files and reports whether each file was downloaded successfully or not.

## Usage

To use this script, run the following command in the terminal:
```
./downloader.sh input_file
```

Replace `input_file` with the name of your input file, which should contain one URL per line.
## Commands

The script uses the following commands:

- `cleanup()`: A function that writes the status of each file to the output file and exits the script gracefully when interrupted with SIGINT.
- `trap cleanup INT`: Sets up a signal handler to catch SIGINT and run the `cleanup` function.
- `if [ $# -eq 0 ]`: Checks if an input file was specified and exits with an error message if not.
- `wget`: Downloads files from URLs and reports whether the download was successful or not.
- `echo`: Writes output to the console and output file.
- `sed`: Extracts the filename from the HTTP header returned by wget.
- `awk`: Extracts the file size from the HTTP header returned by wget.
- `du`: Calculates the size of a file.
- `basename`: Extracts the filename from a URL.

## Example

Suppose you have a file `urls.txt` containing the following URLs:

https://example.com/file1.txt
https://example.com/file2.txt
https://example.com/file3.txt


You can use the script to download these files and write the status of each download to `output.txt` by running the following command:

./download.sh urls.txt

After the downloads are complete, the script will print "All downloads completed successfully" to the console, and you can view the status of each file in `output.txt`.

