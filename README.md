# Restful chat messaging application

This app is dockerized for easier setup and deployment. Follow these steps to run the application using Docker:

1. Make sure you have Docker installed on your system.
2. Clone the repository to your local machine
    ```git clone https://github.com/mariamelkhashab16/instabug_clone.git
3. Navigate to the project directory
4. Attach .env file in the root directory of the project
5. Start the Docker containers
    ```docker-compose up
    or
    ```sudo docker-compose up
    for super user privilages

## Technicalities covered

1. Using Postgres as main database adapter
2. Restful CRUD APIs for application, chat & messaging models
3. Using elastic search to search for messages in a chat by message content
4. Database level locking to handle race conditions
5. Message queuing on chat and message creations using rails queing framwork: Active Job 

## Future enhancements 

1. User authentication
2. Build the endpoints as a Golang app
3. Write specs