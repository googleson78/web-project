<?php
// For Debug. TODO: Add debug mode?
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();

// if (!isset($_SESSION['loggedin'])) {
//     header('Location: login.php');
//     exit();
// }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add task</title>


    <!-- REMOVE THIS LATER: -->
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <!-- shit ends here -->

    <script type="module" src="../addTask.js"></script>

</head>
<body>
    <?php require_once '../navbar.php'; ?>


    <div class="container">
      <form action="javascript:;" onsubmit="addTask()">
        <div class="form-group">
          <label>Task name
            <input class="form-control" name="name" id="name"></input>
          </label>
        </div>

        <div class="form-group">
          <label>Task description
            <input class="form-control" name="description" id="description"></input>
          </label>
        </div>

        <div class="form-group">
          <label>Expected filename for task solution - tests are expected to "import" this file
            <input class="form-control" name="expected-filename" id="expected-filename"></input>
          </label>
        </div>

        <div class="form-group">
          <label>Task programming language
            <select class="form-control" name="language" id="language">
              <option value="Racket">Racket</option>
            </select>
          </label>
        </div>

        <div class="form-group">
          <label>Tests code
            <textarea class="form-control" rows="6" cols="80" name="tests" id="tests"></textarea>
          </label>
        </div>

        <div class="form-group">
          <input type="submit" value="Submit">
        </div>
      </form>
    </div>

</body>
</html>
