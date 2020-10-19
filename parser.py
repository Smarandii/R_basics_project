dataset = open('Prestige.txt', 'r')
new_dataset = open('new_Prestige.txt', 'w')

def remove_none(l):
	n_list = []
	for elem in l:
		if elem == "" or elem is None:
			pass
		else:
			n_list.append(elem)
	return n_list

def str_from_list_elem(elem):
	string = ''
	for e in elem:
		print(string, e)
		string += e.strip() + ","

	return string[0:-1:] + "\n"	

with dataset as dataset:
	new_dataset_list = []
	for line in dataset:
		if '\t' in line:
			line = line.split('\t')
		if ' ' in line:
			line = line.split(' ')
		new_dataset_list.append(remove_none(line))
	with new_dataset as new_dataset:
		for line in new_dataset_list:
			new_dataset.write(str_from_list_elem(line))
