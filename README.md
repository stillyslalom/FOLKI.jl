# FOLKI
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
    * Compute deformed image intensity from prior displacement estimate u₀
    * Compute RHS vector c = (ΔI - ∇I u₀) ∇I
    * Solve 2x2 system u = H\\c for each pixel
  * Upsample estimated displacement field to match the resolution of the next level

### How is it run?
A working Julia installation is required: download the latest release for your
platform [here](https://julialang.org/downloads/).
If you'd rather not install anything, you can register for a
[JuliaBox account](https://www.juliabox.com),
which gives you free access to a remotely-managed Julia environment.

Several additional packages must also be installed; this is done by entering
the Julia command-line and typing `Pkg.add("packagename")`. To be sure everything
has been installed correctly, type `versioninfo(true)` in the Julia prompt.
The required packages are:

* Images
* ImageView
* Interpolations
* Plots
* Glob

Once the environment is properly configured, the code can be run by navigating
to the `scratch/` directory and running `include("repl.jl")`
from the Julia prompt.
