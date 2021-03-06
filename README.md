# Intuitive Form

This is an educational group project for the Introduction to Programming II course at Innopolis University.
The goal of this project is to implement an application for submitting data to a database via a web form
and analyzing previously submitted data with provided queries

## Building and running

### Windows

Clone the repository:

    git clone https://github.com/intuitive-form/server.git --recursive

Open `intuitive_server.ecf` in Eiffel Studio, select target `intuitive_server`, open class `APPLICATION_LAUNCHER` and press `Run`.

### Linux

Clone the repository:

    $ git clone https://github.com/intuitive-form/server.git --recursive

Open `intuitive_server.ecf` in Eiffel Studio, select target `intuitive_server`, open class `APPLICATION_LAUNCHER` and press `Run`.


### Linux without GUI

Build the project:

    $ cd server
    $ ec -config intuitive_server.ecf -target intuitive_server
    $ cd EIFGENs/intuitive_server/W_code
    $ finish_freezing
    $ cd ../../..

Run the binary:

    $ EIFGENs/intuitive_server/W_code/intuitive_server 
    
## Using

The application has two main interfaces, form interface at `/submit/` and query interface at `/admin/`. Default port is 8080.
To use the application, visit either `http://<address>:8080/submit/` or `http://<address>:8080/admin/`.
