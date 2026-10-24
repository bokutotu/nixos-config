#!/usr/bin/env python3
"""Manual X11 keyboard control, installed under three command names."""

import argparse
import os
from pathlib import Path
import re
import subprocess
import sys
from dataclasses import dataclass


@dataclass(frozen=True)
class Keyboard:
    device_id: str
    name: str
    enabled: bool


def run_xinput(*args):
    return subprocess.run(
        ["xinput", *args], check=True, capture_output=True, text=True, timeout=5
    ).stdout


def list_keyboards():
    keyboards = []
    for line in run_xinput("list", "--short").splitlines():
        match = re.search(r"^(.*?)\s+id=(\d+)\s+\[(.*?)\]", line)
        if not match:
            continue
        name, device_id, kind = match.groups()
        if kind == "floating slave":
            # Disabled pointers also float. Only include devices with key events.
            details = run_xinput("list", "--long", device_id)
            if not re.search(r"Type:\s+XIKeyClass\b", details):
                continue
        elif not re.match(r"slave\s+keyboard\b", kind):
            continue
        properties = run_xinput("list-props", device_id)
        enabled = re.search(r"Device Enabled\s+\(\d+\):\s+([01])\s*$", properties, re.M)
        if enabled is None:
            raise ValueError(f"Missing Device Enabled property for {device_id}")
        keyboards.append(Keyboard(device_id, name.lstrip(" ⎡⎜⎣↳∼\t"), enabled[1] == "1"))
    return keyboards


def set_keyboard_enabled(device_id, enabled):
    keyboard = next((k for k in list_keyboards() if k.device_id == device_id), None)
    if keyboard is None:
        raise ValueError(f"Not a keyboard or no longer connected: {device_id}")
    if keyboard.enabled != enabled:
        run_xinput("enable" if enabled else "disable", device_id)


def main(command, argv=None):
    parser = argparse.ArgumentParser(
        prog=command,
        description="List X11 keyboards and their state." if command == "keyboard-ls"
        else "Change one X11 keyboard's state (not persistent across reconnects or sessions).",
    )
    if command != "keyboard-ls":
        parser.add_argument("id", help="numeric keyboard ID from keyboard-ls")
    args = parser.parse_args(argv)
    if command != "keyboard-ls" and not re.fullmatch(r"[0-9]+", args.id):
        parser.error("ID must be numeric; use keyboard-ls to find it")
    if not os.environ.get("DISPLAY"):
        print("ERROR: DISPLAY is not set. Run this inside X11.", file=sys.stderr)
        return 1
    try:
        if command == "keyboard-ls":
            print("ID\tSTATE\tNAME")
            for keyboard in list_keyboards():
                state = "enabled" if keyboard.enabled else "disabled"
                print(f"{keyboard.device_id}\t{state}\t{keyboard.name}")
        else:
            set_keyboard_enabled(args.id, command == "keyboard-enable")
    except (OSError, subprocess.SubprocessError, ValueError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(Path(sys.argv[0]).name))
