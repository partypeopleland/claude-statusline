"""
Update ~/.claude/settings.json to enable the statusline.
Usage: python setup-settings.py <install_dir> <settings_file>
"""
import sys, json, os

install_dir   = sys.argv[1]
settings_file = sys.argv[2]

command = "bash {}/statusline.sh".format(install_dir)

if os.path.exists(settings_file):
    with open(settings_file, 'r') as f:
        try:
            settings = json.load(f)
        except Exception:
            settings = {}
else:
    settings = {}

settings['statusLine'] = {
    'type': 'command',
    'command': command
}

os.makedirs(os.path.dirname(os.path.abspath(settings_file)), exist_ok=True)
with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')

print("Updated: {}".format(settings_file))
print("Command: {}".format(command))
