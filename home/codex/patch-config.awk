function emit(line) {
  print line
  output_lines++
  last_line_blank = line ~ /^[[:space:]]*$/
}

function leave_keymap_section() {
  in_tui = 0
  in_chat_keymap = 0
  in_composer_keymap = 0
  in_editor_keymap = 0
}

function append_keymap_section(header, binding) {
  if (output_lines > 0 && !last_line_blank) emit("")
  emit(header)
  emit(binding)
}

BEGIN {
  animations_line = "animations = false"
  show_tooltips_line = "show_tooltips = false"
  decrease_reasoning_line = "decrease_reasoning_effort = [\"ctrl-up\"]"
  increase_reasoning_line = "increase_reasoning_effort = [\"ctrl-down\"]"
  submit_line = "submit = [\"ctrl-enter\"]"
  insert_newline_line = "insert_newline = [\"enter\"]"
  in_chat_keymap = 0
  found_chat_keymap = 0
  in_composer_keymap = 0
  found_composer_keymap = 0
  in_editor_keymap = 0
  found_editor_keymap = 0
  output_lines = 0
  last_line_blank = 0
}

/^[[:space:]]*\[tui\][[:space:]]*(#.*)?$/ {
  leave_keymap_section()
  emit($0)
  emit(animations_line)
  emit(show_tooltips_line)
  in_tui = 1
  found_tui = 1
  next
}

/^[[:space:]]*\[tui\.keymap\.chat\][[:space:]]*(#.*)?$/ {
  leave_keymap_section()
  emit($0)
  emit(decrease_reasoning_line)
  emit(increase_reasoning_line)
  in_chat_keymap = 1
  found_chat_keymap = 1
  next
}

/^[[:space:]]*\[tui\.keymap\.composer\][[:space:]]*(#.*)?$/ {
  leave_keymap_section()
  emit($0)
  emit(submit_line)
  in_composer_keymap = 1
  found_composer_keymap = 1
  next
}

/^[[:space:]]*\[tui\.keymap\.editor\][[:space:]]*(#.*)?$/ {
  leave_keymap_section()
  emit($0)
  emit(insert_newline_line)
  in_editor_keymap = 1
  found_editor_keymap = 1
  next
}

/^[[:space:]]*\[/ {
  leave_keymap_section()
  emit($0)
  next
}

in_tui && /^[[:space:]]*(animations|show_tooltips)[[:space:]]*=/ {
  next
}

in_chat_keymap && /^[[:space:]]*(decrease_reasoning_effort|increase_reasoning_effort)[[:space:]]*=/ {
  next
}

in_composer_keymap && /^[[:space:]]*submit[[:space:]]*=/ {
  next
}

in_editor_keymap && /^[[:space:]]*insert_newline[[:space:]]*=/ {
  next
}

{
  emit($0)
}

END {
  if (!found_tui) {
    append_keymap_section("[tui]", animations_line)
    emit(show_tooltips_line)
  }
  if (!found_chat_keymap) {
    append_keymap_section("[tui.keymap.chat]", decrease_reasoning_line)
    emit(increase_reasoning_line)
  }
  if (!found_composer_keymap) {
    append_keymap_section("[tui.keymap.composer]", submit_line)
  }
  if (!found_editor_keymap) {
    append_keymap_section("[tui.keymap.editor]", insert_newline_line)
  }
}
