# New Idea API

## Summary

This API is the backend for the New Idea application for sharing and creating new ideas. The API is currently and V1 status and available endpoints can be found below.

## Available Endpoints

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
