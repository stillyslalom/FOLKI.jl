# ME 759 Final Project
## GPU acceleration of particle image velocimetry
## Alex Ames
### What’s the idea?
Given an input image pair, determine the velocity vector field using a recursive
gradient-based image deformation algorithm based on Lucas-Kanade optical flow,
adapted for the unique illumination characteristics of PIV images.
#### FOLKI (flot optique Lucas-Kanade itératif) algorithm
* Read image data (.tif, .png, other uncompressed formats?) from given filepath
* Read metadata (interframe time, pixel spacing) from configuration file
* Normalize/filter/clean image data
* Resample image at n ∈ N resolution levels, dividing the resolution by 2 each time
* Starting at the lowest-resolution image, determine & upsample displacement fields:
  * Compute spatial intensity gradient of initial image
  * Compute 2x2 minimization matrices $H$ for each pixel
  * Iteratively:
    * Compute deformed image intensity from prior displacement estimate $u_0$
    * Compute RHS vector $c = (\Delta (I) - \nabla I u_0) \nabla I)$
    * Solve 2x2 system $u = H\\c$ for each pixel
  * Upsample estimated displacement field to match the resolution of the next level

Several adaptations are made to increase the suitability of FOLKI for PIV:
* 
