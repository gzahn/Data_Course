## Shell practice tasks:

1. For each of the filenames that begin with "M" in the directory "~/Data_Course/data/data-shell/data/pdb" list the number of lines in each file.

2. Redirect the output from the previous task to a new file named "m_lines.txt" in "~/Data_Course_YOUR_LAST_NAME/"

3. For the file "animals.txt" in "~/Data_Course/data/data-shell/data/" get an alphabetical list of the unique animal types that were observed and redirect this list to "unique_animals.txt" in "~/Data_Course_YOUR_LAST_NAME/"

4. In the directory "~/Data_Course/data/data-shell/data/" write a command that finds the longest .txt file (by number of lines)
	Hint: wc, sort, tail, head

5. In the directory "~/Data_Course/data/data-shell/many_files/" there are a large number of subdirectories. Buried inside these subdirectories are some .txt files that all contain a list of numbers (one interger per line). 
There is a shell script in the directory "~/Data_Course/data/data-shell/scripts" "called sum_lines.sh"

Your task is to run this script on ALL the .txt files buried within the "many_files/" directory to output the sums of all the lines in each file
This is a tough one. Remember that to run a shell script you need to type "bash PATH_TO_SCRIPT"
	Hint: find -exec, for loop


