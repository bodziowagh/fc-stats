# Get focal length data of photos from the directory and create a simple statistics 

DIRECTORY=$1

if [ ! -d $DIRECTORY ]; then
	echo "Error: The argument is either empty or invalid"
	exit 1
fi

FILES_PATTERNS=(
	"${DIRECTORY}/*.jpg"
	"${DIRECTORY}/*.JPG"
)
COUNT=0
FOCAL_LENGTHS=()
FOCAL_LENGTHS_COUNTS=()

add_focal_length () {
	FOCAL_LENGTH=$1

	if [ -z $FOCAL_LENGTH ]; then
		return 1
	fi

	for i in "${!FOCAL_LENGTHS[@]}"; do 
		if [ "${FOCAL_LENGTHS[$i]}" == "$FOCAL_LENGTH" ]; then
			FOCAL_LENGTHS_COUNTS[$i]=$((${FOCAL_LENGTHS_COUNTS[$i]} + 1))
			return 0
		fi
	done

	FOCAL_LENGTHS+=($FOCAL_LENGTH)
	FOCAL_LENGTHS_COUNTS+=(1)
}

for FILES in $FILES_PATTERNS; do
	for file in $FILES; do
		FOCAL_LENGTH=$(cut -d '=' -f2 <<< $(mdls $file | grep -m 1 FocalLength) | tr -d '\ ')

		COUNT=$(($COUNT + 1))
		add_focal_length $FOCAL_LENGTH

		echo "$file: \t$FOCAL_LENGTH"	# TODO: add if verbose
	done
done

if [ ! $COUNT -ge 0 ]; then
	echo "Error: No matching files"
	exit 0
fi

echo "\nSuccess! Processed $COUNT files.\n"

for i in "${!FOCAL_LENGTHS_COUNTS[@]}"; do 
	FOCAL_LENGTH=${FOCAL_LENGTHS[$i]}
	FOCAL_LENGTH_COUNT=${FOCAL_LENGTHS_COUNTS[$i]}

	echo "$FOCAL_LENGTH: \t$FOCAL_LENGTH_COUNT \t($(($FOCAL_LENGTH_COUNT * 100 / $COUNT))%)"
done
 