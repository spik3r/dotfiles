return {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  filetypes = { "cs", "vb" },
  root_markers = { "*.sln", "*.csproj", "omnisharp.json", "function.json", ".git" },
}
