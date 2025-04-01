screenshotName="$(date +%Y%m%d_%H%m%s)"
screenshotDir="$HOME/myHome/Pictures/Screenshots"

hyprctl keyword animation "fadeOut, 0, 0, default"

grimblast --freeze save area "${screenshotDir}/$screenshotName.png" 

swappy -f "${screenshotDir}/$screenshotName.png" -o "${screenshotDir}/$screenshotName-Swappy.png"

hyprctl keyword animation "fadeOut, 1, 4, default"


# WITHOUT SWAPPY
# screenshotName="$(date +%Y%m%d_%H%m%s)"
  
# hyprctl keyword animation "fadeOut, 0, 0, default"

# grimblast --freeze copysave area "${screenshotDir}/$screenshotName.png"

# hyprctl keyword animation "fadeOut, 1, 4, default"