--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 1000 -- ms between visualization steps for demonstration purpose

-- Create a viewer
local viewer = View.create()

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

---Function for stitching images from one camera
local function stitchSingle(folder, imageCount)

  -- Create a sequence stitcher and configure it
  local sequence = Image.Stitching.Sequence.create()
  sequence:setShadingCorrection('ON')
  sequence:setOutputScaling(1.0)

  -- Add images
  for i = 1, imageCount do
    -- Load a single image
    local image = Image.load(folder .. tostring(i - 1) .. '.png')

    -- Add single image
    local success = sequence:addImage(image)
    if not success then
      print('Failed to add image ' .. i)
    end
  end

  local stitchedImage = sequence:stitch()
  return stitchedImage
end

---Function for stitching images from multiple sources
local function stitchMultiple(folders, imageCount)
  -- Create a sequence stitcher and configure it
  local sequence = Image.Stitching.Sequence.create()
  sequence:setShadingCorrection('ON')
  sequence:setOutputScaling(0.8)

  -- Add images
  for i = 1, imageCount do

    -- Load a set of images
    local imgs = {}
    for c = 1, #folders do
      imgs[c] = Image.load(folders[c] .. tostring(i - 1) .. '.png')
    end

    -- Add the set of images
    local success = sequence:addImage(imgs)
    if not success then
      print('Failed to add image ' .. i)
    end
  end

  -- Stitch
  local stitchedImage = sequence:stitch()
  return stitchedImage
end

---Main processing
local function main()
  -- Folders with image sequences
  local dataPath = {
    'resources/cam_14340525/',
    'resources/cam_14425986/',
    'resources/cam_14135893/'}

  -- Create stitch from only one camera
  local single = stitchSingle(dataPath[2], 13)
  if single then
    viewer:clear()
    viewer:addImage(single)
    viewer:present('ASSURED')
    print('Showing stitching result from single camera')
  else
    print('Stitching of single sequence failed')
  end
  Script.sleep(DELAY) -- For demonstration purpose only

  -- Create stitch from three cameras
  local multi = stitchMultiple(dataPath, 13)
  if multi then
    viewer:clear()
    viewer:addImage(multi)
    viewer:present('ASSURED')
    print('Showing stitching result from multiple cameras')
  else
    print('Stitching of multi sequence failed')
  end

  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
