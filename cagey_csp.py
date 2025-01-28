# =============================
# Student Names:
# Group ID:
# Date:
# =============================
# CISC 352 - W23
# cagey_csp.py
# desc:
#

#Look for #IMPLEMENT tags in this file.
'''
All models need to return a CSP object, and a list of lists of Variable objects
representing the board. The returned list of lists is used to access the
solution.

For example, after these three lines of code

    csp, var_array = binary_ne_grid(board)
    solver = BT(csp)
    solver.bt_search(prop_FC, var_ord)

var_array is a list of all Variables in the given csp. If you are returning an entire grid's worth of Variables
they should be arranged linearly, where index 0 represents the top left grid cell, index n-1 represents
the top right grid cell, and index (n^2)-1 represents the bottom right grid cell. Any additional Variables you use
should fall after that (i.e., the cage operand variables, if required).

1. binary_ne_grid (worth 0.25/3 marks)
    - A model of a Cagey grid (without cage constraints) built using only
      binary not-equal constraints for both the row and column constraints.

2. nary_ad_grid (worth 0.25/3 marks)
    - A model of a Cagey grid (without cage constraints) built using only n-ary
      all-different constraints for both the row and column constraints.

3. cagey_csp_model (worth 0.5/3 marks)
    - a model of a Cagey grid built using your choice of (1) binary not-equal, or
      (2) n-ary all-different constraints for the grid, together with Cagey cage
      constraints.


Cagey Grids are addressed as follows (top number represents how the grid cells are adressed in grid definition tuple);
(bottom number represents where the cell would fall in the var_array):
+-------+-------+-------+-------+
|  1,1  |  1,2  |  ...  |  1,n  |
|       |       |       |       |
|   0   |   1   |       |  n-1  |
+-------+-------+-------+-------+
|  2,1  |  2,2  |  ...  |  2,n  |
|       |       |       |       |
|   n   |  n+1  |       | 2n-1  |
+-------+-------+-------+-------+
|  ...  |  ...  |  ...  |  ...  |
|       |       |       |       |
|       |       |       |       |
+-------+-------+-------+-------+
|  n,1  |  n,2  |  ...  |  n,n  |
|       |       |       |       |
|n^2-n-1| n^2-n |       | n^2-1 |
+-------+-------+-------+-------+

Boards are given in the following format:
(n, [cages])

n - is the size of the grid,
cages - is a list of tuples defining all cage constraints on a given grid.


each cage has the following structure
(v, [c1, c2, ..., cm], op)

v - the value of the cage.
[c1, c2, ..., cm] - is a list containing the address of each grid-cell which goes into the cage (e.g [(1,2), (1,1)])
op - a flag containing the operation used in the cage (None if unknown)
      - '+' for addition
      - '-' for subtraction
      - '*' for multiplication
      - '/' for division
      - '?' for unknown/no operation given

An example of a 3x3 puzzle would be defined as:
(3, [(3,[(1,1), (2,1)],"+"),(1, [(1,2)], '?'), (8, [(1,3), (2,3), (2,2)], "+"), (3, [(3,1)], '?'), (3, [(3,2), (3,3)], "+")])

'''

from cspbase import *
import itertools


def binary_ne_grid(cagey_grid):
    ##IMPLEMENT
    n, _ = cagey_grid
    variable_array = []
    name = "binary_grid"

    for row in range(n):
        for col in range(n):
            var_name = f"cell {row+1},{col+1}"
            domain = list(range(1, n+1))
            var = Variable(var_name, domain)
            variable_array.append(var)

    csp = CSP(name, variable_array)
    sat_tuples = [(x, y) for x in range(1, n+1) for y in range(1, n+1) if x != y]

    for row in range(n):
        for col1 in range(n):
            for col2 in range(col1+1, n):
                var1 = variable_array[row * n + col1]
                var2 = variable_array[row * n + col2]
                constraint = Constraint(f'Row-{row+1}-{col1+1}-{col2+1}', [var1, var2])
                constraint.add_satisfying_tuples(sat_tuples)
                csp.add_constraint(constraint)

    for col in range(n):
        for row1 in range(n):
            for row2 in range(row1+1, n):
                var1 = variable_array[row1 * n + col]
                var2 = variable_array[row2 * n + col]
                constraint = Constraint(f'Col-{col+1}-{row1+1}-{row2+1}', [var1, var2])
                constraint.add_satisfying_tuples(sat_tuples)
                csp.add_constraint(constraint)

    return csp, variable_array
    

def nary_ad_grid(cagey_grid):
    ## IMPLEMENT
    n, _ = cagey_grid
    variable_array = []
    name = "nary_grid"

    for row in range(n):
        for col in range(n):
            var_name = f"cell {row+1},{col+1}"
            domain = list(range(1, n+1))
            var = Variable(var_name, domain)
            variable_array.append(var)

    csp = CSP(name, variable_array)
    sat_tuples = list(itertools.permutations(range(1, n+1)))

    for row in range(n):
        row_vars = [variable_array[row * n + col] for col in range(n)]
        constraint = Constraint(f'Row-{row+1}', row_vars)
        constraint.add_satisfying_tuples(sat_tuples)
        csp.add_constraint(constraint)

    for col in range(n):
        col_vars = [variable_array[row * n + col] for row in range(n)]
        constraint = Constraint(f'Col-{col+1}', col_vars)
        constraint.add_satisfying_tuples(sat_tuples)
        csp.add_constraint(constraint)

    return csp, variable_array


## Cagery. For 

def cagey_csp_model(cagey_grid):
    """
    Builds a CSP model with:
      (1) n-ary all-different constraints for each row and column,
      (2) cage constraints for each cage, with multi-cell operations
          applied left-to-right in the order of each permutation.

    cagey_grid: (n, cages)
      - n: puzzle dimension
      - cages: list of tuples (target, list_of_cell_coords, operation)
         e.g. (6, [(1,1),(1,2),(1,3)], '+')

    Returns: (csp, var_array)
    """
    n, cages = cagey_grid

    # -------------------------------------------------------
    # 1) Create variables for each cell
    #    We'll name them "Var-Cell(r,c)" with domain [1..n].
    # -------------------------------------------------------
    var_array = []
    for r in range(n):
        for c in range(n):
            name = f"Var-Cell({r+1},{c+1})"
            domain = list(range(1, n+1))
            var = Variable(name, domain)
            var_array.append(var)

    # Create the CSP
    csp = CSP("CageyCSP", var_array)

    # -------------------------------------------------------
    # 2) Row & Column Constraints (n-ary all-different)
    # -------------------------------------------------------
    # For each row, one all-different constraint
    import itertools

    for r in range(n):
        row_vars = [var_array[r*n + col] for col in range(n)]
        con = Constraint(f"Row{r+1}-AllDiff", row_vars)

        # Generate all assignments of length n from domain [1..n],
        # only keep those with distinct values.
        sat_tuples = []
        for assignment in itertools.product(range(1, n+1), repeat=n):
            if len(set(assignment)) == n:
                sat_tuples.append(assignment)

        con.add_satisfying_tuples(sat_tuples)
        csp.add_constraint(con)

    # For each column, one all-different constraint
    for c in range(n):
        col_vars = [var_array[r*n + c] for r in range(n)]
        con = Constraint(f"Col{c+1}-AllDiff", col_vars)

        sat_tuples = []
        for assignment in itertools.product(range(1, n+1), repeat=n):
            if len(set(assignment)) == n:
                sat_tuples.append(assignment)

        con.add_satisfying_tuples(sat_tuples)
        csp.add_constraint(con)

    # -------------------------------------------------------
    # 3) Cage Constraints
    #    Multi-cell logic for +, -, *, / applied left-to-right
    # -------------------------------------------------------
    for (target, cell_coords, op) in cages:
        # The puzzle variables for the cage cells
        cage_vars = []
        for (rr, cc) in cell_coords:
            # Our variables are named "Var-Cell(r,c)"
            name = f"Var-Cell({rr},{cc})"
            for v in var_array:
                if v.name == name:
                    cage_vars.append(v)
                    break

        # Create an operator variable if op can be '?'
        if op == '?':
            op_var = Variable(
                f"Cage_op({target}:{op}:[{', '.join(x.name for x in cage_vars)}])",
                ['+', '-', '*', '/']
            )
        else:
            op_var = Variable(
                f"Cage_op({target}:{op}:[{', '.join(x.name for x in cage_vars)}])",
                [op]
            )

        var_array.append(op_var)
        csp.add_var(op_var)

        # Build a constraint with scope = [op_var] + cage_vars
        scope = [op_var] + cage_vars
        cage_con_name = f"Cage({target}:{op}:[{', '.join(x.name for x in scope)}])"
        cage_con = Constraint(cage_con_name, scope)

        all_valid = []
        domain_vals = list(range(1, n+1))
        # print(domain_vals)
        cage_size = len(cage_vars)

        # Determine which operators to try
        ops_to_try = ['+', '-', '*', '/'] if op == '?' else [op]

        # For each possible operator, for each permutation of domain_vals:
        for operator_choice in ops_to_try:
            # permutations of the domain, length = cage_size
            for combo in itertools.permutations(domain_vals, cage_size):
                # print(combo)
                # Apply operator_choice left-to-right:
                res = combo[0]
                valid_combo = True

                for x in combo[1:]:
                    if operator_choice == '+':
                        res += x
                    elif operator_choice == '-':
                        res -= x
                    elif operator_choice == '*':
                        res *= x
                    elif operator_choice == '/':
                        # Use integer division, "no fraction" => remainder=0
                        if x == 0 or (res % x != 0):
                            valid_combo = False
                            break
                        res //= x
                    else:
                        valid_combo = False
                        break

                    # If still valid, continue; else break

                if valid_combo and res == target:
                    # The constraint expects (op, val1, val2, ...)
                    new_tuple = (operator_choice,) + combo
                    all_valid.append(new_tuple)

        print(all_valid)
        # Add these satisfying tuples to the cage constraint
        cage_con.add_satisfying_tuples(all_valid)
        csp.add_constraint(cage_con)

    return csp, var_array