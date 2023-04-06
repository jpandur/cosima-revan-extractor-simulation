import sys
import json
import pickle

file = sys.argv[1] # Original pickle file
destination = sys.argv[2] # File to be written to

obj = pickle.load(open(file, "rb"))

with open(destination, "a") as f:
    json.dump(obj, f, indent=2)