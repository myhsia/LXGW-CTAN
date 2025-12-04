--[==========================================[--
              L3BUILD FILE FOR LXGW
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module              = "lxgw-fonts"
version             = "v1.521F"
date                = "2025-12-05"
maintainer          = "Mingyu Xia"
uploader            = "Mingyu Xia"
maintainid          = "myhsia"
email               = "myhsia@outlook.com"
repository          = "https://github.com/" .. maintainid .. "/LXGW-CTAN"
announcement        = [[Version 1.512F released.
- Change the `cmap` to from `UniGB-UTF16-H` to `unicode` for pdfTeX and upTeX
- Changed `zhmappdf`.]]
summary             = "An unprofessional open-source Chinese font family"
description         = "The LXGW Font Family provides an unprofessional open-source Chinese font family."

--[==========================================[--
                 Pack and Upload
         Do not Modify Unless Necessary
--]==========================================]--

ctanzip             = module
excludefiles        = {"*~"}
docfiles            = {"ctex-fontset-lxgw.def", "ctex-zhmap-lxgw.tex"}
textfiles           = {"*.md", "LICENSE", "*.lua", "*.ttf"}
typesetfiles        = {"LXGW-demo.tex"}
typesetexe          = "latexmk -xelatex"
typesetruns         = 1
unpacksuppfiles     = {"*.txt"}

uploadconfig  = {
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