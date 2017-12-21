# Acropolis platform - BDD testing Suite
*Experimental stage*




## Table of Contents
1. [Introduction](#intro)
2. [Folder structure](#folder)
3. [Run tests](#run)
4. [Add test cases](#add)
5. [Testing approach](#approach)
6. [Notes](#notes)

# Introduction<a name="intro"></a>

Acropolis API is tested using [behave](https://github.com/behave/behave) BDD testing framework.

Once the platform is up and running (use [README-docker.md](README-docker.md) for instructions on platform Docker build)


# Folder structure<a name="folder"></a>
```
/behave-data
|___/data (contains sample data)
	/features (contains scenario/feature definitions)
	|__environment.py (hooks for further operations before/after each scenario)
		|__/steps
			|__common.py (high level test implementation)
			|__resutils.py (low level RDF internals)
```
# Run tests<a name="run"></a>

### 1. Create/Activate virtualenv for python 3.6

### 2. Install all dependencies via pip

```python
pip install -r requirements.txt
```

### 3. Run variations

Default configuration for BDD tests is via file: [behave.ini](behave.ini)<br>
Either override values or delete file to edit test run.

-  Run all tests
```
behave
```
-  Run single feature
```
behave features/{name}.feature
```
-  Run only test with tag @tag
```
behave --tags @tag
```
-  Run only test without tag @tag
```
behave --tags -@tag
```
-  export junit report
```
behave --junit
```

# Add test cases<a name="add"></a>

To add more test cases follow the steps:
- Add the appropriate sample data under `/data`
- Add the feature definition under `/features`
- Extend `/features/steps/common.py` with implementation steps if they are currently undefined.
Behave will provide you with a starting code snippet in such case.

# Testing approach<a name="approach"></a>

A brief description of test features included under `/features` folder

- partitions
	- Test against partition existence and corresponding label
- query.q
	- Test against the use of `q` query parameter
- query.media
	- Test against the use of `media` query parameter
- query.for
	- Test against the use of `for` query parameter

# Notes<a name="notes"></a>

- Add newline(`\n`) to every print/log statement to get colorful output with debug, even in case of test success
https://stackoverflow.com/questions/25150404/how-can-i-see-print-statements-in-behave-bdd
