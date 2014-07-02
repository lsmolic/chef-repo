# Name of the role should match the name of the file
name "development"

# Run list function we mentioned earlier
run_list(
    "recipe[php]"
)
