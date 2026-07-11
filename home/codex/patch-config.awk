function emit(line) {
  print line
  output_lines++
  last_line_blank = line ~ /^[[:space:]]*$/
}

function finish_root() {
  if (!in_root) return
  if (!found_model_instructions) emit(model_instructions_line)
  in_root = 0
}

function leave_keymap_section() {
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
  model_instructions_line = "model_instructions_file = \"~/.codex/custom_instructions.md\""
  decrease_reasoning_line = "decrease_reasoning_effort = [\"ctrl-up\"]"
  increase_reasoning_line = "increase_reasoning_effort = [\"ctrl-down\"]"
  submit_line = "submit = [\"ctrl-enter\"]"
  insert_newline_line = "insert_newline = [\"enter\"]"
  in_root = 1
  found_model_instructions = 0
  in_chat_keymap = 0
  found_chat_keymap = 0
  in_composer_keymap = 0
  found_composer_keymap = 0
  in_editor_keymap = 0
  found_editor_keymap = 0
  output_lines = 0
  last_line_blank = 0
}

in_root && /^[[:space:]]*model_instructions_file[[:space:]]*=/ {
  found_model_instructions = 1
  emit($0)
  next
}

/^[[:space:]]*\[tui\.keymap\.chat\][[:space:]]*(#.*)?$/ {
  finish_root()
  leave_keymap_section()
  emit($0)
  emit(decrease_reasoning_line)
  emit(increase_reasoning_line)
  in_chat_keymap = 1
  found_chat_keymap = 1
  next
}

/^[[:space:]]*\[tui\.keymap\.composer\][[:space:]]*(#.*)?$/ {
  finish_root()
  leave_keymap_section()
  emit($0)
  emit(submit_line)
  in_composer_keymap = 1
  found_composer_keymap = 1
  next
}

/^[[:space:]]*\[tui\.keymap\.editor\][[:space:]]*(#.*)?$/ {
  finish_root()
  leave_keymap_section()
  emit($0)
  emit(insert_newline_line)
  in_editor_keymap = 1
  found_editor_keymap = 1
  next
}

/^[[:space:]]*\[/ {
  finish_root()
  leave_keymap_section()
  emit($0)
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
  finish_root()
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
