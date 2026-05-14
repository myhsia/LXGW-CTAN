--[==========================================[--
              L3BUILD FILE FOR LXGW
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module              = "lxgw-fonts"
date                = "2026-06-dd"
version             = "v1.522C"
maintainer          = "Mingyu Xia"
uploader            = "Mingyu Xia"
maintainid          = "myhsia"
email               = "myhsia@outlook.com"
repository          = "https://github.com/" .. maintainid .. "/LXGW-CTAN"
summary             = "CJK font family with a comprehensive character set"
description         = "The `LXGW` Font Family provides an open-source CJK font family with a comprehensive character set for Chinese (Simplified/Traditional), Cantonese, and Japanese. A `fontset` configuration of this font family for the `ctex-kit` is also provided in this package."

--[==========================================[--
                 Pack and Upload
         Do not Modify Unless Necessary
--]==========================================]--

checkengines        = {"xetex", "uptex", "luatex"}
ctanzip             = module
excludefiles        = {"*~"}
installfiles        = {"*.def", "*.tex", "*.spa", "*.ttf", "*.otf"}
sourcefiles         = {"*.dtx", "*.ins", "*.ttf", "*.otf"}
textfiles           = {"README.md", "*.csv", "LICENSE", "*.lua"}
typesetexe          = "latexmk -pdfxe"
typesetruns         = 1
unpacksuppfiles     = {"*.txt"}

uploadconfig  = {
  note              = "",
  announcement_file = "announcement.md",
  pkg               = module,
  version           = version .. " " .. date,
  author            = maintainer,
  uploader          = uploader,
  email             = email,
  summary           = summary,
  description       = description,
  license           = "ofl",
  ctanPath          = "/fonts/" .. module,
  home              = "https://github.com/" .. maintainid,
  bugtracker        = repository .. "/issues",
  support           = "https://github.com/lxgw",
  repository        = repository,
  development       = "https://github.com/" .. maintainid,
  update            = true
}
specialtypesetting  = specialtypesetting or {}
specialtypesetting["lxgw-fonts.tex"] = {cmd = "latexmk -pdflua"}
function update_tag(file, content, tagname, tagdate)
  tagname = version
  tagdate = date
  if string.match(file, "%.dtx$") then
    content = string.gsub(content,
      "\\date{Released " .. "%d+%-%d+%-%d+" ..
      "\\quad \\texttt{" .. "v([%d%.A-Z]+)" .. "}}",
      "\\date{Released " ..     tagdate     ..
      "\\quad \\texttt{" ..     tagname     .. "}}")
    content = string.gsub(content,
      "{%d+%-%d+%-%d+} {v([%d%.A-Z]+)}",
      "{" ..     tagdate     .. "} {" ..    tagname     .. "}")
    content = string.gsub(content,
      "%d+%-%d+%-%d+" .. " " .. "v([%d%.A-Z]+)",
          tagdate     .. " " ..     tagname)
  end
  return content
end

function bundleunpack(sourcedirs, sources)
  -- errorlevel = run(currentdir, "xargs -n 1 curl -O -L < lxgw-fetch.csv")
  -- if errorlevel ~=0 then
  --   return errorlevel
  -- end
  -- errorlevel = run(currentdir, "unzip ZhuqueFangsong-v0.212.zip")
  -- if errorlevel ~=0 then
  --   return errorlevel
  -- end
  -- errorlevel = rm(currentdir, "ZhuqueFangsong-v0.212.zip")
  -- if errorlevel ~=0 then
  --   return errorlevel
  -- end
  -- errorlevel = ren(currentdir, "ZhuqueFangsong-Regular.ttf", "LXGWZhuqueFangsong-Regular.ttf")
  -- if errorlevel ~=0 then
  --   return errorlevel
  -- end
  local errorlevel = mkdir(localdir)
  if errorlevel ~=0 then
    return errorlevel
  end
  errorlevel = cleandir(unpackdir)
  if errorlevel ~=0 then
    return errorlevel
  end
  for _,i in ipairs(sourcedirs or {sourcefiledir}) do
    for _,j in ipairs(sources or {sourcefiles}) do
      for _,k in ipairs(j) do
        errorlevel = cp(k, i, unpackdir)
        if errorlevel ~=0 then
          return errorlevel
        end
      end
    end
  end
  for _,i in ipairs(unpacksuppfiles) do
    errorlevel = cp(i, supportdir, localdir)
    if errorlevel ~=0 then
      return errorlevel
    end
  end
  local popen = io.popen
  for _,i in ipairs(unpackfiles) do
    for _,p in ipairs(tree(unpackdir, i)) do
      local path, name = splitpath(p.src)
      local localdir = abspath(localdir)
      local success = assert(popen(
        "cd " .. unpackdir .. "/" .. path .. os_concat ..
        os_setenv .. " TEXINPUTS=." .. os_pathsep
          .. localdir .. (unpacksearch and os_pathsep or "") ..
        os_concat  ..
        os_setenv .. " LUAINPUTS=." .. os_pathsep
          .. localdir .. (unpacksearch and os_pathsep or "") ..
        os_concat ..
        unpackexe .. " " .. unpackopts .. " " .. name
          .. (options["quiet"] and (" > " .. os_null) or ""),
        "w"
      ):write(string.rep("y\n", 300))):close()
      if not success then
        return 1
      end
    end
  end
  return 0
end

function docinit_hook()
  cp(ctanreadme, unpackdir, currentdir)
  return 0
end

--[== "Hacks" to `l3build` | Do not Modify ==]--

function tex(file,dir,cmd)
  dir = dir or "."
  cmd = cmd or typesetexe
  if os.getenv("WINDIR") ~= nil or os.getenv("COMSPEC") ~= nil then
    upretex_aux = "-usepretex=\"" .. typesetcmds .. "\""
    makeidx_aux = "-e \"$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\""
    sandbox_aux = "set \"TEXINPUTS=../unpacked;%TEXINPUTS%;\" &&"
  else
    upretex_aux = "-usepretex=\'" .. typesetcmds .. "\'"
    makeidx_aux = "-e \'$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\'"
    sandbox_aux = "TEXINPUTS=\"../unpacked:$(kpsewhich -var-value=TEXINPUTS):\""
  end
  return run(dir, sandbox_aux .. " " .. cmd         .. " " ..
                  upretex_aux .. " " .. makeidx_aux .. " " .. file)
end