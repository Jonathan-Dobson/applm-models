file="pyproject.toml"

# Check if the file is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file=$1

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File not found!"
    exit 1
fi

version=$(awk '/version/{print $3} ""'  "$file")


new_version=$(awk '{gsub(/"/,""); print $0}' pyproject.toml | \
awk '/version/ {print $3}')
major=$(echo $new_version | cut -d. -f1)
minor=$(echo $new_version | cut -d. -f2)
inc=$(echo $new_version | awk '{gsub(/\./," "); print $3 + 1}')

original=$(awk '/version/' pyproject.toml)
replace="version = \"$major.$minor.$inc\""

echo $original 
echo $replace

awk -v original="$original" -v replace="$replace" \
    '{gsub(original,replace); print}' "$file" > "$file.new"

rm "$file"
mv "$file.new" "$file"
