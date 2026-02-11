# API Routes مقترحة

## Auth
- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`

## Users
- `GET /api/v1/users/:id`
- `PATCH /api/v1/users/:id/profile`
- `GET /api/v1/users/:id/friends`
- `POST /api/v1/users/:id/follow`
- `POST /api/v1/users/:id/block`

## Feed & Posts
- `GET /api/v1/feed`
- `POST /api/v1/posts`
- `POST /api/v1/posts/:id/react`
- `POST /api/v1/posts/:id/comments`

## Stories/Reels
- `POST /api/v1/stories`
- `GET /api/v1/stories`
- `POST /api/v1/reels`
- `GET /api/v1/reels/trending`

## Messaging
- `POST /api/v1/conversations`
- `GET /api/v1/conversations/:id/messages`
- `POST /api/v1/conversations/:id/messages`

## Marketplace
- `POST /api/v1/marketplace/listings`
- `GET /api/v1/marketplace/listings`
- `POST /api/v1/marketplace/listings/:id/offers`

## Moderation
- `POST /api/v1/reports`
- `POST /api/v1/reports/:id/review`
