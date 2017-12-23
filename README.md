Image Segmentation and Dimension Analysis
=========================================

Introduction
------------
Automated dimension analysis from an image is of immense importance in today's world. Current projects present in this domain do not provide a robust and easy to use UI. In the following project creates a robust software that works for most of the pictures while keeping in mind the ease of access.
At the present stage this provides all the basic dimension that are important.

The code was tested on Matlab 2017a.

* Please refer to [Report.pdf](Report.pdf) for detailed analysis.
* Please refer to [lab.pdf](lab.pdf) for about the project.
* Please refer to [results](results) for segmentation results using various methods.


Directory Structure
-------------------
---code
	|
	|---RunAll.m
	|---Find_Bound_Box.m
	|---Calculate_Boundary.m
---[results](results)
	|
	|---[Active](Active)
	|---[Inbuilt](Inbuilt)
	|---[Lazy](Lazy)
	|---[Morphological](Morphological)

---[lab.pdf](lab.pdf)

---README.md

---[Report.pdf](Report.pdf)

---[Literature_Review.pdf](Literature_Review.pdf)


To Run
------
RunAll( RGB, method) - Generates the boundary box around and calculate the
 bounding box dimension and boundary dimension 
  Specify method as 'lazy'(default) , 'active contour', 'morphological', 'matlab'

e.g. 

>> RunAll(imread('data/Phone 1.jpg'),'lazy')

>> RunAll(imread('data/Phone 2.jpg'),'active contour')

>> RunAll(imread('data/shoe.jpg'),'morphological')

Developed By
============
Naman Goyal (2015CSB1021)
Koustav Das (2015CSB1017)
