# -------------------------------------------------------------------------------------------------------
# Concatenating clips of different resolutions by enlarging smaller ones and optionally adding black bars
# -------------------------------------------------------------------------------------------------------
#
# MergeClipsV (clip Clip1, clip Clip2, string resize="Lanczos")
# MergeClipsV (clip_array Clips, string resize="Lanczos")
# - Returns a clip that is a concatenation of proportionally enlarged clips whose height is equal to the height of the HIGHEST clip. Black bars are added to the sides of individual clips if necessary. The "resize" parameter defines the upscaling method.
#
# MergeClipsH (clip Clip1, clip Clip2, string resize="Lanczos")
# MergeClipsH (clip_array Clips, string resize="Lanczos")
# - Returns a clip that is a concatenation of proportionally enlarged clips whose width is equal to the width of the WIDEST clip. Black bars at the bottom and top are added to individual clips if necessary. The "resize" parameter defines the upscaling method.
#
# Notice:
# - the format of all clips must be the same except for width and height
# - I suggest converting to YUV444 or RGB before calling the function, and converting the final clip back to the target format (for better resize quality)
#
# (v1.0)
