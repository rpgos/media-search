# Imago Media Search

### Assumptions, limitations and solution

* For the sake of the exercise, I assumed authentication is not necessary, as I'm trying to build just the search feature
* For the same reason, I didn't create a data model to keep the solution simple and focused on the search.
* I'm using react-query to cache results. I'd like to have a Redis cache on the backend too, as it would boost performance, but for the sake of this example, react-query's cache works very well and doesn't need any extra overhead.
* There's no background jobs, although I think background jobs would be a great way to deal with the missing or invalid data, so we could get whatever is missing. Anyway I dealt with this by excluding ES documents without the necessary fields to build the URLs and then on the frontend I'm checking if the URLs are valid and only show something if there's an image.

### System dependencies

* You'll need Docker to run the project


## How to set up and run
1. Check out the repository

    ```
    git clone git@github.com:rpgos/media-search.git
    ```

    ```
    cd media-search
    ```

2. Duplicate the file `example.env` and rename the copy to `.env`
3. Set the env variables in the file

4. Start the containers and create DB

    ```
    docker compose up -d
    ```
    then
    ```
    docker compose exec rails bundle exec rails db:create
    ```

5. Now visit on your browser http://localhost:5173


## How to run the test suite

```
docker compose exec rails bundle exec rspec
```
