import sys, json, math
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

def fmt_pct(val):
    """Ceiling to 1 decimal place (無條件進位)."""
    try:
        v = float(val)
        ceiled = math.ceil(v * 10) / 10
        return f'{ceiled:.1f}'
    except:
        return ''

def fmt_ts_hhmm(ts):
    try:
        return datetime.fromtimestamp(int(ts)).strftime('%H:%M')
    except:
        return ''

def fmt_ts_7d(ts):
    try:
        dt = datetime.fromtimestamp(int(ts))
        return dt.strftime('%m-%d %H:%M %a').upper()
    except:
        return ''

project_dir    = get(data, 'workspace', 'project_dir') or get(data, 'workspace', 'current_dir') or get(data, 'cwd') or ''
ctx_pct        = get(data, 'context_window', 'used_percentage') or ''
five_pct       = get(data, 'rate_limits', 'five_hour', 'used_percentage') or ''
five_reset_ts  = get(data, 'rate_limits', 'five_hour', 'resets_at') or ''
week_pct       = get(data, 'rate_limits', 'seven_day', 'used_percentage') or ''
week_reset_ts  = get(data, 'rate_limits', 'seven_day', 'resets_at') or ''

print(project_dir)
print(fmt_pct(ctx_pct) if ctx_pct != '' else '')
print(fmt_pct(five_pct) if five_pct != '' else '')
print(fmt_ts_hhmm(five_reset_ts) if five_reset_ts else '')
print(fmt_pct(week_pct) if week_pct != '' else '')
print(fmt_ts_7d(week_reset_ts) if week_reset_ts else '')
