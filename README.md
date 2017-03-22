# Image-enhancement-using-negative-processing
Enhancement uses gamute correction of image by transforming to HSI and CMY color space


Normal (i.e., positive) image processing performed in
RGB color space, the negative image processing is considered
as performed in CMY color space. The negative intensity is
defined in CMY color space. The normal intensity range which
is larger than middle value corresponds to the negative
intensity range which is until middle value. Therefore, the
common area of the gamut of CMY and HSI color spaces is
large from the middle value of normal intensity. Then, if the
output intensity value until middle, we choose the positive
image processing result as the final result of our processing
scheme. On the other hand, if the output intensity value larger
than middle, the result of negative image processing is chosen
as the final result. Due to that, we can almost avoid the gamut
problem.

![preview result](https://cloud.githubusercontent.com/assets/26468136/24198675/1b146e58-0e9a-11e7-884d-46e3dbb2d704.png)
