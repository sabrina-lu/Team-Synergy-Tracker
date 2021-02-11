Z = User.new(student_id: 20567890, watiam: "a266gapha", first_name: "Loki", last_name: "Hulk", password: "Bard")
Z.save
A = User.new(student_id: 20777777, watiam: "a266alpha", first_name: "Iron", last_name: "Man", password: "Joy")
A.save
B = User.new(student_id: 20766666, watiam: "a2beta234", first_name: "Captain", last_name: "America", password: "Toy")
B.save
C = User.new(student_id: 20755555, watiam: "btyui1823", first_name: "Dr. Thor", last_name: "Ragnarok", password: "Juice")
C.save
D = User.new(student_id: 20744444, watiam: "b1234h56j", first_name: "Loki", last_name: "Hawkeye", password: "Kleenex")
D.save
E = User.new(student_id: 20733333, watiam: "gema3hh3n", first_name: "Spider", last_name: "Boy", password: "Cup")
E.save
F = User.new(student_id: 20722222, watiam: "g67tGHEHA", first_name: "Nick", last_name: "Hulk", password: "Agenda")
F.save


# Z = User.new(student_id: 20567890, watiam: "a266gapha", first_name: "Loki", last_name: "Hulk", password: "Bard")
# Z.save
# A = User.new(student_id: 20777777, watiam: "a266alpha", first_name: "I r o n", last_name: "M a n", password: "Bard")
# A.save
# B = User.new(student_id: 20766666, watiam: "a2beta234", first_name: "Capta1n", last_name: "Amer1ca", password: "T0oy")
# B.save
# C = User.new(student_id: 20755555, watiam: "btyui1823", first_name: "Thor A.", last_name: "J. Ragnarok", password: "Juice")
# C.save
# D = User.new(student_id: 20744444, watiam: "b1234h56j", first_name: "Loki", last_name: "Haw.keye", password: "Kl33n3x")
# D.save
# E = User.new(student_id: 20733333, watiam: "gema3hh3n", first_name: "Spi_der", last_name: "B_oy", password: "Cup")
# E.save
# F = User.new(student_id: 20722222, watiam: "g67tGHEHA", first_name: "Nic.k", last_name: "Hulk", password: "Agenda")
# F.save
# Y = User.new(student_id: 20722222, watiam: "g67tGHEHA", first_name: "Jackkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk", last_name: "Frosttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt", password: "Agenda")
# Y.save

t1 = Team.create(name: "Team 1")
t2 = Team.create(name: "Team 2")
t3 = Team.create(name: "Team 3")
t4 = Team.create(name: "Team 4")
t5 = Team.create(name: "Team 5")
t6 = Team.create(name: "Team 6")
t7 = Team.create(name: "Team 7")
t8 = Team.create(name: "Team 8")

t1.users << [A,D,C]

#t2.users << [A,E]

t3.users << [A,B,C,D,E,F]

t4.users << [A]

t5.users << [A,D,E,C]

t6.users << [A,E,D]

t7.users << [A,C,D,E]

#t8.users << [B]

#team 2 has no members
#person Z is not a part of any team
# person Y's name is way too long


G = Manager.new(watiam: "h13ghj567" first_name: "Black", last_name: "Panther", password: "Pickle")
G.save
H = Manager.new(watiam: "12er57yh" first_name: "Black", last_name: "Widow", password: "Smartie")
H.save
I = Manager.new(watiam: "h8fgh5thy", first_name: "Bruce", last_name: "Banner", password: "Chicken")
I.save
J = Manager.new(watiam: "h82ghj6t5", first_name: "Dr. Strange", last_name: "AntMan", password: "Rooster")
J.save
K = Manager.new(watiam: "h8ub34rfj", first_name: "Nick", last_name: "Fury", password: "Jelly")
K.save
L = Manager.new(watiam: "h098vhj4t", first_name: "Loki", last_name: "Fury", password: "Bean")
L.save
M = Manager.new(watiam: "hoiugf865", first_name: "Loki", last_name: "Hulk", password: "Pizza")
M.save
N = Manager.new(watiam: "hRT456K7I", first_name: "Black", last_name: "Peggy", password: "diSCO")
N.save

# G = Manager.new(watiam: "h13ghj567", first_name: "Black", last_name: "Panther", password: "P1ckle")
# G.save
# H = Manager.new(watiam: "h12er57yh", first_name: "Black", last_name: "Wi_dow", password: "Smartie")
# H.save
# I = Manager.new(watiam: "h8fgh5thy", first_name: "Bruc3", last_name: "Bann3r", password: "Chic34ken")
# I.save
# J = Manager.new(watiam: "h82ghj6t5", first_name: "Dr. Strange", last_name: "Ant. Man", password: "R00ster")
# J.save
# K = Manager.new(watiam: "h8ub34rfj", first_name: "Ni_ck", last_name: "Fur_y", password: "345yh")
# K.save
# L = Manager.new(watiam: "h098vhj4t", first_name: "Lo.ki", last_name: "Fur_y", password: "Aba3")
# L.save
# M = Manager.new(watiam: "hoiugf865", first_name: "L o k i", last_name: "Hu.lk", password: "P1zza")
# M.save
# N = Manager.new(watiam: "hRT456K7I", first_name: "Black.", last_name: "P e g g y", password: "d1SCO")
# N.save
# X = Manager.new(watiam: "hRT456K7I", first_name: "Jackkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk", last_name: "Frosttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt", password: "diSCO")
# X.save

#t1.manager << [G]

t2.manager << [G]

t3.manager << [H]

t4.manager << [I]

t5.manager << [J]

t6.manager << [K]

t7.manager << []

#t8.manager << [M]


#Manager N not in charge of any team
#Team 7 has no members
# Manager X's name is too long 

O = Response.new(question_number: 1, response: "No")
O.save
P = Response.new(question_number: 2, response: "NO")
P.save
Q = Response.new(question_number: 3, response: "1")
Q.save
R = Response.new(question_number: 4, response: "Yes")
R.save
S = Response.new(question_number: 5, response: "YES")
S.save
T = Response.new(question_number: 6, response: "2")
T.save
# U = Response.new(question_number: 7, response: "")
# U.save

s1 = Survey.create(date: 2021-02-10)
s2 = Survey.create(date: 0001-02-10)
s3 = Survey.create(date: 1999-02-10)
s4 = Survey.create(date: 2023-02-10)
s5 = Survey.create(date: 2020-02-10)
s6 = Survey.create(date: 1884-02-10)

s1.response << [O,P,Q]

s2.response << [P,R,S,T]

s3.response << [P]

s4.response << [O,P,Q,R,S,T]

s5.response << [P,S]

s6.response << []

# survey 6 has no responses
