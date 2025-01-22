# =============================
# Student Names:
# Group ID:
# Date:
# =============================
# CISC 352 - W23
# heuristics.py
# desc:
#


#Look for #IMPLEMENT tags in this file. These tags indicate what has
#to be implemented to complete problem solution.

'''This file will contain different constraint propagators to be used within
   the propagators

1. ord_dh (worth 0.25/3 points)
    - a Variable ordering heuristic that chooses the next Variable to be assigned 
      according to the Degree heuristic

2. ord_mv (worth 0.25/3 points)
    - a Variable ordering heuristic that chooses the next Variable to be assigned 
      according to the Minimum-Remaining-Value heuristic


var_ordering == a function with the following template
    var_ordering(csp)
        ==> returns Variable

    csp is a CSP object---the heuristic can use this to get access to the
    Variables and constraints of the problem. The assigned Variables can be
    accessed via methods, the values assigned can also be accessed.

    var_ordering returns the next Variable to be assigned, as per the definition
    of the heuristic it implements.
   '''

def ord_dh(csp):
    ''' return next Variable to be assigned according to the Degree Heuristic '''
    # IMPLEMENT
    
    # unassign_var = csp.get_all_unasgn_var()
    
    # if not unassign_var:
    #     return None
    
    # vari_highest = ""
    # count = 0
    # for each_var in unassign_var:
    #     len_var = len(csp.get_con_with_var(each_var))
    #     if len_var > count :
    #         count = len_var
    #         vari_highest = each_var
            
    
    # return vari_highest

    unassigned_vars = csp.get_all_unasgn_vars()
    if not unassigned_vars:
        return None

    def count_other_unassigned_constraints(var):
        count = 0
        for constraint in csp.get_cons_with_var(var):
            if constraint.get_n_unasgn() > 1:
                count += 1
        return count

    # Return the variable with the maximum "refined degree" count
    return max(unassigned_vars, key=count_other_unassigned_constraints)


def ord_mrv(csp):
    ''' return Variable to be assigned according to the Minimum Remaining Values heuristic '''
    # IMPLEMENT


    # unassign_var = csp.get_all_unasgn_var()
    
    # if not unassign_var:
    #     return None
    
    # count = 99999999
    # var_low = ""

    # for each_value in unassign_var:
    #     len_var = each_value.cur_domain_size()
    #     if len_var < count:
    #         count  = len_var
    #         var_low = each_value


    # return var_low
    unassigned_vars = csp.get_all_unasgn_vars()
    if not unassigned_vars:
        return None

    return min(unassigned_vars, key=lambda var: var.cur_domain_size())

