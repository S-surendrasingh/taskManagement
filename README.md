# Task Manager API

Rails API for task management with JWT auth, role-based permissions, caching, and a simple admin interface.

## Features

* JWT authentication, bcrypt passwords
* Admin & user roles
* CRUD tasks with pagination
* Caching & optimized queries
* Admin dashboard & task stats
* Proper error handling

## Setup

### Requirements

* Ruby 3.0+, Rails 6.1+
* SQLite3 or PostgreSQL

### Install

```bash
bundle install
```

Set JWT secret:

```bash
# Mac/Linux
export JWT_SECRET="random_long_secret"
# Windows PowerShell
$env:JWT_SECRET="random_long_secret"
```

Create DB & run migrations:

```bash
rails db:prepare
rails server
```

API runs at `http://localhost:3000`.

## Database

**Users:** id, name, email, password_digest, role, auth_token
**Tasks:** id, title, description, status, due_date, user_id

## Auth

Sign up / login to get `auth_token` for requests:

```bash
-H "Authorization: Bearer YOUR_TOKEN"
```

Signup always creates a `user` role. Create admins via Rails console.

## API Endpoints

**Tasks:**

* `GET /tasks` – list (paginated), admin sees all, users see own
* `GET /tasks/:id` – single task
* `POST /tasks` – create task (assignable by admin)
* `PUT /tasks/:id` – update task
* `DELETE /tasks/:id` – admin only

Pagination params:

* `page` (default 1)
* `per_page` (default 10, max 100)

**Stats:** `GET /users/:id/task_stats` – total/completed/pending/overdue

## Roles

* **Admin:** manage all tasks, assign users, delete tasks
* **User:** manage own tasks, cannot delete

## Authorization

Custom role checks in controllers:

* Admin can access any task.
* Users can only access their own tasks.

## Admin Dashboard

Access: `http://localhost:3000/admin/login`

Create admin via Rails console:

```ruby
User.create!(name: 'Admin', email: 'admin@example.com', password: 'password123', role: 'admin')
```

## Caching

* Tasks cached per user/admin + page/per_page
* Cache keys include a version that is bumped on task create/update/delete

Manual clear:

```bash
rails console
Rails.cache.clear
```

## Notes

* JWT lasts 7 days
* Passwords hashed with bcrypt
* Use `.includes()` to avoid N+1 queries
* Admin UI is internal only
* For production: strong JWT secret, PostgreSQL, HTTPS, Redis, rate limiting
