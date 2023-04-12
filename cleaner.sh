# start timer
start=$(date +%s.%N)

# git add rem.repo

# Get a list of all modified and untracked files
modified_files=$(git status --porcelain | awk '$1 != "D" && $1 != "???" { print $2 }')

# #all tracked files
# #tracked_files=$(git ls-tree --full-tree --name-only -r HEAD )

# for file in $files; do
# git add $file
# done

# git stash

# Read filelist.txt into an array
# readarray -t filelist < $modified_files
readarray -t fileArray <<< "$modified_files"

#WORKING
# # Loop through all files in the directory
# for file in *; do
# # echo "Our file is $file"

#  # Check if file is in filelist array
#   if [[ " ${filelist[@]} " =~ " ${file} " ]]; then
#     echo "Skipping $file"
#   else
#       # Delete the file
#     # rm -f "$file"
#     echo "Deleted $file"
    
#   fi
# done

# Define the function to search for files

folder="$PWD"

# Define the function to search for files
search_folder() {
  local folder="$1"
  local fileArray=("$@")
  local file
  for file in "$folder"/*; do
    if [ -d "$file" ]; then
      # If the file is a directory, recursively search it
      search_folder "$file" "${fileArray[@]}"
    else
      # If the file is a regular file, check if its name is in the array
      if [[ "${fileArray[*]}" =~ "$(basename "$file")" ]]; then
        echo "File found: $file"
      else
        # echo "Deleting file: $file"
        git rm -q $file
        # rm -r $file
		    # git rm -q --cached $file
      fi
    fi
  done
}

# Call the function with the root folder to start the search
search_folder "$PWD" "${fileArray[@]}"

git commit -m'Deleted files'





# for file in $files; do
# git checkout HEAD -- $file
# done

# git pop

# Loop over each file in the list and remove it from Git's index if it has no changes
# for file in $files; do
#   if [ -f $file ] || [ -d $file ]; then
#     if git diff --quiet -- $file && git diff --cached --quiet -- $file; then
#       git rm --cached $file

#       # Check if the file or directory exists on the file system
#       if [ -e $file ]; then
#         # If it's a directory, remove all of its contents first
#         if [ -d $file ]; then
#           rm -r $file/*
#         fi

#         # Then remove the file or directory itself
#         rm -r $file
#       fi
#     fi
#   fi
# done

# Remove empty directories from Git's index and from the file system
# find . -type d -empty -delete

# # Commit the changes
# # git diff --quiet --exit-code --cached || git commit -m "Remove empty directories and files" --allow-empty


# git rm -r --cached .

git reflog expire --expire=now --all
git gc --prune=now --aggressive


# end timer
end=$(date +%s.%N)
runtime=$(echo "$end - $start" | bc)

printf "Script execution time: %.3f seconds\n" $runtime

#pause in bash is using read command like this
read -t 3600 -p "I am going to wait for 3600 seconds ..."

