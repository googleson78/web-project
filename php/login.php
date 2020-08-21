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

if (isset($_POST['btnlogin'])) {
    $username = trim($_POST['uname']);
    $password = trim($_POST['password']);

    $isValid = true;

    // Check fields are empty or not
    if (
        $username == '' ||
        $password == ''
    ) {
        $isValid = false;
        $error_message = 'Please fill all fields.';
    }

    if ($isValid) {
        // Check if username & password match
        $stmt = $conn->prepare('SELECT id, password FROM user WHERE name = ?');
        $stmt->bind_param('s', $username);
        $stmt->execute();
        $stmt->store_result();
        
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($id, $password);
            $stmt->fetch();
            
            if ($_POST['password'] === $password) {
                session_regenerate_id();
                $_SESSION['loggedin'] = TRUE;
                $_SESSION['username'] = $username;
                $_SESSION['id'] = $id;

                $success_message = "Welcome " . $username . "! :)";
                header('Location: index.php');
            } else {
                $error_message = "incorect password!";
            }
        } else {
            $error_message = "incorect username!";
        }

        $stmt->close();
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

            <h1>Login</h1>

            <?php // Display Error message
            if (!empty($error_message)) { ?>
                <div class="alert alert-danger">
                <strong>Error!</strong> <?= $error_message ?>
                </div>
            <?php } ?>

            <!-- TODO: handle this shit -->
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

            <button type="submit" name="btnlogin" class="btn btn-default">Submit</button>
          </form>
        </div>

     </div>
    </div>
  </body>
</html>