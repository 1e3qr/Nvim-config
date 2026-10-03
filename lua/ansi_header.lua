-- Parses ascii-image-converter -C output (raw ANSI 24-bit color codes)
-- into an alpha.nvim plain-text header, then applies the original colors
-- as buffer highlights after alpha renders (since alpha's "group" type
-- stacks child elements as separate lines rather than laying them out
-- horizontally, so per-character coloring has to be done post-render).

local M = {}

local ns = vim.api.nvim_create_namespace("ansi_header")

local hl_cache = {}
local hl_counter = 0

local function get_hl_group(r, g, b)
  local key = string.format("%d_%d_%d", r, g, b)
  if hl_cache[key] then
    return hl_cache[key]
  end
  hl_counter = hl_counter + 1
  local name = "AsciiTree" .. hl_counter
  vim.api.nvim_set_hl(0, name, { fg = string.format("#%02x%02x%02x", r, g, b) })
  hl_cache[key] = name
  return name
end

-- Parses one raw ANSI line into its plain text plus a list of
-- {start_col, end_col, hl} byte-offset segments (0-indexed, end exclusive).
local function parse_line(line)
  local plain_parts = {}
  local segments = {}
  local col = 0
  local cur_start, cur_hl = nil, nil

  for r, g, b, ch in line:gmatch("\27%[38;2;(%d+);(%d+);(%d+)m([^\27]*)\27%[0m") do
    local hl = get_hl_group(tonumber(r), tonumber(g), tonumber(b))
    table.insert(plain_parts, ch)

    if hl ~= cur_hl then
      if cur_hl then
        table.insert(segments, { start_col = cur_start, end_col = col, hl = cur_hl })
      end
      cur_start, cur_hl = col, hl
    end
    col = col + #ch
  end
  if cur_hl then
    table.insert(segments, { start_col = cur_start, end_col = col, hl = cur_hl })
  end

  return table.concat(plain_parts), segments
end

-- Cache of parsed rows, kept so apply_highlights() can use them after
-- alpha has drawn the buffer.
M._rows = {}

-- Returns an alpha.nvim-compatible header: a plain "text" section.
-- Colors are NOT applied yet -- call M.apply_highlights(bufnr) once
-- the alpha buffer has actually been rendered (e.g. on the AlphaReady
-- User autocmd).
function M.build_header(filepath)
  local lines = vim.fn.readfile(filepath)
  local header_val = {}
  M._rows = {}

  for _, line in ipairs(lines) do
    local text, segments = parse_line(line)
    table.insert(header_val, text)
    table.insert(M._rows, { text = text, segments = segments })
  end

  return {
    type = "text",
    val = header_val,
    opts = { position = "center", hl = "AlphaHeader" },
  }
end

-- Applies the cached per-character highlights to the given buffer
-- (defaults to the current buffer). Call this after alpha has rendered,
-- e.g. via the "AlphaReady" User autocmd.
function M.apply_highlights(bufnr)
  bufnr = bufnr or 0
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for _, row in ipairs(M._rows) do
    if row.text ~= "" then
      for i, bufline in ipairs(buf_lines) do
        local found = bufline:find(row.text, 1, true)
        if found then
          local offset = found - 1
          for _, seg in ipairs(row.segments) do
            vim.api.nvim_buf_add_highlight(
              bufnr, ns, seg.hl,
              i - 1,
              offset + seg.start_col,
              offset + seg.end_col
            )
          end
          break
        end
      end
    end
  end
end

return M
