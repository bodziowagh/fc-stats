# Aim is to gather focal length data of photos from the directory and create a simple statistics 

DIRECTORY=$1

if [ ! -d $DIRECTORY ]; then
	echo "Error: The argument is either empty or invalid"
	exit 1
fi

FILES="${DIRECTORY}/*.jpg ${DIRECTORY}/*.JPG"

if [ ! -e $FILES ]; then
	echo "Error: No files have been matched"
	exit 1
fi

COUNT=0

# 0-10 10-20 20-30 ... 80-90 90-100 >100
FOCAL_LENGTH_COUNTS=(0 0 0 0 0 0 0 0 1 0 0)

for file in $FILES; do
	FOCAL_LENGTH=$(cut -d '=' -f2 <<< $(mdls $file | grep -m 1 FocalLength) | tr -d '\ ')

	COUNT=$((COUNT + 1))

	if [ $FOCAL_LENGTH -gt 100 ]; then
		FOCAL_LENGTH_COUNTS[10]=$((${FOCAL_LENGTH_COUNTS[1]} + 1))
	else
		index=$((FOCAL_LENGTH / 10))
		FOCAL_LENGTH_COUNTS[$index]=$((${FOCAL_LENGTH_COUNTS[$index]} + 1))
	fi

	echo "$file: \t$FOCAL_LENGTH"
done

echo "\nSuccess! Processed $COUNT files.\n"

for i in "${!FOCAL_LENGTH_COUNTS[@]}"; do 
	VALUE=${FOCAL_LENGTH_COUNTS[$i]}

	if [ $i -lt 10 ]; then
  		echo "$(($i * 10)) - $(($i * 10 + 10)): \t$VALUE \t($(($VALUE * 100 / $COUNT))%)"
	else
		echo "> 100: \t\t${FOCAL_LENGTH_COUNTS[$i]}\t($(($VALUE * 100 / $COUNT))%)"
	fi
done
 