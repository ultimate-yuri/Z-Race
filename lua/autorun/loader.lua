hg = hg or {}
hg.Version = "Z-Race Edition"
hg.GitHub_ReposOwner = "ultimate-yuri"
hg.GitHub_ReposName = "Z-Race"

	resource.AddWorkshop("3657897364") -- main content addon
	resource.AddWorkshop("3657294321") -- first content addon
	resource.AddWorkshop("3544105055") -- second content addon
	resource.AddWorkshop("3257937532") -- distac content

local sides = {
	["sv_"] = "sv_",
	["sh_"] = "sh_",
	["cl_"] = "cl_",
	["_sv"] = "sv_",
	["_sh"] = "sh_",
	["_cl"] = "cl_",
}

local function AddFile(File, dir)
	local fileSide = string.lower(string.Left(File, 3))
	local fileSide2 = string.lower(string.Right(string.sub(File, 1, -5), 3))
	local side = sides[fileSide] or sides[fileSide2]
	if SERVER and side == "sv_" then
		include(dir .. File)
	elseif side == "sh_" then
		if SERVER then AddCSLuaFile(dir .. File) end
		include(dir .. File)
	elseif side == "cl_" then
		if SERVER then
			AddCSLuaFile(dir .. File)
		else
			include(dir .. File)
		end
	else
		if SERVER then AddCSLuaFile(dir .. File) end
		include(dir .. File)
	end
end

local function IncludeDir(dir)
	dir = dir .. "/"
	local files, directories = file.Find(dir .. "*", "LUA")
	if files then
		for k, v in ipairs(files) do
			if string.EndsWith(v, ".lua") then AddFile(v, dir) end
		end
	end

	if directories then
		for k, v in ipairs(directories) do
			IncludeDir(dir .. v)
		end
	end
end

local function Run()
	print("Loading zrace")
	hg.loaded = false
	IncludeDir("homigrad")
	hg.loaded = true
	print("Loaded zrace")
	hook.Run("HomigradRun")
end

local initpost
hook.Add("InitPostEntity", "zcity", function()
	initpost = true
	IncludeDir("initpost")
	print("Loading initpost...")
end)
Run()
