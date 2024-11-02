import re
import sys

def fill_extras(filepath):
    # Read the file content
    with open(filepath, 'r') as file:
        lines = file.readlines()
    
    # Regex pattern to match each `case` line in the switch statement
    case_pattern = re.compile(r'\s*case\s+0x[0-9A-Fa-f]+:')
    
    # Extra fields to ensure are set
    extras = ['extra1', 'extra2', 'extra3']
    
    # Track whether we're inside a case block
    inside_case = False
    current_case_lines = []
    output_lines = []
    
    # Loop through lines and process each `case` block
    for line in lines:
        if case_pattern.match(line):
            # If inside a case block, finalize the previous block
            if inside_case:
                for extra in extras:
                    if not any(extra in l for l in current_case_lines):
                        current_case_lines.insert(-1, f'      controlOut->{extra} = 0;\n')
                output_lines.extend(current_case_lines)
            
            # Start a new case block
            inside_case = True
            current_case_lines = [line]
        elif inside_case:
            current_case_lines.append(line)
            # Detect end of case block (return statement)
            if 'return' in line:
                for extra in extras:
                    if not any(extra in l for l in current_case_lines):
                        current_case_lines.insert(-1, f'      controlOut->{extra} = 0;\n')
                output_lines.extend(current_case_lines)
                inside_case = False
        else:
            output_lines.append(line)
    
    # Handle the last case if it was open
    if inside_case:
        for extra in extras:
            if not any(extra in l for l in current_case_lines):
                current_case_lines.insert(-1, f'      controlOut->{extra} = 0;\n')
        output_lines.extend(current_case_lines)
    
    # Write the modified content back to the file
    with open(filepath, 'w') as file:
        file.writelines(output_lines)
    print(f"Updated file '{filepath}' successfully.")

# Main entry point
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python fill_extras.py <filepath>")
    else:
        fill_extras(sys.argv[1])
