Z = User.new(watiam: "student7", first_name: "Alpha", last_name: "Hulk", password: "password")
A = User.new(watiam: "student1", first_name: "Gamma", last_name: "Man", password: "password")
B = User.new(watiam: "student2", first_name: "Beta", last_name: "America", password: "password")
C = User.new(watiam: "student3", first_name: "Epsilon", last_name: "Ragnarok", password: "password")
D = User.new(watiam: "student4", first_name: "Gemma", last_name: "Hawkeye", password: "password")
E = User.new(watiam: "student5", first_name: "Lambda", last_name: "Boy", password: "password")
F = User.new(watiam: "student6", first_name: "Equal", last_name: "Hulk", password: "password")
generic_user = User.new(watiam: "userwat123", first_name: "Awesome", last_name: "Student", password: "password")

G = Manager.new(watiam: "manager1", first_name: "Do", last_name: "Panther", password: "password")
H = Manager.new(watiam: "manager2", first_name: "Re", last_name: "Widow", password: "password")
I = Manager.new(watiam: "manager3", first_name: "Mi", last_name: "Banner", password: "password")
J = Manager.new(watiam: "manager4", first_name: "Fa", last_name: "AntMan", password: "password")
K = Manager.new(watiam: "manager5", first_name: "So", last_name: "Fury", password: "password")
L = Manager.new(watiam: "manager6", first_name: "La", last_name: "Fury", password: "password")
M = Manager.new(watiam: "manager7", first_name: "Doe", last_name: "Hulk", password: "password")
N = Manager.new(watiam: "manager8", first_name: "Ti", last_name: "Peggy", password: "password")
generic_manager = Manager.new(watiam: "managwat", first_name: "Awesome", last_name: "Manager", password: "password")

t1 = Team.new(name: "Team 1")
t2 = Team.new(name: "Team 2")
t3 = Team.new(name: "Team 3")
t4 = Team.new(name: "Team 4")
t5 = Team.new(name: "Team 5")
t6 = Team.new(name: "Team 6")
t7 = Team.new(name: "Team 7")
t8 = Team.new(name: "Team 8")
t9 = Team.new(name: "MSCI 311")
t10 = Team.new(name: "MSCI 344")
t11 = Team.new(name: "MSCI 342")
t12 = Team.new(name: "MSCI 431")
t13 = Team.new(name: "MSCI 446")


t1.users << [A,D,C]

t2.users << [A,E]

t3.users << [A,B,C,D,E,F]

t4.users << [A]

t5.users << [A,D,E,C]

t6.users << [A,E,D]

t7.users << [A,C,D,E]

t8.users << [B]

t9.users << [generic_user, E, D, B]

t10.users << [generic_user]

t11.users << [generic_user]

t12.users << [generic_user]

t13.users << [generic_user]

G.teams << [t1, t2]

H.teams << [t3]

I.teams << [t4]

J.teams << [t5]

K.teams << [t6, t7]

M.teams << [t8]

generic_manager.teams << [t9, t10, t11, t12, t13]

G.save
H.save
I.save
J.save
K.save
L.save
M.save
N.save
generic_manager.save

# adding surveys to users and teams

survey_due_date = Survey.get_current_survey_due_date(Date.today)

s1 = Survey.create(date: survey_due_date)
s2 = Survey.create(date: survey_due_date)
s3 = Survey.create(date: survey_due_date)
s4 = Survey.create(date: survey_due_date)
s5 = Survey.create(date: survey_due_date)
s6 = Survey.create(date: survey_due_date)
s7 = Survey.create(date: survey_due_date)
s8 = Survey.create(date: survey_due_date)
s9 = Survey.create(date: survey_due_date)
s10 = Survey.create(date: survey_due_date)
s11 = Survey.create(date: survey_due_date)
s12 = Survey.create(date: survey_due_date)
s13 = Survey.create(date: survey_due_date)
s14 = Survey.create(date: survey_due_date)
s15 = Survey.create(date: survey_due_date)
s16 = Survey.create(date: survey_due_date)
s17 = Survey.create(date: survey_due_date)
s18 = Survey.create(date: survey_due_date)
s19 = Survey.create(date: survey_due_date)
s20 = Survey.create(date: survey_due_date)
s21 = Survey.create(date: survey_due_date)
s22 = Survey.create(date: survey_due_date)
s23 = Survey.create(date: survey_due_date)
s24 = Survey.create(date: survey_due_date)
s25 = Survey.create(date: survey_due_date)
s26 = Survey.create(date: survey_due_date)
s27 = Survey.create(date: survey_due_date)
s28 = Survey.create(date: survey_due_date)
s29 = Survey.create(date: survey_due_date)

A.surveys << [s1,s2,s3,s4,s5,s6,s7]
B.surveys << [s8, s9]
C.surveys << [s10, s11, s12, s13]
D.surveys << [s14, s15, s16, s17, s18]
E.surveys << [s19, s20, s21, s22, s23]
F.surveys << [s24]
generic_user.surveys << [s25, s26, s27, s29]

t1.surveys << [s1, s14, s10]
t2.surveys << [s2, s19]
t3.surveys << [s3, s8, s11, s15, s20, s24]
t4.surveys << [s4]
t5.surveys << [s5, s16, s21, s12]
t6.surveys << [s6, s22, s17]
t7.surveys << [s7, s13, s18, s23]
t8.surveys << [s9]
t9.surveys << [s25]
t10.surveys << [s26]
t11.surveys << [s27]
t12.surveys << [s28]
t13.surveys << [s29]

ticket1 = Ticket.new(date: survey_due_date-1)
ticket2 = Ticket.new(date: survey_due_date-1)
ticket3 = Ticket.new(date: survey_due_date-1)
ticket4 = Ticket.new(date: survey_due_date-1)
ticket5 = Ticket.new(date: survey_due_date-1)
ticket6 = Ticket.new(date: survey_due_date-1)
ticket7 = Ticket.new(date: survey_due_date-1)
ticket8 = Ticket.new(date: survey_due_date-1)
ticket9 = Ticket.new(date: survey_due_date-1)
ticket10 = Ticket.new(date: survey_due_date-1)

#assign ticket to its creator
ticket1.creator = B
ticket2.creator = C
ticket3.creator = D
ticket4.creator = E
ticket5.creator = F
ticket6.creator = A
ticket7.creator = A
ticket8.creator = E
ticket9.creator = D
ticket10.creator = B

ticket1.team = t3
ticket2.team = t1
ticket3.team = t3
ticket4.team = t5
ticket5.team = t3
ticket6.team = t3
ticket7.team = t6
ticket8.team = t9
ticket9.team = t9
ticket10.team = t9

#assign tickets to receiving user
A.tickets << [ticket1, ticket5]
B.tickets << [ticket6]
C.tickets << [ticket4]
D.tickets << [ticket2]
E.tickets << [ticket7]
F.tickets << [ticket3]
generic_user.tickets << [ticket8, ticket9, ticket10]

A.save
B.save
C.save
D.save
E.save
F.save
Z.save
generic_user.save

t1.save
t2.save
t3.save
t4.save
t5.save
t6.save
t7.save
t8.save
t9.save
t10.save
t11.save
t12.save
t13.save

ticket1.save
ticket2.save
ticket3.save
ticket4.save
ticket5.save
ticket6.save
ticket7.save
ticket8.save
ticket9.save
ticket10.save

#assign ticket responses
t = [ticket1, ticket2, ticket3, ticket4, ticket5, ticket6, ticket7, ticket8, ticket9, ticket10]
for i in 0..9 do
  TicketResponse.create(ticket_id: t[i].id, question_number: 1, answer: rand(1..3))
  TicketResponse.create(ticket_id: t[i].id, question_number: 2, answer: rand(1..3))
  TicketResponse.create(ticket_id: t[i].id, question_number: 3, answer: rand(1..3))
  TicketResponse.create(ticket_id: t[i].id, question_number: 4, answer: rand(1..3))
  TicketResponse.create(ticket_id: t[i].id, question_number: 5, answer: rand(1..10))
end

O = Response.new(survey_id: 1, question_number: 1, answer: "2") #need foreign key that references survey_id
P = Response.new(survey_id: 2, question_number: 2, answer: "4")
Q = Response.new(survey_id: 3, question_number: 3, answer: "1")
R = Response.new(survey_id: 4, question_number: 4, answer: "5")
S = Response.new(survey_id: 5, question_number: 5, answer: "3")
T = Response.new(survey_id: 6, question_number: 6, answer: "2")
U = Response.new(survey_id: 25, question_number: 1, answer: "2")
V = Response.new(survey_id: 26, question_number: 2, answer: "5")
W = Response.new(survey_id: 27, question_number: 3, answer: "3")
#X = Response.new(survey_id: 28, question_number: 4, answer: "5")
ZA = Response.new(survey_id: 25, question_number: 2, answer: "2")

# U = Response.new(question_number: 7, response: "")
# U.save

s1.responses << [O, P, Q, R, S, T] 
s1.save

s25.responses << [U, ZA]
s26.responses << [V]
s27.responses << [W]
#s28.responses << [X]

O.save
P.save
Q.save
R.save
S.save
T.save
U.save
V.save
W.save
#X.save
ZA.save


# create surveys and tickets for last week, two weeks ago and three weeks ago
users = [A,B,C,D,E,F,generic_user]
for i in 0..users.length-1 do
  users[i].teams.each do |team|
    for j in 1..3 do
      s = Survey.create(team_id: team.id, user_id: users[i].id, date: survey_due_date - 7*j)
      for x in 1..4 do 
        Response.create(survey_id: s.id, question_number: x, answer: rand(1..5))
      end
      team_users = team.users - [users[0]]
      if (team_users != []) 
        t = Ticket.create(team_id: team.id, creator_id: users[i].id, date: survey_due_date - 8*j)
        t.users << team_users.sample
        for y in 1..4 do 
          TicketResponse.create(ticket_id: t.id, question_number: y, answer: rand(1..3))
        end
        TicketResponse.create(ticket_id: t.id, question_number: 5, answer: rand(1..10))
      end
    end
  end
end
