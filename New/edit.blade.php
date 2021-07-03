<div class="card-body">
  <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Edit </h3>
      </div>
      <!-- /.card-header -->
      <!-- form start -->
      <form class="form-horizontal" role="form" action="{{ url('/user-update',$data['id']) }}" method="post" enctype="multipart/form-data">
        <!-- text input -->
        <div class="card-body">
          <div class="form-group row">
            <label class="col-sm-2 col-form-label">Username</label>
            <div class="col-sm-10">
              <input type="text" class="form-control" name="username" value="<?php echo $data['username']; ?>" required>
            </div>
          </div>
          <div class="form-group row" style="display: none;">
            <label class="col-sm-2 col-form-label">Password</label>
            <div class="col-sm-10">
              <input type="password" class="form-control" name="password" value="">
            </div>
          </div>
          <div class="form-group row">
            <label class="col-sm-2 col-form-label">Email</label>
            <div class="col-sm-10">
              <input type="email" class="form-control" name="email" value="<?php echo $data['email']; ?>" required>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-sm-2 col-form-label">Fullname</label>
            <div class="col-sm-10">
              <input type="text" class="form-control" name="fullname" value="<?php echo $data['fullname']; ?>" required>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-sm-2 col-form-label">Image</label>
            <div class="col-sm-10">             
              <div id="image_preview_edit">                
                  <img src ="{{ $data['image'] }}" width="150px;" style="border-radius: 2px;' ">
              </div>
              <input type="file" name="image" class="form-control" onchange="preview_image_edit()">
            </div>
          </div>
          <div class="form-group row">
            <label class="col-sm-2 col-form-label">Role</label>
            <div class="col-sm-10">
              <select name="role_id" id="role_id" class="form-control" required>
                <option value="" disabled selected>-- Please Select --</option>
                <?php foreach ($data_role as $drole) { ?>
          				<option value=<?php echo $drole['id']; ?>
          					<?php if($data['role_id']) { ?>
          					<?php if($drole['id'] == $data['role_id']) { ?>
          						selected
          					<?php } ?>
          					<?php } ?>
          				><?php echo $drole['role_name']; ?></option>
          			<?php } ?>
              </select>
            </div>
          </div>
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
          <button type="submit" class="btn btn-info">Submit</button>
          <button id="cancelBtnEdit" type="button" class="btn btn-default float-right">Cancel</button>
        </div>
        <!-- /.card-footer -->
      </form>
    </div>
</div>

<script>
  $('#cancelBtnEdit').click(function(){
    $('#editForm').fadeOut();
    $('#editForm').empty();
    $('#addBtn').fadeIn();
    $('#table').fadeIn();
  });
  
  function preview_image_edit() {
    $('#image_preview_edit').empty();
    $('#image_preview_edit').append("<img src='"+URL.createObjectURL(event.target.files[0])+"' width='150px' style='border-radius: 2px;'> &nbsp");
  }
</script>
