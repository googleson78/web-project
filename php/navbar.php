<nav class="navbar navbar-default">
	<div class="container-fluid">

		<!-- Brand/logo -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#example-1" aria-expanded="false">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#">The Haskell / FP Religion</a>
		</div>

		<!-- Collapsible Navbar -->
		<div class="collapse navbar-collapse" id="example-1">
			<ul class="nav navbar-nav">
				<!-- TODO: show only when logged in -->
				<li><a href="/view/tasks.php">view tasks</a></li>
				<li><a href="/submit/task.php">submit task</a></li>

                <?php if (isset($_SESSION['loggedin'])) {?>
				    <li><a href="/index.php">home</a></li>
				    <li><a href="/logout.php">logout</a></li>
                <?php } else { ?>
                    <li><a href="/login.php">login</a></li>
                    <li><a href="/register.php">register</a></li>
                <?php } ?>
			</ul>
		</div>

	</div>
</nav>
