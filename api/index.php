<?php include 'includes/nav.php';?>
<div class="container bg-light p-3 my-3 rounded border">
<?php
if(isset($_POST['submit'])){
    $name = $_POST['name'];
    $freq = $_POST['freq'];
    $url = $_POST['url'];
    $password = $_POST['password'];

    if(hash("gost", $password) == $mypassword){
        $check = mysqli_query($db , "SELECT * FROM `radio` WHERE `freq`  = '$freq' OR `url` = '$url'");
        if(mysqli_num_rows($check) == 0){
        $query = mysqli_query($db , "INSERT INTO `radio` (`name`, `freq`, `url`) VALUES ('$name','$freq','$url')");
        if($query){
            return header("Location: index.php?success");
        }else{
            return header("Location: index.php");
        }
    }else{
        return header("Location: index.php?exists");
    }
    }else{
        return header("Location: index.php");
    }
}

if(isset($_POST['delete'])){
    $id= $_POST['id'];
    $password = $_POST['password'];
    if(hash("gost", $password) == $mypassword){
      $query = mysqli_query($db , "DELETE FROM `radio` WHERE `id` = '$id'");
      return header("Location: index.php?delete");
    }
}
?>
<h1>Add Channel To APP</h1>
<br>
<?php if(isset($_GET['delete'])){?>
            <p class="alert alert-danger">Deleted !</p>
    <?php } ?>
<form action="index.php" method="post">
    <input type="text" placeholder="Name" name="name" class="form-control p-3 ">
    <br>
    <input type="text" placeholder="Freq" name="freq" class="form-control p-3">
    <br>
    <input type="text" placeholder="url" name="url" class="form-control p-3">
    <br>
    <input type="password" placeholder="password" name="password" class="form-control p-3">
    <br>
    <?php if(isset($_GET['success'])){?>
            <p class="text-success">Created !</p>
    <?php } ?>
    <?php if(isset($_GET['exists'])){?>
            <p class="text-danger">Exists !</p>
    <?php } ?>

    <button name="submit" class="btn btn-primary btn-lg">Create Channel</button>
</form>
<table class="table table-borderless table-striped table-hover my-4">
  <thead>
    <tr>
      <th scope="col">Name</th>
      <th scope="col">Freq</th>
      <th scope="col">URL</th>
      <th scope="col">Delete</th>
    </tr>
  </thead>
  <tbody>
      <?php
$query = mysqli_query($db , "SELECT * FROM `radio` ORDER BY `id` DESC");
while($row = mysqli_fetch_assoc($query)){?>
    <tr>
      <td><?php echo $row['name'];?></td>
      <td><?php echo $row['freq'];?></td>
      <td><a href="<?php echo $row['url'];?>"><?php echo $row['url'];?></a></td>
      <td><span style="cursor: pointer;" class="text-danger" data-bs-toggle="modal" data-bs-target="#delete<?php echo $row['id'];?>">Delete</span></td>

<div class="modal fade" id="delete<?php echo $row['id'];?>" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
      <form method="POST" action="index.php">
    <div class="modal-content">
      <div   class="modal-body">
      <input type="hidden" name="id" value="<?php echo $row['id'];?>">
      <input type="password" placeholder="password" name="password" class="form-control p-3">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" name="delete" class="btn btn-danger">Delete Channel</button>
      </div>
    </div>
    </form>
  </div>
</div>
    </tr>
    <?php } ?>
  </tbody>
</table>
</div>