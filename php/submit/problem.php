<?php
// For Debug. TODO: Add debug mode?
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();

if (!isset($_SESSION['loggedin'])) {
    header('Location: /login.php');
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Tasks</title>


    <!-- REMOVE THIS LATER: -->
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <!-- shit ends here -->

    <script type="module" src="../submitProblem.js"></script>

</head>
<body>
    <?php require_once '../navbar.php'; ?>

    <div class="container">
        <div id="submission">
        <form action="javascript:;" onsubmit="submitTask()">

            <div class="form-group">
            <label>Solution code
                <textarea class="form-control" rows="6" cols="80" name="problem" id="problem" required></textarea>
            </label>
            </div>

            <div class="form-group">
                <input type="submit" value="Submit" class="btn btn-primary">
            </div>
        </form>
        </div>
        <div id="task"></div>
        <pre class="invisible" id="output"></pre>
        <pre class="invisible" id="errors"></pre>
    </div>

</body>
</html>
