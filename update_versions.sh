#!/bin/bash
# Script to update the versions of the dependencies in the project with the latest versions (/versions)
# Usage: ./update_versions.sh

# Define the files to check and update
files=("main.js" "styles.css")

# Function to update version
update_version() {
	file=$1
	version_file="/versions/$file.version"
	# Get the current version
	current_version=$(cat $version_file)
	# Split the version into an array
	IFS='.' read -r -a version_array <<<"$current_version"
	# Increment the last element of the array
	version_array[2]=$((${version_array[2]} + 1))

	# If the last element is 100, reset it and increment the previous element
	if [ ${version_array[2]} -eq 100 ]; then
		version_array[2]=0
		version_array[1]=$((${version_array[1]} + 1))
	fi

	# If the second element is 100, reset it and increment the first element
	if [ ${version_array[1]} -eq 100 ]; then
		version_array[1]=0
		version_array[0]=$((${version_array[0]} + 1))
	fi

	# Join the array into a string
	new_version=$(
		IFS='.'
		echo "${version_array[*]}"
	)
	# Update the file with the new version
	echo $new_version >$version_file
}

# Check each file
for file in "${files[@]}"; do
	# Check if there are changes in the file
	if ! git diff --quiet $file; then
		echo "Changes detected in $file. Updating version..."
		update_version $file
	else
		echo "No changes in $file."
	fi
done
