new_pod_repository(
  name = "IGListDiffKit",
  url = "https://github.com/instagram/IGListKit/archive/ffd51e6235c761b14c52ac657c69dd52ee7b321f.zip",
  generate_module_map = True,
)

new_pod_repository(
  name = "IGListKit",
  url = "https://github.com/instagram/IGListKit/archive/ffd51e6235c761b14c52ac657c69dd52ee7b321f.zip",
  user_options = ["Core.deps += //Vendor/IGListDiffKit:IGListDiffKit"],
  generate_module_map = True,
)

new_pod_repository(
  name = "IGListSwiftKit",
  url = "https://github.com/instagram/IGListKit/archive/ffd51e6235c761b14c52ac657c69dd52ee7b321f.zip",
  user_options = ["Core.deps += //Vendor/IGListDiffKit:IGListKit"],
  generate_module_map = True,
)

new_pod_repository(
  name = "Texture",
  url = "https://github.com/mttcrsp/Texture/archive/d3f4c227f8b220f8bd5f85c0f0b1673f3947d237.zip",
  user_options = [
    "Core.deps += //Vendor/IGListKit:IGListKit",
    "Core.deps += //Vendor/PINRemoteImage:PINRemoteImage",
  ],
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