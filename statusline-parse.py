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
    """Ceiling to 1 decimal place; drop decimal if zero."""
    try:
        v = float(val)
        ceiled = math.ceil(v * 10) / 10
        return str(int(ceiled)) if ceiled % 1 == 0 else f'{ceiled:.1f}'
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

# Token counts
total_in       = get(data, 'context_window', 'total_input_tokens') or ''
total_out      = get(data, 'context_window', 'total_output_tokens') or ''
last_in        = get(data, 'context_window', 'current_usage', 'input_tokens') or ''
last_out       = get(data, 'context_window', 'current_usage', 'output_tokens') or ''

def fmt_tok(val):
    """Format token count: show as K if >= 1000."""
    try:
        v = int(val)
        if v >= 1000:
            return f'{v/1000:.1f}K'
        return str(v)
    except:
        return ''

print(project_dir)
print(fmt_pct(ctx_pct) if ctx_pct != '' else '')
print(fmt_pct(five_pct) if five_pct != '' else '')
print(fmt_ts_hhmm(five_reset_ts) if five_reset_ts else '')
print(fmt_pct(week_pct) if week_pct != '' else '')
print(fmt_ts_7d(week_reset_ts) if week_reset_ts else '')
print(fmt_tok(total_in) if total_in != '' else '')
print(fmt_tok(total_out) if total_out != '' else '')
print(fmt_tok(last_in) if last_in != '' else '')
print(fmt_tok(last_out) if last_out != '' else '')
