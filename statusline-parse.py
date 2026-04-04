import sys, json
from datetime import datetime

try:
    data = json.load(sys.stdin)
except:
    data = {}

def get(d, *keys):
    for k in keys:
        if isinstance(d, dict):
            d = d.get(k, {})
        else:
            return ''
    return d if d != {} else ''

def fmt_hhmm(ts):
    try:
        return datetime.fromtimestamp(int(ts)).strftime('%H:%M')
    except:
        return ''

def fmt_full(ts):
    try:
        return datetime.fromtimestamp(int(ts)).strftime('%Y-%m-%d %H:%M')
    except:
        return ''

project_dir   = get(data, 'workspace', 'project_dir') or get(data, 'workspace', 'current_dir') or get(data, 'cwd') or ''
ctx_pct       = get(data, 'context_window', 'used_percentage') or ''
five_pct      = get(data, 'rate_limits', 'five_hour', 'used_percentage') or ''
five_reset_ts = get(data, 'rate_limits', 'five_hour', 'resets_at') or ''
week_pct      = get(data, 'rate_limits', 'seven_day', 'used_percentage') or ''
week_reset_ts = get(data, 'rate_limits', 'seven_day', 'resets_at') or ''

print(project_dir)
print(ctx_pct)
print(five_pct)
print(fmt_hhmm(five_reset_ts))
print(week_pct)
print(fmt_full(week_reset_ts))
