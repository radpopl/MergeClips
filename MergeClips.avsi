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
#

function MergeClipsV(clip Clip1, clip Clip2, string "resize") {
	resize=default(resize, "Lanczos")
	return Clip1.ExpandToClipV(Clip2, resize)++Clip2.ExpandToClipV(Clip1, resize)
}
function MergeClipsH(clip Clip1, clip Clip2, string "resize") {
	resize=default(resize, "Lanczos")
	return Clip1.ExpandToClipH(Clip2, resize)++Clip2.ExpandToClipH(Clip1, resize)
}

function MergeClipsV(clip_array Clips, string "resize") {
	maxV=Clips[0].Height
	maxVindex=0
	for(i=1, ArraySize(Clips)-1) {	# look for the heighest clip
		if (Clips[i].Height > maxV) {
			maxV = Clips[i].Height
			maxVindex=i
		}
	}
	maxSAR=float(Clips[0].Width)/Clips[0].Height
	maxSARindex=0
	for(i=1, ArraySize(Clips)-1) {	# look for the clip with the highest SAR
		if (float(Clips[i].Width)/Clips[i].Height > maxSAR) {
			maxSAR = float(Clips[i].Width)/Clips[i].Height
			maxSARindex=i
		}
	}
	pat = Clips[maxSARindex].ExpandToClipV(Clips[maxVindex], resize)
	out = Clips[0].ExpandToClipV(pat)
	for(i=1, ArraySize(Clips)-1) {
		out = out ++ (i==maxSARindex ? pat : Clip[i].ExpandToClipV(pat))
	}
	return out
}
function MergeClipsH(clip_array Clips, string "resize") {
	maxH=Clips[0].Width
	maxHindex=0
	for(i=1, ArraySize(Clips)-1) {	# look for the widest clip
		if (Clips[i].Width > maxH) {
			maxH = Clips[i].Width
			maxHindex=i
		}
	}
	minSAR=float(Clips[0].Width)/Clips[0].Height
	minSARindex=0
	for(i=1, ArraySize(Clips)-1) {	# look for the clip with the lowest SAR
		if (float(Clips[i].Width)/Clips[i].Height < minSAR) {
			minSAR = float(Clips[i].Width)/Clips[i].Height
			minSARindex=i
		}
	}
	pat = Clips[minSARindex].ExpandToClipH(Clips[maxHindex])
	out = Clips[0].ExpandToClipH(pat)
	for(i=1, ArraySize(Clips)-1) {
		out = out ++ (i==minSARindex ? pat : Clips[i].ExpandToClipH(pat))
	}
	return out
}


function ExpandToClipV(clip Clip1, clip Clip2, string "resize") {	# expands Clip1 to Clip2 dimensions
	resize=default(resize, "Lanczos")
	if (Clip1.Height < Clip2.Height) {
		newW=round(float(Clip1.Width)/Clip1.Height*Clip2.Height/2)*2 # must be even
		Eval("""Clip1=Clip1."""+resize+"""resize(newW, Clip2.Height)""")
	}
	if (Clip1.Width < Clip2.Width) {
		addleft = int((Clip2.Width-Clip1.Width)/4)*2	# must be even
		Clip1=Clip1.addBorders(addleft, 0, Clip2.Width-Clip1.Width-addleft, 0)
	}
	return Clip1
}

function ExpandToClipH(clip Clip1, clip Clip2, string "resize") {	# expands Clip1 to Clip2 dimensions
	resize=default(resize, "Lanczos")
	if (Clip1.Width < Clip2.Width) {
		newH=round(float(Clip2.Width)/Clip1.Width*Clip1.Height/2)*2 # must be even
		Eval("""Clip1=Clip1."""+resize+"""resize(Clip2.Width, newH)""")
	}
	if (Clip1.Height < Clip2.Height) {
		addtop = int((Clip2.Height-Clip1.Height)/4)*2	# must be even
		Clip1=Clip1.addBorders(0, addtop, 0, Clip2.Height-Clip1.Height-addtop)
	}
	return Clip1
}
