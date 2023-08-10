# print('Hello World, what\'s new these days?')
# print(7+7)
# greeting = 49
# print(greeting+greeting)


def is_vowel(x):
    # check to see is the lowercase version is in the list of vowels
    if (str(x).lower() in ['a','e','i','o','u']):
        return True
    else:
        return False
    
def calc_tip(total_bill,tip_pct):
    '''
    Inputs: total_bill: bill amount
            tip_pct: percentage of total bill for tip, expressed as a decimal between 0 and 1
    Output: Tip amount based upon percentage
    '''
    # multiply the total bill by the desired tip pct, round the result to two decimals, and force 
    # format two decimals
    print(f'$ {round(total_bill * tip_pct,2):.2f}')
    tip_amount = round(total_bill * tip_pct,2)
    return tip_amount