# ME 759 Final Project
## GPU acceleration of particle image velocimetry
## Alex Ames
### What’s the idea?
Given an input image pair, determine the velocity vector field using a recursive correlator
#### Algorithm outline
* Read image data (.tif, .png, other uncompressed formats?) from given filepath
* Read metadata (interframe time, pixel spacing) from configuration file
* Normalize/filter/clean image data (on GPU??)
* Send image data to GPU texture memory
* Recursively:
  * Perform correlation (direct or FFT) on padded, overlapping sub-arrays
  * Determine maximum-likelihood velocity field at grid scale
    * Get clean velocity field: wavelet filter with thresholding? Local median filtering? Global outlier removal? Should be flexible.
    * Select allowable secondary/tertiary/… peaks
    * Construct likelier velocity field
  * Compute deformation field and warped image pairs
  * Re-run correlation at grid scale
