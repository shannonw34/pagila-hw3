#!/bin/bash

failed=false

mkdir -p results

for problem in sql/*; do
    problem_id=$(basename "${problem%.sql}")
    result="results/$problem_id.out"
    expected="expected/$problem_id.out"

    echo "Checking $problem..."

    # Execute SQL inside the PostgreSQL container.
    docker compose exec -T pg psql < "$problem" > "$result" 2> "results/$problem_id.err"

    # Compare actual output with expected output.
    DIFF=$(diff -B -u "$expected" "$result")

    if [ -z "$DIFF" ]; then
        echo "$problem pass"
    else
        echo "$problem fail"
        failed=true

        echo "===== EXPECTED OUTPUT ====="
        cat "$expected"

        echo "===== ACTUAL OUTPUT ====="
        cat "$result"

        echo "===== DIFFERENCES ====="
        echo "$DIFF"

        echo "===== END FAILURE DETAILS ====="
        
        echo "===== EXECUTION ERRORS ====="
        cat "results/$problem_id.err"
        echo
    fi
done

if [ "$failed" = "true" ]; then
    exit 2
fi

exit 0
