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

### Create a Contribution

Contributions belong to a specific Idea record. They can be created as part of a specified idea.

`POST /api/v1/ideas/:id/contributions`

- Accepts the following JSON payload:

```javascript
{
  "user_id": 123,
  "body": "This is the really cool contribution for a really cool idea."
}
```

- `body` and `user_id` are both required payload parameters.
- Returns a 201 status code if successful.
- Returns a 400 error with standard messages if unsuccessful.


### Edit a Contribution

Contributions can be edited directly, without having to reference the parent Idea.

`PATCH /api/v1/contributions/:id`

- Accepts the following JSON payload:

```javascript
{
  "body": "This the edited body for a contribution"
}
```

- Returns a 201 is successful.
- Returns 400 with standard error messages if unsuccessful.


### Retrieve an Idea

`GET /api/v1/ideas/:id`

- Returns the Idea's content along with:
  - The Author's information
  - The associsted Contributions and their Authors' information
  - Those Contributions' Comments

```javascript
 {
    "title": "Cool Idea",
    "body": "This is the content of the cool idea.",
    "author": {
      "username": "coolauthor",
      "email": "coolemail@na.moc",  
      "uid": "abc123"
    },
    "contributions":[
      {
        "body": "This is the body of the first contribution", 
        "author": { 
          "username": "anotheruser",
          "email": "anotheruser@na.moc",  
          "uid": "def234"
        },
        "comments":[
          {
            "body": "But what about this?",
            "author": {
              "username": "coolauthor",
              "email": "coolemail@na.moc",
              "uid": "abc123"
            }
          },
          {
            "body": "But what about this other thing?",
            "author": {
              "username": "anotheruser",
              "email": "anotheruser@na.moc",
              "uid": "def234"
            }
          },
          {
            "body": "Okay, that makes sense",
            "author": {
              "username": "coolauthor",
              "email": "coolemail@na.moc",
              "uid": "abc123"
            }
          }
        ]
      },
      {
        "body": "Hey, here's another thought.", 
        "author": {
          "username": "someone_else",
          "email": "someone_else@na.moc",  
          "uid": "xyz321"
        },
        "comments":[
          {
            "body": "That's interesting",
            "author": {
              "username": "coolauthor",
              "email": "coolemail@na.moc",
              "uid": "abc123"
            }
          },
          {
            "body": "Okay, thanks!",
            "author": {
              "username": "someone_else",
              "email": "someone_else@na.moc",
              "uid": "xyz321"
            }
          }
          {
            "body": "You all are the best!",
            "author": {
              "username": "anotheruser",
              "email": "anotheruser@na.moc",
              "uid": "def234"
            }
          }
        ]
      }
    ]
  }
```

- Returns a 404 if not found
