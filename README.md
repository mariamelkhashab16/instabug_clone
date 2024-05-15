# Restful chat messaging application

This app is dockerized for easier setup and deployment. Follow these steps to run the application using Docker:

1. Make sure you have Docker installed on your system.
2. Clone the repository to your local machine
3. Navigate to the project directory
5. Start the Docker containers: sudo docker-compose up


## Technicalities covered

1. Using Postgres as main database adapter
2. Restful CRUD APIs for application, chat & messaging models
3. Using elastic search to search for messages in a chat by message content
4. Database level locking to handle race conditions
5. Message queuing using Redis as a broker on chat and message creations
