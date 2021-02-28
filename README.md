# Google photos backup

This is a utility that will copy all media from Google Photos to a place of your choosing.

Currently supported:

* Local filesystem
* Amazon S3

## Setup

The following env vars are needed for the photos script to run:

* `GOOGLE_CLIENT_ID`
* `GOOGLE_CLIENT_SECRET`
* `REFRESH_TOKEN`
(See below for getting these values)

* `HANDLER` - This is what to do with a media item. Current supported values are `S3` and `file`.

To back up to S3, you'll need the following set:
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`
* `S3_BUCKET`

## Getting the GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, REFRESH_TOKEN

Google Photos does not have a service account API, so you must first go
to the [google developers console](gdc) and create a project that utilizes the
Photos Library API.  You'll need to create an Oauth 2.0 web client ID as well.

When you create the web client, use the client id and secret as
`GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` env vars for this script.

Once you have the client ID and client secret, it's time to get `REFRESH_TOKEN`
value.  Head to the [Oauth2 playground](play). 

1. Where it says "input your own scopes", input `https://www.googleapis.com/auth/photoslibrary.readonly`.
2. Click "Authorize APIs".  You will start the oauth2 flow.
3. Once you're back in the playground, click "Exchange authorization for tokens".
4. The refresh token is what we'll need.  We'll be setting that token as the value of `REFRESH_TOKEN`.

## Running locally without Docker

If you have Ruby installed locally, you can run the script without Docker.

1. Copy your ENV vars from above into a file `.env`
2. `google-photos-backup` uses a Sqlite3 DB to maintain state, which needs initialization, so run: `bundle exec rake db_setup`
3. Finally, run `bundle exec rake process`.

You can set up `rake process` to run as a cron job.  The script will stop once it is finished processing newly-unseen photos.

[gdc]: https://console.developers.google.com/
[play]: https://www.googleapis.com/auth/photoslibrary.readonly
