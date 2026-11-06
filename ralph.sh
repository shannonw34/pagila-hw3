
#!/bin/bash

set -u

PROJECT="$HOME/pagila-hw3"
cd "$PROJECT" || exit 1

source "$HOME/dic-venv/bin/activate" || exit 1
source "$HOME/dic-venv/lib/python3.12/site-packages/dic/scripts/dic.sh" -f || exit 1

export DIC_MODEL=openrouter+deepseek

docker compose up -d || exit 1

for i in $(seq 1 100); do
    echo '----------------------------------------'
    echo "Ralph loop iteration $i"
    echo '----------------------------------------'

    if ./run_tests.sh > /tmp/out 2>&1; then
        cat /tmp/out
        echo "All tests pass after $i iterations!"
        exit 0
    fi

    FAILED_SQL=$(awk '$NF == "fail" {print $1; exit}' /tmp/out)

    if [ -z "$FAILED_SQL" ] || [ ! -f "$FAILED_SQL" ]; then
        echo "Could not identify a failing SQL file."
        cat /tmp/out
        exit 1
    fi

    PROBLEM_ID=$(basename "$FAILED_SQL" .sql)
    EXPECTED="expected/$PROBLEM_ID.out"

    BEFORE=$(git rev-parse HEAD)

    echo "Working on $FAILED_SQL..."

    DIC_SESSION="pagila-hw3-$i" committe <<EOF_PROMPT
You are solving one Pagila HW3 SQL assignment.

Modify ONLY this file: $FAILED_SQL

===== SQL QUESTION =====
$(cat "$FAILED_SQL")

===== DATABASE SCHEMA =====
$(docker compose exec -T pg psql -Atc "
SELECT table_name || ': ' ||
       string_agg(column_name || ' ' || data_type, ', ' ORDER BY ordinal_position)
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name
ORDER BY table_name;
")

===== EXPECTED OUTPUT =====
$(if [ -f "$EXPECTED" ]; then cat "$EXPECTED"; else echo "No expected output file."; fi)

===== TEST FAILURES =====
$(cat /tmp/out)

Instructions:
- Use actual table names and relationships.
- Match expected columns, values, and ordering.
- Do not hardcode expected results.
- Preserve existing SQL comments.
- Do not modify tests, expected outputs, or other SQL files.
- Return a valid unified Git diff only.
EOF_PROMPT

    AFTER=$(git rev-parse HEAD)

    if [ "$BEFORE" = "$AFTER" ]; then
        echo "No new commit was made. Stopping."
        exit 1
    fi

    git log -1 --oneline
done

echo "Reached 100 iterations."
exit 1

