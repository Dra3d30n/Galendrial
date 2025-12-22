import os
import shutil

BASE_DIR = r"C:\Users\sebib\OneDrive\Documents\galendrial\Galendrial\Assets\UI\items801"
MAX_ID = 35000
GROUP_SIZE = 1000

for i in range(1, MAX_ID + 1):
	filename = f"{i}.png"
	file_path = os.path.join(BASE_DIR, filename)

	if not os.path.isfile(file_path):
		continue

	group_start = ((i - 1) // GROUP_SIZE) * GROUP_SIZE + 1
	group_end = group_start + GROUP_SIZE - 1
	folder_name = f"{group_start}-{group_end}"

	dest_folder = os.path.join(BASE_DIR, folder_name)
	os.makedirs(dest_folder, exist_ok=True)

	shutil.move(file_path, os.path.join(dest_folder, filename))

print("Done.")
