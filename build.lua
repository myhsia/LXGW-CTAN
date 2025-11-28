--[==========================================[--
              L3BUILD FILE FOR LXGW
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module              = "lxgw"
version             = "v1.521"
date                = "2025-11-28"
maintainer          = "Mingyu Xia"
uploader            = "Mingyu Xia"
maintainid          = "myhsia"
email               = "myhsia@outlook.com"
repository          = "https://github.com/" .. maintainid .. "/" .. module .. "-ctan"
announcement        = [[New font family on CTAN.
The LXGW Font Family provides an unprofessional open-source Chinese font family.
]]
summary             = "An unprofessional open-source Chinese font family"
description         = "The LXGW Font Family provides an unprofessional open-source Chinese font family."

--[==========================================[--
                 Pack and Upload
         Do not Modify Unless Necessary
--]==========================================]--

ctanzip             = module
excludefiles        = {"*~"}
textfiles           = {"*.md", "LICENSE", "*.lua", "*.ttf"}
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
  support      = repository .. "/issues",
  repository   = repository,
  development  = "https://github.com/" .. maintainid,
  update       = false
}

function docinit_hook()
  cp("fetch.txt",  maindir, unpackdir)
  run(unpackdir, "wget -i fetch.txt")
  run(unpackdir, "unzip LxgwMarkerGothic-v1.003.zip")
  run(unpackdir, "mv ./LxgwMarkerGothic-v1.003/fonts/ttf/*.ttf ./")
  return 0
end