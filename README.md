# New Idea API

## Summary

This API is the backend for the New Idea application for sharing and creating new ideas. The API is currently and V1 status and available endpoints can be found below.

## Available Endpoints

### Create a User

`POST /api/v1/users`

- Accepts the following JSON shape:

```javascript
{
  "email": "notanemail@na.moc",
  "username": "notarealusername",
  "uid": "asd123"
}
```

- Returns a 204 is the user creation was successful
- Returns a 400 with an error message if unsuccessful. The error messages are returned in the following format:

```javascript
{
  "message": "An error has occurred.",
  "error": "SomeError::ClassThing: This is the error message"
}
```

### Retrieve a User

`GET /api/v1/users/:id`

- Retrieves the user with the specified id
- Returns an object of user data including:
  - id (integer)
  - uid (alphanumeric string)
  - email (string)
  - username (string)
- Returns all of that user's ideas in a collection.
- Returns all of that user's contributions in a collection.
- Returns all of that user's comments in a collection.

```javascript
{
  "id": 123,
  "uid": "abc123",
  "email": "notanemail@na.moc",
  "username": "notausername",
  "ideas": [
    {
      "id": 1,
      "title": "Idea 1",
      "body": "This is the first idea"
    }
  ],
  "contributions": [
    {
      "id": 1,
      "body": "This is the first contribution for Idea 1",
      "idea_id": 1
    }
  ],
  "comments": [
    {
      "id": 1,
      "body": "This is a comment for contribution 1",
      "contribution_id": 1
    },
    {
      "id": 3,
      "body": "This is a third comment for contribution 1",
      "contribution_id": 1
    }
  ]
}
```

- Returns a 404 with the normal error message structure (see first endpoint) if an error occurs getting the user.

### Create Contributions

Contributions belong to a specific Idea record. They can be created as part of a specified idea.

`POST /api/v1/ideas/:id/contributions`

- Accepts the following JSON payload:

```javascript
{
  "user_id": 123,
  "body": "This is the really cool contribution for a really cool idea."
}
```

- `body` abd `user_id` are both required payload parameters.
- Returns a 201 status code if successful.
- Returns a 400 error with standard messages if unsuccessful.

