$ cat > ~/ralph.sh <<'EOF'
#!/bin/bash

# In order for the script to have access to the `committe` function,
# we need to initialize dic here.
eval "$(dic --init)" 2>/dev/null || exit 1

# Move to the Pagila project
cd ~/pagila-hw3 || exit 1

# the loop is below
for i in $(seq 0 99); do
    echo '----------------------------------------'
    echo "ralph loop i=$i"
    echo '----------------------------------------'
    if ./test.sh > /tmp/out 2>&1; then
        cat /tmp/out
        echo "tests pass after $i rounds"
        exit 0
    fi

    # Give Deepseek the questions, database schema, and test failures
    committe "$@" <<EOF2

You are a coding agent solving the Pagila SQL assignments

===== SQL QUESTIONS =======

$(files-to-prompt sql)

===== DATABASE SCHEMA =====
$(docker compose exec -T pg psql -c '\d+ *')

docker compose exec -T pg psql -Atc "
SELECT
    table_name || ': ' ||
    string_agg(column_name || ' ' || data_type, ', ' ORDER BY ordinal_position)
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name
ORDER BY table_name;
"

===== TEST FAILURES =======

$(cat /tmp/out)

Fix the failing SQL assignments.

Instructions:
- Inspect the existing SQL files before modifying them.
- Use the actual database schema.
- Do not modify expected outputs or test files.
- Solve the questions incrementally.
- Run the tests after making changes.
- Do not claim success unless the tests pass.
EOF2


done

EOF

chmod +x ~/ralph.sh
