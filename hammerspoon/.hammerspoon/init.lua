-- Keep text history in memory only; never write clipboard contents to disk.
local latest = hs.pasteboard.getContents()
local previous
local changeCount = hs.pasteboard.changeCount()

local function captureClipboard()
  local count = hs.pasteboard.changeCount()
  if count == changeCount then
    return
  end
  changeCount = count
  local text = hs.pasteboard.getContents()
  if text ~= nil then
    previous, latest = latest, text
  end
end

-- Retain the timer and hotkey so garbage collection cannot disable them.
clipboardHistory = {
  timer = hs.timer.doEvery(0.1, captureClipboard),
  hotkey = hs.hotkey.bind({ "ctrl" }, "v", function()
    -- Include a copy made since the most recent timer tick.
    captureClipboard()
    if previous == nil then
      hs.alert.show("No previous clipboard text yet")
      return
    end
    -- Emit text directly so Cmd-V keeps the original clipboard and its formats.
    hs.eventtap.keyStrokes(previous)
  end),
}
