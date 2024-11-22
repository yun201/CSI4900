--  with Ada.Numerics.Elementary_Functions;  
--  with Raylib;
--  with Resources;
--  with Examples_Config;
--  with Interfaces.C; use Interfaces.C;
--  with Interfaces.C.Strings;
--  with Ada.Text_IO;
--  pragma Extensions_Allowed (all);

--  procedure Examples is

--     subtype CFloat is Interfaces.C.C_float;

--     function Lerp (start, stop, alpha : CFloat) return CFloat is
--        (start + (stop - start) * alpha);

   
--     package Example_Resources is new Resources (Examples_Config.Crate_Name);
--     use Example_Resources;

--     DEG2RAD : constant CFloat := CFloat(3.14159265359 / 180.0);

--     screenWidth  : constant := 800;
--     screenHeight : constant := 450;

--     Cam : aliased Raylib.Camera3D;
--     Dt : CFloat;


--     Ray : Raylib.Ray := ((0.0, 0.0, 0.0), (0.0, 0.0, 0.0));
--     Collision : Raylib.RayCollision :=
--       (False, 0.0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0));

--     Model : Raylib.Model;
--     Texture : Raylib.Texture;
--     Music : Raylib.Music;
--     Sound : Raylib.Sound;

--     Car_Rot_Angle : Cfloat := 0.0;
--     Car_Position : Raylib.Vector3 := (-25.0, 5.0, 0.0);
--     Car_Speed : CFloat := 0.2;


     


--  begin
--     Raylib.InitWindow (screenWidth, screenHeight, "Example window");

--     Raylib.InitAudioDevice;

--     Model := Raylib.LoadModel (Resource_Path & "race_track.obj");
--     Texture := Raylib.LoadTexture (Resource_Path & "race_track.png");
--     Model.materials.maps (Raylib.MATERIAL_MAP_ALBEDO).texture_f := Texture;
   
--     -- Initialize the bounding box for the track
--     Track_BBox : Raylib.BoundingBox := Raylib.GetModelBoundingBox(Model);

--     -- Adjust bounding box based on model scaling and position
--     Track_BBox.Min.x := Track_BBox.Min.x * 2.0 + 10.0;
--     Track_BBox.Max.x := Track_BBox.Max.x * 2.0 + 10.0;
--     Track_BBox.Min.y := Track_BBox.Min.y * 2.0;
--     Track_BBox.Max.y := Track_BBox.Max.y * 2.0;
--     Track_BBox.Min.z := Track_BBox.Min.z * 2.0;
--     Track_BBox.Max.z := Track_BBox.Max.z * 2.0;


--     Car_Model : Raylib.Model := Raylib.LoadModel (Resource_Path & "car/scene.gltf");
--     Car_BBox : Raylib.BoundingBox;
--     Previous_Position : Raylib.Vector3 := Car_Position;

--     Music := Raylib.LoadMusicStream (Resource_Path & "/S31-The Gears of Progress.ogg");

--     Music := Raylib.LoadMusicStream
--       (Resource_Path & "/S31-The Gears of Progress.ogg");
--     Raylib.SetMusicVolume (Music, 0.1);
--     Raylib.PlayMusicStream (Music);

--     Sound := Raylib.LoadSound (Resource_Path & "/sd_0.wav");

--     Cam.position := (-25.0, 20.0, 10.0);
--     Cam.target := (0.0, 0.0, 0.0);
--     Cam.up := (0.0, 1.0, 0.0);
--     Cam.fovy := 45.0;
--     Cam.projection := Raylib.CAMERA_PERSPECTIVE;



--     Raylib.DisableCursor;
--     Raylib.SetTargetFPS (60);

--     while not Raylib.WindowShouldClose loop

--        Raylib.UpdateMusicStream (Music);

--        Dt := Raylib.GetFrameTime;

--        Previous_Position := Car_Position;

--        -- Flag to indicate whether to reset position
--        Collision_Occurred : Boolean := False;

   
--        -- Detect left and right turn keys and update Car_Rot_Angle
--        if Raylib.IsKeyDown(Raylib.KEY_G) then
--           Car_Rot_Angle := Car_Rot_Angle + CFloat(2.0);  -- Left turn
--        elsif Raylib.IsKeyDown(Raylib.KEY_J) then
--           Car_Rot_Angle := Car_Rot_Angle - CFloat(2.0);  -- Right turn
--        end if;



--        -- Process key input to update Car_Position
--        if Raylib.IsKeyDown(Raylib.KEY_Y) then
--           Car_Position.x := Car_Position.x + Car_Speed * CFloat(Ada.Numerics.Elementary_Functions.Sin(Float(Car_Rot_Angle) * Float(DEG2RAD)));
--           Car_Position.z := Car_Position.z + Car_Speed * CFloat(Ada.Numerics.Elementary_Functions.Cos(Float(Car_Rot_Angle) * Float(DEG2RAD)));
--        elsif Raylib.IsKeyDown(Raylib.KEY_H) then
--           Car_Position.x := Car_Position.x - Car_Speed * CFloat(Ada.Numerics.Elementary_Functions.Sin(Float(Car_Rot_Angle) * Float(DEG2RAD)));
--           Car_Position.z := Car_Position.z - Car_Speed * CFloat(Ada.Numerics.Elementary_Functions.Cos(Float(Car_Rot_Angle) * Float(DEG2RAD)));
--        end if;

--        -- Update car bounding box
--        Car_BBox.Min := (Car_Position.x - 1.0, Car_Position.y - 0.5, Car_Position.z - 1.0);
--        Car_BBox.Max := (Car_Position.x + 1.0, Car_Position.y + 0.5, Car_Position.z + 1.0);

--        -- Collision detection: reset position if car bounding box exceeds specified range 
--        --There's an "Invisible wall" issue, collision detection doesn't cover the entire model
--        if Raylib.CheckCollisionBoxes(Car_BBox, Track_BBox) then
--           --Additional condition checks, such as detecting if out of Z axis range
--           if Car_Position.z < Track_BBox.Min.z or Car_Position.z > Track_BBox.Max.z then
--             Car_Position := Previous_Position;
--              Collision_Occurred := True;
--           else
--              Collision_Occurred := False;
--           end if;
--        else
--           Collision_Occurred := False;
--        end if;

--        -- Reset position only if collision occurred
--        if Collision_Occurred then
--           Car_Position := Previous_Position;
--        end if;

--        -- Update camera position and target
--        Cam.position := (
--           Lerp(Cam.position.x, Car_Position.x - CFloat(10.0) * CFloat(Ada.Numerics.Elementary_Functions.Sin(Float(Car_Rot_Angle) * Float(DEG2RAD))), CFloat(0.1)),
--           Lerp(Cam.position.y, CFloat(10.0), CFloat(0.1)),  -- Camera height
--           Lerp(Cam.position.z, Car_Position.z - CFloat(10.0) * CFloat(Ada.Numerics.Elementary_Functions.Cos(Float(Car_Rot_Angle) * Float(DEG2RAD))), CFloat(0.1))
--        );

--        Cam.target := (
--           Lerp(Cam.target.x, Car_Position.x, CFloat(0.1)),
--           Lerp(Cam.target.y, Car_Position.y, CFloat(0.1)),
--           Lerp(Cam.target.z, Car_Position.z, CFloat(0.1))
--        );

--        if Raylib.IsMouseButtonPressed (Raylib.MOUSE_BUTTON_RIGHT) then
--           if Raylib.IsCursorHidden then
--              Raylib.EnableCursor;
--           else
--              Raylib.DisableCursor;
--           end if;
--        end if;


      


--        Raylib.BeginDrawing;

--        Raylib.ClearBackground (Raylib.RAYWHITE);

--        Raylib.BeginMode3D (Cam);

--        --Raylib.DrawModel (Model, (-20.0, 0.0, -20.0), 0.6, Raylib.WHITE);
--        Raylib.DrawModelEx ( Model, (10.0, 0.0, 0.0), (0.0, 0.7071068, 0.7071068), 180.0, (2.0, 2.0, 2.0) , Raylib.WHITE);
--        declare
--                 Rot_Axis : Raylib.Vector3 := (0.0, 1.0, 0.0);
--                 Scale : Raylib.Vector3 := (0.5, 0.5, 0.5);
--              begin
--                 Raylib.DrawModelEx(Car_Model, Car_Position , Rot_Axis, Car_Rot_Angle, Scale, Raylib.WHITE);
--              end;



--        Raylib.DrawRay (Ray, Raylib.RED);
    

--        Raylib.DrawGrid (10, 1.0);

--        Raylib.EndMode3D;

--        Raylib.DrawText ("Try clicking on the box with your mouse!",
--                         240, 10, 20, Raylib.DARKGRAY);

--        if Collision.hit then
--           Raylib.DrawText
--             ("BOX SELECTED",
--              (screenWidth - Raylib.MeasureText ("BOX SELECTED", 30)) / 2,
--              int (screenHeight * 0.1), 30,
--              Raylib.GREEN);
--        end if;

--        Raylib.DrawText ("Right click mouse to toggle camera controls",
--                         10, 430, 10, Raylib.GRAY);

--        Raylib.DrawFPS (10, 10);
--        Raylib.EndDrawing;
--     end loop;

--     Raylib.UnloadMusicStream (Music);
--     Raylib.UnloadSound (Sound);

--     Raylib.CloseWindow;
--  end Examples;




with Raylib;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions;  -- 导入数学库

procedure Raylib_Gym is
   
     -- 定义 DEG2RAD 常量
   DEG2RAD : constant Float := 3.14159265359 / 180.0;
   pp1:Raylib.Vector3;   
   pp2:Raylib.Vector3;

   subtype CFloat is Interfaces.C.C_float;

   function Lerp (start, stop, alpha : CFloat) return CFloat is
      (start + (stop - start) * alpha);

   function rotateY_X(x0,z0,alpha :Float) return Float is
   --begin      
      --a:Float:=alpha * DEG2RAD;
      --v:Float;
      --p:Raylib.Vector3:=(x0,0,z0);
      --p.x:=p0.x*Ada.Numerics.Elementary_Functions.Cos(a)-p0.z*Ada.Numerics.Elementary_Functions.Sin(a)
      --p.z:=p0.x*Ada.Numerics.Elementary_Functions.Sin(a)+p0.z*Ada.Numerics.Elementary_Functions.Cos(a)        Interfaces.C.C_float
      ((x0)*Ada.Numerics.Elementary_Functions.Cos(alpha * DEG2RAD)-(z0)*Ada.Numerics.Elementary_Functions.Sin(alpha * DEG2RAD));
      --return v;
   --end;


   function rotateY_Z(x0,z0,alpha :Float) return Float is
   --begin      
      --a:Float:=alpha * DEG2RAD;
      --v:Float;
      --p:Raylib.Vector3:=(x0,0,z0);
      --p.x:=p0.x*Ada.Numerics.Elementary_Functions.Cos(a)-p0.z*Ada.Numerics.Elementary_Functions.Sin(a)
      --p.z:=p0.x*Ada.Numerics.Elementary_Functions.Sin(a)+p0.z*Ada.Numerics.Elementary_Functions.Cos(a)        Interfaces.C.C_float
      ((x0)*Ada.Numerics.Elementary_Functions.Sin(alpha * DEG2RAD)+(z0)*Ada.Numerics.Elementary_Functions.Cos(alpha * DEG2RAD));
      --return v;
   --end;


   function rotateY(x0,y0,z0,alpha :Float) return  Raylib.Vector3  is
      (Interfaces.C.C_float(rotateY_X(x0,z0,alpha))
      ,Interfaces.C.C_float(y0)
      ,Interfaces.C.C_float(rotateY_Z(x0,z0,alpha))
      );

   function rotateY2(p0:Raylib.Vector3;alpha :Float) return  Raylib.Vector3  is
      (rotateY(Float(p0.x),Float(p0.y),Float(p0.z),alpha));

   function add_vec3(v1,v2:Raylib.Vector3) return  Raylib.Vector3  is
      (
         v1.x+v2.x,
         v1.y+v2.y,
         v1.z+v2.z         
      );

   function sub_vec3(v1,v2:Raylib.Vector3) return  Raylib.Vector3  is
      (
         v1.x-v2.x,
         v1.y-v2.y,
         v1.z-v2.z         
      );

   function scale_vec3(v1:Raylib.Vector3;s:Float) return  Raylib.Vector3  is
      ( v1.x*Interfaces.C.C_float(s),
        v1.y*Interfaces.C.C_float(s),
        v1.z*Interfaces.C.C_float(s)
      );

   function normalize(v1:Raylib.Vector3) return  Raylib.Vector3  is
      ( v1.x/Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.sqrt(Float(v1.x*v1.x+v1.y*v1.y+v1.z*v1.z))),
        v1.y/Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.sqrt(Float(v1.x*v1.x+v1.y*v1.y+v1.z*v1.z))),
        v1.z/Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.sqrt(Float(v1.x*v1.x+v1.y*v1.y+v1.z*v1.z)))
      );

   function Vector3CrossProduct(v1,v2:Raylib.Vector3) return  Raylib.Vector3  is
      (normalize( (v1.y*v2.z-v1.z*v2.y,
        v1.z*v2.x-v1.x*v2.z,
        v1.x*v2.y-v1.y*v2.x)
      ));

   procedure DrawRectangle(v0,v1,v2:Raylib.Vector3;high:Float;aColor: Raylib.Color ) is
   begin
      pp1:=add_vec3(v1,scale_vec3((0.0,1.0,0.0),high));
      pp2:=add_vec3(v2,scale_vec3((0.0,1.0,0.0),high));
      Raylib.DrawLine3D(pp1,pp2,aColor);
      pp1:=sub_vec3(v1,scale_vec3((0.0,1.0,0.0),high));
      pp2:=sub_vec3(v2,scale_vec3((0.0,1.0,0.0),high));
      Raylib.DrawLine3D(pp1,pp2,aColor);
   end;


   screenWidth  : constant := 800;
   screenHeight : constant := 450;
   Cam : aliased Raylib.Camera3D;

   CarMatrix:Raylib.Matrix;

   Car : Raylib.Model;
   Race_Track : Raylib.Model;

   Outer_Boundary : Raylib.Model;
   Outer_Boundary_Mesh : Raylib.Mesh;

   aBox_Color : Raylib.Color :=(0,121,241,255);
   aCarBox_Color : Raylib.Color :=(255,0,0,255);
   Inner_Boundary : Raylib.Model;
   Inner_Boundary_Mesh : Raylib.Mesh;
   
   Inner_BBox: Raylib.BoundingBox;
   Outer_BBox: Raylib.BoundingBox;
   car_BBox: Raylib.BoundingBox;
   car_BBox_move: Raylib.BoundingBox;
   World_Pos : Raylib.Vector3 := (0.0, 0.0, 0.0);
   World_Rot_Axis : Raylib.Vector3 := (0.0, 1.0, 0.0);
   World_Scale : Raylib.Vector3 := (0.2, 0.2, 0.2);

   Dt : CFloat;
   P0:Raylib.Vector3 := (0.0, 0.0, 0.0);
   P1:Raylib.Vector3 := (0.0, 0.0, 0.0);
   P2:Raylib.Vector3 := (0.0, 0.0, 0.0);
   Car_Rot_Angle : Cfloat := 0.0;

   Center_BB_Size : Raylib.Vector3 := (1.0, 1.0, 1.0);
   Center_BB_Pos : Raylib.Vector3 := (-Center_BB_Size.x / 2.0, 
                                      0.0, 
                                      -Center_BB_Size.z / 2.0);

   Center_BB : Raylib.BoundingBox := ((0.0, 0.0, 0.0), (100.0, 100.0, 100.0));


    -- 新增汽车位置变量
   Car_Position : Raylib.Vector3 := (0.0, 0.0, 0.0);  -- 初始汽车位置
   Car_Speed : Float := 0.5;  -- 汽车每帧移动的距离
   Car_Rotation : Float := 0.0;  -- 汽车的初始旋转角度（Y 轴方向）
   Car_Forward: Raylib.Vector3 := (0.0, 0.0, 1.0);   --向前的方向
   Car_Left: Raylib.Vector3 := (0.0, 0.0, 1.0);   --向前左的方向


   Car_L:Interfaces.C.C_float := 0.2;  
   Car_W:Interfaces.C.C_float := 0.2;  
   Car_H:Interfaces.C.C_float := 0.2;  
   
begin
 
   Raylib.InitWindow (screenWidth, screenHeight, New_String ("Raylib Gym"));
   
   Car := Raylib.LoadModel (New_String ("C:\CSI4900\raylib-ada\examples\share\examples\data\race_car.gltf"));
   Race_Track := Raylib.LoadModel (New_String ("C:\CSI4900\raylib-ada\examples\share\examples\data\race_track.gltf"));

   Outer_Boundary := Raylib.LoadModel (New_String ("C:\CSI4900\raylib-ada\examples\share\examples\data\outer_boundary.gltf"));
   Outer_Boundary_Mesh := Outer_Boundary.meshes.all;   
   Inner_Boundary := Raylib.LoadModel (New_String ("C:\CSI4900\raylib-ada\examples\share\examples\data\inner_boundary.gltf"));

   Outer_BBox:= Raylib.GetModelBoundingBox(Outer_Boundary);
   car_BBox:= Raylib.GetModelBoundingBox(Car);
   Inner_BBox:= Raylib.GetModelBoundingBox(Inner_Boundary);


   car_BBox.min:=(car_BBox.min.x* 0.1,car_BBox.min.y* 0.1,car_BBox.min.z* 0.1);
   car_BBox.max:=(car_BBox.max.x* 0.1,car_BBox.max.y* 0.1,car_BBox.max.z* 0.1);
      
   
   Car_W:=(car_BBox.max.x - car_BBox.min.x)/2.0;
   Car_L:=(car_BBox.max.z - car_BBox.min.z)/2.0;  
   Car_H:=(car_BBox.max.y - car_BBox.min.y)/2.0;  
   if Car_L<0.0 then
      Car_L:=Car_L;
   end if;
   if Car_W<0.0 then
      Car_W:=-Car_W;
   end if;
   if Car_H<0.0 then
      Car_H:=Car_H;
   end if;

   Inner_BBox.min:=(Inner_BBox.min.x* 0.2,Inner_BBox.min.y* 0.2,Inner_BBox.min.z* 0.2);
   Inner_BBox.max:=(Inner_BBox.max.x* 0.2,Inner_BBox.max.y* 0.2,Inner_BBox.max.z* 0.2);
   
   Outer_BBox.min:=(Outer_BBox.min.x* 0.2,Outer_BBox.min.y* 0.2,Outer_BBox.min.z* 0.2);
   Outer_BBox.max:=(Outer_BBox.max.x* 0.2,Outer_BBox.max.y* 0.2,Outer_BBox.max.z* 0.2);
   

   -- RUN THE EXECUTABLE FROM THE ROOT OF THE PROJECT -> bin/raylib_gym

   Cam.position := (10.0, 10.0, 10.0);
   Cam.target := (0.0, 0.0, 0.0);
   Cam.up := (0.0, 1.0, 0.0);
   Cam.fovy := 45.0;
   -- Cam.projection := Interfaces.C.int (Raylib.CAMERA_PERSPECTIVE);
   Cam.projection := Raylib.CAMERA_PERSPECTIVE;
   -- Raylib.DisableCursor;
   Raylib.SetTargetFPS (60);
   Car_Position:=(0.0, 0.0, 0.0);

   while not Raylib.WindowShouldClose loop
      Raylib.BeginDrawing;

      -- WORKING in 2D. So 0,0 is the top left corner. (ScreenSpace)

      Raylib.ClearBackground (Raylib.RAYWHITE);

      Raylib.BeginMode3D (Cam);

      -- WORKING in 3D. So 0,0 is the center of the grid. (WorldSpace)

      --Raylib.DrawModelEx (Race_Track,     World_Pos, World_Rot_Axis, 0.0, World_Scale, Raylib.WHITE);
      Raylib.DrawModelEx (Outer_Boundary, World_Pos, World_Rot_Axis, 0.0, World_Scale, Raylib.GRAY);
      Raylib.DrawModelEx (Inner_Boundary, World_Pos, World_Rot_Axis, 0.0, World_Scale, Raylib.GRAY);

      Raylib.DrawBoundingBox(Outer_BBox, aBox_Color);
      Raylib.DrawBoundingBox(Inner_BBox, aBox_Color);

      declare
         Pos : Raylib.Vector3 :=Car_Position;
         Rot_Axis : Raylib.Vector3 :=(0.0, 1.0, 0.0);
         Scale : Raylib.Vector3 := (0.1, 0.1, 0.1);
      begin
         Dt := 5.0 * Raylib.GetFrameTime;

         Car_Forward.x:=Interfaces.C.C_float( Ada.Numerics.Elementary_Functions.Sin(Car_Rotation * DEG2RAD));
         Car_Forward.z:=Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.Cos(Car_Rotation * DEG2RAD));

         -- 向前移动
         if Raylib.IsKeyDown(Raylib.KEY_Y) then
            -- 前进应该减小 Z 轴的值，因为前进是沿着负 Z 轴方向
            --Car_Position.z := Car_Position.z + Interfaces.C.C_float(Float(Car_Speed) * Ada.Numerics.Elementary_Functions.Cos(Car_Rotation * DEG2RAD));
            --Car_Position.x := Car_Position.x - Interfaces.C.C_float(Float(Car_Speed) * Ada.Numerics.Elementary_Functions.Sin(Car_Rotation * DEG2RAD));
         
            Car_Position.z := Car_Position.z  +  Interfaces.C.C_float(Float(Car_Speed) * Float(Dt)* Float(Car_Forward.z));
            Car_Position.x := Car_Position.x  +  Interfaces.C.C_float(Float(Car_Speed) * Float(Dt)* Float(Car_Forward.x));
         end if;

         -- 向后移动
         if Raylib.IsKeyDown(Raylib.KEY_H) then
            -- 后退应该增加 Z 轴的值，因为后退是沿着正 Z 轴方向
            --Car_Position.z := Car_Position.z - Interfaces.C.C_float(Float(Car_Speed) * Ada.Numerics.Elementary_Functions.Cos(Car_Rotation * DEG2RAD));
            -- Car_Position.x := Car_Position.x + Interfaces.C.C_float(Float(Car_Speed) * Ada.Numerics.Elementary_Functions.Sin(Car_Rotation * DEG2RAD));
         
            Car_Position.z := Car_Position.z  -  Interfaces.C.C_float(Float(Car_Speed) * Float(Dt)* Float(Car_Forward.z));
            Car_Position.x := Car_Position.x  -  Interfaces.C.C_float(Float(Car_Speed) * Float(Dt)*  Float(Car_Forward.x));
         end if;

         
         -- 转向控制（只改变旋转角度，不改变位置）
         if Raylib.IsKeyDown(Raylib.KEY_G) then
            -- 左转，减少 Car_Rotation
            Car_Rotation := Car_Rotation + Float(Dt)*2.0;
         end if;

         if Raylib.IsKeyDown(Raylib.KEY_J) then
            -- 右转，增加 Car_Rotation
            Car_Rotation := Car_Rotation - Float(Dt)*2.0;
         end if;

         Car_Rot_Angle:=Interfaces.C.C_float(Car_Rotation);
         --Car_Rot_Angle := Lerp (Car_Rot_Angle, 360.0, Dt);

         --CarMatrix:=Raylib.Matrix.Translate(Car_Position.x,Car_Position.y,Car_Position.z);
         --CarMatrix.m0:= Interfaces.C.C_float(Float(10));

         Raylib.DrawModelEx (Car, Car_Position, Rot_Axis, Car_Rot_Angle, Scale, Raylib.WHITE);
         -- Raylib.DrawModelWiresEx (Car, Car_Position, Rot_Axis, Car_Rot_Angle, Scale, Raylib.WHITE);
         car_BBox_move:=car_BBox;
         
         car_BBox_move.min:=rotateY2(car_BBox_move.min,Car_Rotation);
         car_BBox_move.max:=rotateY2(car_BBox_move.max,Car_Rotation);

         car_BBox_move.min.x:=car_BBox.min.x+Car_Position.x;
         car_BBox_move.min.z:=car_BBox.min.z+Car_Position.z;
         
         car_BBox_move.max.x:=car_BBox.max.x+Car_Position.x;
         car_BBox_move.max.z:=car_BBox.max.z+Car_Position.z;
         
         --Raylib.DrawBoundingBox(car_BBox_move, aCarBox_Color);
         
         car_BBox_move.min:=(Car_Position.x-Car_Forward.x,Car_Position.y,Car_Position.z-Car_Forward.z);
         car_BBox_move.max:=(Car_Position.x+Car_Forward.x,Car_Position.y,Car_Position.z+Car_Forward.z);
         --Raylib.DrawLine3D(car_BBox_move.min,car_BBox_move.max,aCarBox_Color);
         
         
         Car_Left:=Vector3CrossProduct(Car_Forward,(0.0,1.0,0.0));
         
         --Car_Left.x:=Car_Left.x*Car_W/2.0;
         --Car_Left.y:=Car_Left.y*Car_W/2.0;
         --Car_Left.z:=Car_Left.z*Car_W/2.0;
         Car_Left:=scale_vec3(Car_Left,Float(Car_W/2.0));


         P0:=add_vec3(Car_Position,Car_Forward);
         P1:=add_vec3(P0,Car_Left);
         P2:=sub_vec3(P0,Car_Left);
         --Raylib.DrawLine3D(P2,P1,aCarBox_Color);
         DrawRectangle(P0,P1,P2,Float(Car_H/2.0),aCarBox_Color);

         P0:=sub_vec3(Car_Position,Car_Forward);
         P1:=add_vec3(P0,Car_Left);
         P2:=sub_vec3(P0,Car_Left);
         --Raylib.DrawLine3D(P2,P1,aCarBox_Color);
         DrawRectangle(P0,P1,P2,Float(Car_H/2.0),aCarBox_Color);

      end;

      Raylib.DrawGrid (10, 1.0);

      Raylib.EndMode3D;

      Raylib.EndDrawing;
   end loop;
   Raylib.CloseWindow;
end Raylib_Gym;