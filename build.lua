--[==========================================[--
              L3BUILD FILE FOR LXGW
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module              = "lxgw-fonts"
version             = "v1.521L"
date                = "2026-01-15"
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

ctanzip             = module
excludefiles        = {"*~"}
installfiles        = {"*.def", "*.tex", "*.spa"}
textfiles           = {"README.md", "LICENSE", "*.lua", "*.ttf"}
typesetexe          = "latexmk -xelatex"
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
  announcement      = announcement,
  home              = "https://github.com/" .. maintainid,
  bugtracker        = repository .. "/issues",
  support           = "https://github.com/lxgw",
  repository        = repository,
  development       = "https://github.com/" .. maintainid,
  update            = true
}
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
function docinit_hook()
  cp("fetch.txt",  maindir, unpackdir)
  run(unpackdir, "xargs -n 1 curl -O -L < fetch.txt")
  ren(unpackdir, "Xiaolai-Regular.ttf",        "LXGWXiaolai-Regular.ttf")
  run(unpackdir, "unzip ZhuqueFangsong-v0.212.zip")
  ren(unpackdir, "ZhuqueFangsong-Regular.ttf", "LXGWZhuqueFangsong-Regular.ttf")
  ren(unpackdir, "Yozai-Regular.ttf",          "LXGWYozai-Regular.ttf")
  ren(unpackdir, "Yozai-Medium.ttf",           "LXGWYozai-Medium.ttf")
  run(unpackdir, "xetex ctexpunct-lxgw.tex")
  cp("*.ttf", unpackdir, typesetdir)
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