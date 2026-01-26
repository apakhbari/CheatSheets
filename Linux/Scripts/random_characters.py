import random
import string
def create_random(count_characters:int=4,count_digit:int=4):
    character = "%+()*&^$!" + string.ascii_uppercase + string.ascii_lowercase
    number = string.digits
    chars = ["".join(random.sample(character,count_characters)) for _ in range(count_characters)][0]
    numbs = ["".join(random.sample(number,count_digit)) for _ in range(count_digit)][0]
    export = ["".join(random.sample(chars+numbs, count_characters+count_digit)) for _ in range(count_characters+count_digit)][0]
    return export
print(create_random(count_characters=5,count_digit=3))
