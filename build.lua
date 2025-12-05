--[==========================================[--
              L3BUILD FILE FOR LXGW
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module              = "lxgw-fonts"
version             = "v1.521F"
date                = "2025-12-06"
maintainer          = "Mingyu Xia"
uploader            = "Mingyu Xia"
maintainid          = "myhsia"
email               = "myhsia@outlook.com"
repository          = "https://github.com/" .. maintainid .. "/LXGW-CTAN"
announcement        = [[]]
summary             = "CJK font family with a comprehensive character set"
description         = "The `LXGW` Font Family provides an open-source CJK font family with a comprehensive character set for Chinese (Simplified/Traditional), Cantonese, and Japanese. A `fontset` configuration of this font family for the `ctex-kit` is also provided in this package."

--[==========================================[--
                 Pack and Upload
         Do not Modify Unless Necessary
--]==========================================]--

ctanzip             = module
excludefiles        = {"*~"}
installfiles        = {"*.def", "*.tex", "*.spa"}
textfiles           = {"*.md", "LICENSE", "*.lua", "*.ttf"}
typesetexe          = "latexmk -xelatex"
typesetruns         = 1
unpacksuppfiles     = {"*.txt"}

uploadconfig  = {
  note         = "",
  pkg          = module,
  version      = version .. " " .. date,
  author       = maintainer,
  uploader     = uploader,
  email        = email,
  summary      = summary,
  description  = description,
  license      = "ofl",
  ctanPath     = "/fonts/" .. module,
  announcement = announcement,
  home         = "https://github.com/" .. maintainid,
  bugtracker   = repository .. "/issues",
  support      = "https://github.com/lxgw",
  repository   = repository,
  development  = "https://github.com/" .. maintainid,
  update       = true
}

--[== "Hacks" to `l3build` | Do not Modify ==]--

function docinit_hook()
  cp("fetch.txt",  maindir, unpackdir)
  run(unpackdir, "wget2 -i fetch.txt")
  run(unpackdir, "unzip LXGWMarkerGothic-v1.003.zip")
  run(unpackdir, "mv ./LXGWMarkerGothic-v1.003/fonts/ttf/*.ttf ./")
  run(unpackdir, "mv ./Xiaolai-Regular.ttf ./LXGWXiaolai-Regular.ttf")
  run(unpackdir, "mv ./Yozai-Regular.ttf ./LXGWYozai-Regular.ttf")
  run(unpackdir, "mv ./Yozai-Medium.ttf ./LXGWYozai-Medium.ttf")
  cp(ctanreadme, unpackdir, currentdir)
  return 0
end
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