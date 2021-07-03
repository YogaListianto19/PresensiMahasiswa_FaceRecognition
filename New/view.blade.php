@extends('main')
@section('content')
<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">Manage User</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="#">Home</a></li>
          <li class="breadcrumb-item active">{{ $title }}</li>
        </ol>
      </div><!-- /.col -->
    </div><!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content-header -->

<!-- Main content -->
<section class="content">

  <div class="row">
    <div class="col-12">

      <div class="card">
        <div class="card-header">
          <h3 class="card-title">{{ $title }}</h3>
          <div class="card-tools">
            <div class="input-group input-group-sm" style="width: 95px;">
                <button id="addBtn" class="btn btn-success btn-sm"><i class="fa fa-plus"></i> Add New</button>
            </div>
          </div>
        </div>

        @if(Session::get('alert-success') || Session::get('alert-failed'))
          <div class="card-body notif-message">
            @if(!empty(Session::get('alert-success')))
              <div class="alert alert-success alert-dismissible">
            @else
              <div class="alert alert-danger alert-dismissible">
            @endif
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
              <h5><i class="icon fas fa-check"></i> Alert! </h5>
              @if(!empty(Session::get('alert-success')))
                {{ Session::get('alert-success') }}
              @else
                {{ Session::get('alert-failed') }}
              @endif
            </div>
          </div>
        @endif

        <div class="col-md-12" id="loadBar" style="display: none;">
          <br>
          <center><i class="fa fa-spinner fa-spin"></i></center>
        </div>

        <div class="card-body" id="addForm" style="display: none;">
          <div class="card card-secondary">
              <div class="card-header">
                <h3 class="card-title">Add New</h3>
              </div>
              <!-- /.card-header -->
              <!-- form start -->
              <form class="form-horizontal" role="form" action="{{ url('/user-add')}}" method="post" enctype="multipart/form-data">
                <div class="card-body">
                  <div class="form-group row">
                    <label class="col-sm-2 col-form-label">Username</label>
                    <div class="col-sm-10">
                      <input type="text" class="form-control" name="username" required>
                    </div>
                  </div>
                  <div class="form-group row">
                    <label class="col-sm-2 col-form-label">Password</label>
                    <div class="col-sm-10">
                      <input type="password" class="form-control" name="password" required>
                    </div>
                  </div>
                  <div class="form-group row">
                    <label class="col-sm-2 col-form-label">Email</label>
                    <div class="col-sm-10">
                      <input type="email" class="form-control" name="email" required>
                    </div>
                  </div>
                  <div class="form-group row">
                    <label class="col-sm-2 col-form-label">Fullname</label>
                    <div class="col-sm-10">
                      <input type="text" class="form-control" name="fullname" required>
                    </div>
                  </div>
                  <div class="form-group row">
                    <label class="col-sm-2 col-form-label">Image</label>
                    <div class="col-sm-10">
                      <!-- <?php if(!empty($data['image'])){ ?>
                        <img src ="{{$data['image']}}" width="100">
                        <input type="hidden" name="imageOld" value="{{$data['image']}}">
                      <?php } ?> -->
                      <div id="image_preview">
                        
                      </div>
                      <input type="file" name="image" class="form-control" onchange="preview_image()">
                    </div>
                  </div>
                  <div class="form-group row">
                    <label class="col-sm-2 col-form-label">Role</label>
                    <div class="col-sm-10">
                      <select name="role_id" id="role_id" class="form-control" required>
                        <option value="" disabled selected>-- Please Select --</option>
                        <?php foreach ($data_role as $drole) { ?>
                          <option value=<?php echo $drole['id']; ?>><?php echo $drole['role_name']; ?></option>
                        <?php } ?>
                      </select>
                    </div>
                  </div>
                  <div class="form-group row"  id="company_id" style="display: none;">
                    <label class="col-sm-2 col-form-label">Company</label>
                    <div class="col-sm-10">
                      <select name="company_id" id ="companys" class="form-control" @if(Session::has('LarAdminCL.company')) disabled="disabled" @endif>
                        <option value="" disabled selected>-- Please Select --</option>
                        <?php foreach ($company as $row) { ?>
                          <option value={{$row['company_id']}} @if(Session::has('LarAdminCL.company'))  @if(Session::get('LarAdminCL.company.company_id')==$row['company_id']) selected="selected" @endif @endif>{{$row['company_name']}}</option>
                        <?php } ?>
                      </select>
                      
                      @if(Session::has('LarAdminCL.company')) <input type="text" class="form-control" name="company_id" value="{{Session::get('LarAdminCL.company.company_id')}}" style="display:none">@endif
                    </div>
                  </div>
                  <div class="form-group row" id="event_id"  style="display: none;">
                    <label class="col-sm-2 col-form-label">Event</label>
                    <div class="col-sm-10">
                      <select name="event_id" id="event"class="form-control" >
                        <option value="" disabled selected>-- Please Select --</option>
                        <?php foreach ($event as $raw) { ?>
                          <option value={{$raw['id']}}>{{$raw['event_name']}}</option>
                        <?php } ?>
                      </select>
                    </div>
                  </div>
                </div>
                <!-- /.card-body -->
                <div class="card-footer">
                  <button type="submit" class="btn btn-info">Submit</button>
                  <button id="cancelBtn" type="button" class="btn btn-default float-right">Cancel</button>
                </div>
                <!-- /.card-footer -->
              </form>
            </div>
        </div>

        <div id="editForm"></div>

        <div class="card-body" id="table">
          <table id="example1" class="table table-bordered table-striped">
            <thead>
              <tr>
                <th>No</th>
                <th>Username</th>
                <th>Email</th>
                <th>FullName</th>
                <th>Role Name</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
            <?php
              if(!empty($data)){
                $no = 1;
                foreach ($data as $datas) {
            ?>
            <tr>
              <td><?php echo $no; ?></td>
              <td><?php echo $datas['username']; ?></td>
              <td><?php echo $datas['email']; ?></td>
              <td><?php echo $datas['fullname']; ?></td>
              <td><?php $key = array_search($datas['role_id'], array_column($data_role, 'id')); echo $data_role[$key]['role_name'];?></td>
              <td>
                @if($datas['id']==session('LarAdminCL')['admin_id'])
                <a class="btn btn-warning" href="{{ url('') }}/user-edit-profile/{{ session('LarAdminCL')['admin_id'] }}"><i class="fa fa-edit"></i></a>
                @else
                  <button class="btn btn-warning" onclick="editData('<?php echo $datas['id'] ?>','{{ url('/user-edit/') }}')"><i class="fa fa-edit"></i></button>
                @endif
                <button class="btn btn-danger" onclick="del_confirm('Are you sure to delete <?php echo $datas["fullname"];?> from User?','{{ url('/user-delete')}}/{{$datas['id'] }}')"><i class="fa fa-trash"></i></button>
              </td>
            </tr>
          <?php
            $no++; }
          }
          ?>
            </tbody>
          </table>
        </div>

      </div>
      <!-- /.card -->
    </div>
    <!-- /.col -->
  </div>
  <!-- /.row -->

</section>

<!-- <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script> -->
<script>

  $('#role_id').on('change', function() {
      var data = $('#role_id').val();
      if (data  ===  '16'){
          document.getElementById("company_id").style.display = "flex";
          document.getElementById("event_id").style.display = "flex";
      }else if(data=='20'){
        document.getElementById("company_id").style.display = "flex";
      }
      else{
          document.getElementById("event_id").style.display = "none";
          document.getElementById("company_id").style.display = "none";
      }
  });

  @if(Session::has('alert-success') || Session::has('alert-failed'))
    $('.notif-message').delay(4000).fadeOut(400);
  @endif

  function del_confirm(msg,url){
    priv = "<?php echo priv("delete"); ?>";
		if (priv != '')	{		
			alert(priv);		
		}else	{
			if(confirm(msg)){
        window.location.href=url
      }else{
        false;
      }
		}    
  }

  $(function () {
    $("#example1").DataTable();
  });

  //   $(document).ready(function(){
  //     $('#submitBtn').click(function(){
  //       var pass1 = $('#password').val();
  //       var pass2 = $('#password2').val();
  //       if(pass1 == pass2){
  //         return true;
  //       }else{
  //         swal('!','Password not match','error');
  //         return false;
  //       }
  //     });
  //   });

  function editData(id,url){
    priv = "<?php echo priv("edit"); ?>";
		if (priv != '')	{		
			alert(priv);		
		}else{
      $.ajax({
        url:url+'/'+id,
        type:'GET',
        dataType:'HTML',
        beforeSend:function(){
          $('#editForm').empty();
          $('#addBtn').fadeOut();
          $('#loadBar').show();
        },
        success:function(data){
          $('#loadBar').hide();
          $('#addForm').fadeOut();
          $('#table').fadeOut();
          $('#editForm').append(data);
          $('#editForm').fadeIn();
        },
        error:function(data) {
          $('#loadBar').hide();
          alert(url+'/'+id);
          alert(data);
          alert('500 : Internal server error');
        }
      });
    }
  }

  $('#cancelBtn').click(function(){
    $('#editForm').fadeOut();
    $('#editForm').empty();
    $('#addBtn').fadeIn();
  });

  $('#addBtn').click(function(){
    priv = "<?php echo priv("add"); ?>";
		if (priv != '')	{		
			alert(priv);		
		}else	{
      $('#addBtn').fadeOut();
			$('#table').fadeOut();
      $('#addForm').fadeIn();
    }
  });

  $('#cancelBtn').click(function(){
    $('#addForm').fadeOut();
		$('#table').fadeIn();
  });

  function preview_image() {
    $('#image_preview').empty();
    $('#image_preview').append("<img src='"+URL.createObjectURL(event.target.files[0])+"' width='150px' style='border-radius: 2px;'> &nbsp");
  }
</script>
@endsection
