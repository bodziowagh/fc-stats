# Aim is to gather focal length data of photos from the directory and create a simple statistics 
# Version one - just get a focal length of a single photo 

if test -f $1; then
	FOCAL_LENGTH=$(cut -d '=' -f2 <<< $(mdls $1 | grep -m 1 FocalLength) | tr -d '\ ')

	echo "Focal length used: $FOCAL_LENGTH"
else
	echo "Please provide the file name as an argument"
fi
