
m4_define([[m4_inline_verbatum_mode]],
m4_sed[[ -e 's/^\(.\+\)$/`\  \1`\\/;:a;s/^\(\\ \)*` /\1\\ `/;ta;s/``//']])

m4_define([[m4_run]],
[[ps1*$**\
m4_syscmd([[cd]] working_dir;[[$*]] 2>&1| m4_inline_verbatum_mode
)]])
