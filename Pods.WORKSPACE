new_pod_repository(
  name = "IGListDiffKit",
  url = "https://github.com/instagram/IGListKit/archive/aca18c747009c5d2c3825cf0af1ea1d214afba0c.zip",
  generate_module_map = True,
)

new_pod_repository(
  name = "IGListKit",
  url = "https://github.com/instagram/IGListKit/archive/aca18c747009c5d2c3825cf0af1ea1d214afba0c.zip",
  user_options = ["Core.deps += //Vendor/IGListDiffKit:IGListDiffKit"],
  generate_module_map = True,
)

new_pod_repository(
  name = "IGListSwiftKit",
  url = "https://github.com/instagram/IGListKit/archive/25d1887a41f2c849f96c2a198064fe4418791843.zip",
  user_options = ["Core.deps += //Vendor/IGListDiffKit:IGListKit"],
  generate_module_map = True,
)

new_pod_repository(
  name = "Texture",
  url = "https://github.com/TextureGroup/Texture/archive/923901a1cebf0b6c51627aca2a6748dee84af143.zip",
  user_options = ["Core.deps += //Vendor/IGListKit:IGListKit"],
  inhibit_warnings = True,
  generate_module_map = True,
)

new_pod_repository(
  name = "PINRemoteImage",
  url = "https://github.com/pinterest/PINRemoteImage/archive/3.0.3.zip",
  user_options = ["Core.deps += //Vendor/PINCache:PINCache"],
)

new_pod_repository(
  name = "PINOperation",
  url = "https://github.com/pinterest/PINOperation/archive/1.2.2.zip",
)

new_pod_repository(
  name = "PINCache",
  url = "https://github.com/pinterest/PINCache/archive/3.0.3.zip",
)