# Admin needs to be persisted, and creating a new table for it is not feasible.
# Email id contains first and password contains last name.
admin = User.create({email_id: "Koala",password: "Lumpur",is_admin: true})