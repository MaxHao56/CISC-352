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
    n, cage = cagey_grid # n is the number of elements in row and col , cage is the cage but not needed for this function since it will be about cage contraints
    variable_array = [] # creating variables to passes it to the CSP object 
    name = "binary_grid"

    for row in range(n*n):
        var_name = f"cell {row//n},{row%n}"
        domain = list(range(1,n+1))
        var = Variable(var_name, domain)
        variable_array.append(var)

    csp = CSP(name,variable_array) # passes variables in creating CSP object

    sat_tuple = [[x, y] for (x, y) in itertools.product(domain, repeat=2) if x != y] # All legal tuples

    for row in range(n):
        for col in range(n-1):
            var1 = variable_array[row * n + col]
            var2 = variable_array[row * n + col + 1]

            contraint1 = Constraint(f'C({row},{col})->({row},{col+1})', [var1, var2])
            contraint2 = Constraint(f'C({row},{col+1})->({row},{col})', [var2, var1])

            contraint1.add_satisfying_tuples(sat_tuple)
            contraint2.add_satisfying_tuples(sat_tuple)

            csp.add_constraint(contraint1)
            csp.add_constraint(contraint2)

    for col in range(n):
        for row in range(n-1):
            var1 = variable_array[row * n + col]
            var2 = variable_array[row * (n + 1) + col]

            contraint1 = Constraint(f'C({row},{col})->({row+1},{col})', [var1, var2])
            contraint2 = Constraint(f'C({row+1},{col})->({row},{col})', [var2, var1])

            contraint1.add_satisfying_tuples(sat_tuple)
            contraint2.add_satisfying_tuples(sat_tuple)

            csp.add_constraint(contraint1)
            csp.add_constraint(contraint2)

    return csp

    


def nary_ad_grid(cagey_grid):
    ## IMPLEMENT

    n, cage = cagey_grid # n is the number of elements in row and col , cage is the cage but not needed for this function since it will be about cage contraints
    variable_array = [] # creating variables to passes it to the CSP object 
    name = "nary_Grid"

    for row in range(n*n):
        var_name = f"cell {row//n},{row%n}"
        domain = list(range(1,n+1))
        var = Variable(var_name, domain)
        variable_array.append(var)

    csp = CSP(name,variable_array) # passes variables in creating CSP object

    sat_tuple = list(itertools.permutations(domain))

    for row in range(n):
        var_row = [variable_array[row * n + col] for col in range(n)]

        contraint1 = Constraint(f'C({var_row}', var_row)
        contraint1.add_satisfying_tuples(sat_tuple)
        csp.add_constraint(contraint1)

    for col in range(n):
        var_col = [variable_array[row * n + col] for row in range(n)]
        contraint1 = Constraint(f'C({var_col}', var_col)
        contraint1.add_satisfying_tuples(sat_tuple)
        csp.add_constraint(contraint1)

    return csp



























































#     n, cages = cagey_grid  # 'cages' not used in this function
#     csp = CSP("NaryAllDiffGrid")

#     # Step 1: Create Variables
#     var_array = []
#     for row in range(n):
#         for col in range(n):
#             var_name = f"Cell({row+1},{col+1})"
#             var = Variable(var_name, list(range(1, n + 1)))  # Domain [1..n]
#             csp.add_var(var)
#             var_array.append(var)

#     # Step 2: Add N-ary All-Different Constraints
#     for row in range(n):
#         row_vars = [var_array[row * n + col] for col in range(n)]
#         con = Constraint(f"RowAllDiff({row})", row_vars)
#         con.add_satisfying_tuples(list(itertools.permutations(range(1, n + 1), n)))
#         csp.add_constraint(con)

#     for col in range(n):
#         col_vars = [var_array[row * n + col] for row in range(n)]
#         con = Constraint(f"ColAllDiff({col})", col_vars)
#         con.add_satisfying_tuples(list(itertools.permutations(range(1, n + 1), n)))
#         csp.add_constraint(con)

#     return csp, var_array

# def cagey_csp_model(cagey_grid):
#     ##IMPLEMENT
#     n, cage_list = cagey_grid
#     csp = CSP("CageyCSP")
    
#     # Step 1: Create Variables
#     var_array = []
#     for row in range(n):
#         for col in range(n):
#             var_name = f"Cell({row+1},{col+1})"
#             var = Variable(var_name, list(range(1, n + 1)))
#             csp.add_var(var)
#             var_array.append(var)

#     # Step 2: Add N-ary All-Different Constraints (Row & Column)
#     for row in range(n):
#         row_vars = [var_array[row * n + col] for col in range(n)]
#         con = Constraint(f"RowAllDiff({row})", row_vars)
#         con.add_satisfying_tuples(list(itertools.permutations(range(1, n + 1), n)))
#         csp.add_constraint(con)

#     for col in range(n):
#         col_vars = [var_array[row * n + col] for row in range(n)]
#         con = Constraint(f"ColAllDiff({col})", col_vars)
#         con.add_satisfying_tuples(list(itertools.permutations(range(1, n + 1), n)))
#         csp.add_constraint(con)

#     # Step 3: Add Cage Constraints
#     for idx, (target, cells, op) in enumerate(cage_list):
#         cage_vars = [var_array[(r-1) * n + (c-1)] for (r, c) in cells]
#         con = Constraint(f"Cage({idx})", cage_vars)

#         # Generate satisfying tuples for the cage constraint
#         satisfying_tuples = []
#         for values in itertools.permutations(range(1, n + 1), len(cells)):
#             if op == '+':
#                 if sum(values) == target:
#                     satisfying_tuples.append(values)
#             elif op == '-':
#                 if any(abs(x - y) == target for x, y in itertools.permutations(values, 2)):
#                     satisfying_tuples.append(values)
#             elif op == '*':
#                 if eval('*'.join(map(str, values))) == target:
#                     satisfying_tuples.append(values)
#             elif op == '/':
#                 if any(x // y == target and x % y == 0 for x, y in itertools.permutations(values, 2)):
#                     satisfying_tuples.append(values)
#             elif op == '?':  # Unknown operator, accept any valid one
#                 if sum(values) == target or \
#                    any(abs(x - y) == target for x, y in itertools.permutations(values, 2)) or \
#                    eval('*'.join(map(str, values))) == target or \
#                    any(x // y == target and x % y == 0 for x, y in itertools.permutations(values, 2)):
#                     satisfying_tuples.append(values)

#         con.add_satisfying_tuples(satisfying_tuples)
#         csp.add_constraint(con)

#     return csp, var_array
