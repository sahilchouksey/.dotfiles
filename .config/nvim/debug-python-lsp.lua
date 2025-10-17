-- Debug script to check Python LSP configuration
-- Run this in Neovim with :luafile ~/.config/nvim/debug-python-lsp.lua

print("=== Python LSP Debug Information ===")

-- Check if pyright is available
local pyright_path = vim.fn.exepath("pyright-langserver")
print("Pyright LSP server path: " .. (pyright_path ~= "" and pyright_path or "NOT FOUND"))

-- Check Mason installation
local mason_pyright = vim.fn.expand("~/.local/share/nvim/mason/bin/pyright-langserver")
print("Mason pyright path: " .. (vim.fn.executable(mason_pyright) == 1 and mason_pyright or "NOT FOUND"))

-- Check current Python path
local python_path = vim.fn.exepath("python")
print("Current Python path: " .. python_path)

-- Check virtual environment
local venv = os.getenv("VIRTUAL_ENV")
print("VIRTUAL_ENV: " .. (venv or "NOT SET"))

-- Check if we're in a Python project
local cwd = vim.fn.getcwd()
local python_files = vim.fn.glob(cwd .. "/*.py", false, true)
print("Python files in current directory: " .. #python_files)

-- Check LSP clients for current buffer
local clients = vim.lsp.get_active_clients()
print("\nActive LSP clients:")
for _, client in ipairs(clients) do
    print("  - " .. client.name .. " (ID: " .. client.id .. ")")
end

-- Check if in a Python buffer
local filetype = vim.bo.filetype
print("\nCurrent filetype: " .. filetype)

if filetype == "python" then
    local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
    print("LSP clients for current Python buffer:")
    for _, client in ipairs(buf_clients) do
        print("  - " .. client.name)
    end
else
    print("Open a Python file and run this script again to see buffer-specific info")
end

print("\n=== End Debug Information ===")