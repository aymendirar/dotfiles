-- C/C++ Language Server configuration
return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
}
