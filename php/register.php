<?php
// For Debug. TODO: Add debug mode?
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once 'db-config.php';

session_start();

if (isset($_SESSION['loggedin'])) {
	header('Location: index.php');
	exit; // is it necessary ?
}

$error_message = '';
$success_message = '';

// Register user
if (isset($_POST['btnsignup'])) {
    $username = trim($_POST['uname']);
    $password = trim($_POST['password']);
    $confirmpassword = trim($_POST['confirmpassword']);

    $isValid = true;

    // Check fields are empty or not
    if (
        $username == '' ||
        $password == '' ||
        $confirmpassword == ''
    ) {
        $isValid = false;
        $error_message = 'Please fill all fields.';
    }

    // Check if confirm password matching or not
    if ($isValid && $password != $confirmpassword) {
        $isValid = false;
        $error_message = 'Confirm password not matching';
    }

    if ($isValid) {
        // Check if username already exists
        $stmt = $conn->prepare('SELECT * FROM user WHERE name = ?');
        $stmt->bind_param('s', $username);
        $stmt->execute();
        $result = $stmt->get_result();
        $stmt->close();
        if ($result->num_rows > 0) {
            $isValid = false;
            $error_message = 'Username is already exists.';
        }
    }

    // Insert records
    if ($isValid) {
      // TODO: add password excryption
        $insertSQL =
            'INSERT INTO user(name,password) values(?,?)';
        $stmt = $conn->prepare($insertSQL);
        $stmt->bind_param('ss', $username, $password);
        $stmt->execute();
        $stmt->close();

        $success_message = 'Account created successfully.';
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>


    <!-- REMOVE THIS LATER: -->
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <!-- shit ends here -->

</head>
<body>
  <?php require_once "navbar.php"; ?>
    <div class='container'>
      <div class='row'>

        <div class='col-md-6' >

          <form method='post' action=''>

            <h1>SignUp</h1>

            <?php // Display Error message
            if (!empty($error_message)) { ?>
                <div class="alert alert-danger">
                <strong>Error!</strong> <?= $error_message ?>
                </div>
            <?php } ?>

            <?php // Display Success message
            if (!empty($success_message)) { ?>
                <div class="alert alert-success">
                <strong>Success!</strong> <?= $success_message ?>
                </div>
            <?php } ?>

            <div class="form-group">
              <label for="fname">Username:</label>
              <input type="text" class="form-control" name="uname" id="uname" required="required" maxlength="80">
            </div>
            <div class="form-group">
              <label for="password">Password:</label>
              <input type="password" class="form-control" name="password" id="password" required="required" maxlength="80">
            </div>
            <div class="form-group">
              <label for="pwd">Confirm Password:</label>
              <input type="password" class="form-control" name="confirmpassword" id="confirmpassword" onkeyup='' required="required" maxlength="80">
            </div>

            <button type="submit" name="btnsignup" class="btn btn-default">Submit</button>
          </form>
        </div>

     </div>
    </div>
  </body>
</html>