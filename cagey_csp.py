# =============================
# Student Names: Ben Kwan, Kanice Leung, Max Hao
# Group ID: (A1) 20
# Date: Jan. 30, 2025
# =============================
# CISC 352 - W25
# cagey_csp.py

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
    var_array = []
    csp_name = "binary_grid"
    domain = list(range(1, n+1))

    for row in range(n):
        for col in range(n):
            var_name = f"Cell ({row+1},{col+1})"
            var = Variable(var_name, domain)
            var_array.append(var)

    csp = CSP(csp_name, var_array)
    sat_tuples = [(x, y) for x in range(1, n+1) for y in range(1, n+1) if x != y]

    for row in range(n):
        for col1 in range(n):
            for col2 in range(col1+1, n):
                var1 = var_array[row * n + col1]
                var2 = var_array[row * n + col2]
                constraint = Constraint(f'Row-{row+1}-{col1+1}-{col2+1}', [var1, var2])
                constraint.add_satisfying_tuples(sat_tuples)
                csp.add_constraint(constraint)

    for col in range(n):
        for row1 in range(n):
            for row2 in range(row1+1, n):
                var1 = var_array[row1 * n + col]
                var2 = var_array[row2 * n + col]
                constraint = Constraint(f'Col-{col+1}-{row1+1}-{row2+1}', [var1, var2])
                constraint.add_satisfying_tuples(sat_tuples)
                csp.add_constraint(constraint)

    return csp, var_array

def nary_ad_grid(cagey_grid):
    ## IMPLEMENT
    n, _ = cagey_grid
    var_array = []
    csp_name = "nary_grid"
    domain = list(range(1, n+1))

    for row in range(n):
        for col in range(n):
            var_name = f"Cell ({row+1},{col+1})"
            var = Variable(var_name, domain)
            var_array.append(var)

    csp = CSP(csp_name, var_array)
    sat_tuples = list(itertools.permutations(range(1, n+1)))

    for row in range(n):
        row_vars = [var_array[row * n + col] for col in range(n)]
        constraint = Constraint(f'Row-{row+1}', row_vars)
        constraint.add_satisfying_tuples(sat_tuples)
        csp.add_constraint(constraint)

    for col in range(n):
        col_vars = [var_array[row * n + col] for row in range(n)]
        constraint = Constraint(f'Col-{col+1}', col_vars)
        constraint.add_satisfying_tuples(sat_tuples)
        csp.add_constraint(constraint)

    return csp, var_array

def cagey_csp_model(cagey_grid):
    """
    Builds a CSP with only cage constraints (no row/column constraints).
    Ensures operator var is first in scope with a non-empty string domain,
    and generates correct sat_tuples for '+' cages.

    cagey_grid: (n, cages)
      - n: puzzle dimension
      - cages: list of (target, [(r,c), (r,c), ...], operation)
               e.g. (4, [(1,1),(1,2),(2,1),(2,2)], '+') for a 2x2 puzzle

    Returns: (csp, var_array)
      - csp: The CSP object with cage constraints
      - var_array: The list of all Variables (cell vars + operator vars)
    """
    n, cages = cagey_grid
    csp_name = "CageyCSP_OnlyCages"
    domain = list(range(1, n+1))

    # -------------------------------------------------------
    # 1) Create Variables for each cell
    # -------------------------------------------------------
    var_array = []
    for r in range(n):
        for c in range(n):
            # Each cell has domain [1..n]
            var_name = f"Var-Cell({r+1},{c+1})"
            cell_var = Variable(var_name, domain)
            var_array.append(cell_var)

    # Create the CSP
    csp = CSP(csp_name, var_array)

    # -------------------------------------------------------
    # 2) For each cage, create an operator variable + cage constraint
    # -------------------------------------------------------
    for cage_index in range(len(cages)):
        target, cell_coords, operation = cages[cage_index]

        # Collect cell variables for this cage
        cage_vars = []
        for (rr, cc) in cell_coords:
            cell_name = f"Var-Cell({rr},{cc})"
            for cell_var in var_array:
                if cell_var.name == cell_name:
                    cage_vars.append(cell_var)
                    break

        # Normalize operation if invalid or None
        if operation not in ['+', '-', '*', '/', '?']:
            operation = '?'

        # Determine operator variable domain
        if operation == '?':
            op_domain = ['+', '-', '*', '/']
        else:
            op_domain = [operation]

        # ### CHANGED: Make the operator variable's name match the desired format
        # Example: "Cage_op(6:+:[Var-Cell(1,1), Var-Cell(1,2), Var-Cell(2,1), Var-Cell(2,2)])"
        cells_str = ', '.join([cv.name for cv in cage_vars])
        op_var_name = f"Cage_op({target}:{operation}:[{cells_str}])"

        op_var = Variable(op_var_name, op_domain)
        var_array.append(op_var)
        csp.add_var(op_var)

        # Build the cage constraint with scope = [op_var] + cage_vars
        constraint_name = f"CageConstraint_{cage_index}"
        scope = [op_var] + cage_vars
        cage_con = Constraint(constraint_name, scope)

        # ---------------------------------------------------
        # 3) Build Satisfying Tuples
        # ---------------------------------------------------
        sat_tuples = []
        cage_size = len(cage_vars)

        # For each possible op in op_domain, check all combos
        for op_choice in op_domain:
            if op_choice == '+':
                for combo in itertools.product(range(1, n+1), repeat=cage_size):
                    if sum(combo) == target:
                        tup = (op_choice,) + combo
                        sat_tuples.append(tup)
            elif op_choice == '*':
                for combo in itertools.product(range(1, n+1), repeat=cage_size):
                    product_val = 1
                    for val in combo:
                        product_val *= val
                    if product_val == target:
                        tup = (op_choice,) + combo
                        sat_tuples.append(tup)
            else:
                # For '-', '/', or '?' cages, implement logic as needed.
                pass

        # Optionally filter each tuple to ensure they fit each variable's domain
        final_tuples = []
        for t in sat_tuples:
            operator_val = t[0]
            cell_vals = t[1:]
            # Check operator is in domain
            if operator_val not in op_var.domain():
                continue
            # Check each cell value is in that cell var's domain
            if all(val in cage_vars[i].domain() for i, val in enumerate(cell_vals)):
                final_tuples.append(t)

        cage_con.add_satisfying_tuples(final_tuples)
        csp.add_constraint(cage_con)

    return csp, var_array
