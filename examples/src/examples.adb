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
with Ada.Numerics.Elementary_Functions;  -- Import math library

procedure Raylib_Gym is
-- Definition of a 3D plane type
   type TPlane  is 
      record 
         point0:Raylib.Vector3; -- A point on the plane
         normal:Raylib.Vector3; -- The normal vector of the plane
      end record;
   
   -- Holding multiple bounding boxes
   type BoundingBoxs is array(1..6) of Raylib.BoundingBox;

   subtype CFloat is Interfaces.C.C_float;

   -- define DEG2RAD constant
   DEG2RAD : constant Float := 3.14159265359 / 180.0;
   -- Temporary variables
   pp1:Raylib.Vector3;   
   pp2:Raylib.Vector3;
   -- Height, Width, Length of bounding boxes
   H:CFloat;
   W:CFloat;
   L:CFloat;
   -- Flag indicating if a collision is detected
   isHitBox:Int; 
   -- Plane variables
   pl1:TPlane;
   a_pl:TPlane;
   a_point:Raylib.Vector3;
   -- Ray collision data structure initialization
   Collision : Raylib.RayCollision :=
     (False, 0.0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0));
   -- Ray and bounding boxes for collision testing
   aRay:Raylib.Ray;
   abox:Raylib.BoundingBox;
   aboxs:BoundingBoxs;
   Inner_BBox_slice:BoundingBoxs;
   Outer_BBox_slice:BoundingBoxs;

   -- Function to calculate the dot product of two vectors
   function dotProduct(v1,v2:Raylib.Vector3) return CFloat is
   begin
      return v1.x*v2.x+v1.y*v2.y+v1.z*v2.z;
   end;

   -- Function to calculate the midpoint between two vectors
   function midPoint(v1,v2:Raylib.Vector3) return Raylib.Vector3 is
      p:Raylib.Vector3;
      x:CFloat;
      y:CFloat;
      z:CFloat;      
   begin
      p:=v1;      
      x:=0.5*(v1.x+v2.x);
      y:=0.5*(v1.y+v2.y);
      z:=0.5*(v1.z+v2.z);
      p:=(x,y,z);
      return p;
   end;

   -- Function to slice a bounding box into smaller parts and optionally draw them
   function GetDrawBoxSlices(bbox:Raylib.BoundingBox;thickness:CFloat;aColor: Raylib.Color;isDraw:Int) return BoundingBoxs is
   begin
      -- Calculate dimensions of the bounding box
      abox:=bbox;
      W:=bbox.max.x-bbox.min.x;
      L:=bbox.max.z-bbox.min.z;
      H:=bbox.max.y-bbox.min.y;   

      -- Generate slices along the X and Z axes
      abox:=bbox;
      abox.min.x:=abox.min.x-thickness;
      abox.max.x:=abox.min.x+thickness;
      aboxs(1):=abox;
      if isDraw=1 then
         Raylib.DrawBoundingBox(abox, aColor);      
      end if;

      abox:=bbox;
      abox.min.x:=abox.max.x-thickness;
      abox.max.x:=abox.max.x+thickness;
      aboxs(2):=abox;
      if isDraw=1 then
         Raylib.DrawBoundingBox(abox, aColor);      
      end if;

      -- Similar slices along the Z axis
      abox:=bbox;
      abox.min.z:=abox.min.z-thickness;
      abox.max.z:=abox.min.z+thickness;
      aboxs(3):=abox;
      if isDraw=1 then
         Raylib.DrawBoundingBox(abox, aColor);      
      end if;
      abox:=bbox;
      abox.min.z:=abox.max.z-thickness;
      abox.max.z:=abox.max.z+thickness;
      aboxs(4):=abox;
      if isDraw=1 then
         Raylib.DrawBoundingBox(abox, aColor);      
      end if;
      return aboxs;
   end ;

   -- Linear interpolation function
   function Lerp (start, stop, alpha : CFloat) return CFloat is
      (start + (stop - start) * alpha);


   -- rotate by axis Y , alpha degress
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

   -- Rotates a 3D vector around the Y-axis
   function rotateY(x0,y0,z0,alpha :Float) return  Raylib.Vector3  is
      (Interfaces.C.C_float(rotateY_X(x0,z0,alpha))
      ,Interfaces.C.C_float(y0)
      ,Interfaces.C.C_float(rotateY_Z(x0,z0,alpha))
      );

   function rotateY2(p0:Raylib.Vector3;alpha :Float) return  Raylib.Vector3  is
      (rotateY(Float(p0.x),Float(p0.y),Float(p0.z),alpha));

   -- Vector addition function
   function add_vec3(v1,v2:Raylib.Vector3) return  Raylib.Vector3  is
      (
         v1.x+v2.x,
         v1.y+v2.y,
         v1.z+v2.z         
      );
   -- Vector subtraction function
   function sub_vec3(v1,v2:Raylib.Vector3) return  Raylib.Vector3  is
      (
         v1.x-v2.x,
         v1.y-v2.y,
         v1.z-v2.z         
      );
   -- Vector scaling function
   function scale_vec3(v1:Raylib.Vector3;s:Float) return  Raylib.Vector3  is
      ( v1.x*Interfaces.C.C_float(s),
        v1.y*Interfaces.C.C_float(s),
        v1.z*Interfaces.C.C_float(s)
      );
   -- Normalize a vector
   function normalize(v1:Raylib.Vector3) return  Raylib.Vector3  is
      ( v1.x/Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.sqrt(Float(v1.x*v1.x+v1.y*v1.y+v1.z*v1.z))),
        v1.y/Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.sqrt(Float(v1.x*v1.x+v1.y*v1.y+v1.z*v1.z))),
        v1.z/Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.sqrt(Float(v1.x*v1.x+v1.y*v1.y+v1.z*v1.z)))
      );
   -- Compute the cross product of two vectors
   function Vector3CrossProduct(v1,v2:Raylib.Vector3) return  Raylib.Vector3  is
      (normalize( (v1.y*v2.z-v1.z*v2.y,
        v1.z*v2.x-v1.x*v2.z,
        v1.x*v2.y-v1.y*v2.x)
      ));
   -- Procedure to draw a rectangle in 3D space
   procedure DrawRectangle(v0,v1,v2:Raylib.Vector3;high:Float;aColor: Raylib.Color ) is
      pp1:Raylib.Vector3;
      pp2:Raylib.Vector3;
   begin
      pp1:=add_vec3(v1,scale_vec3((0.0,1.0,0.0),high));
      pp2:=add_vec3(v2,scale_vec3((0.0,1.0,0.0),high));
      Raylib.DrawLine3D(pp1,pp2,aColor);
      pp1:=sub_vec3(v1,scale_vec3((0.0,1.0,0.0),high));
      pp2:=sub_vec3(v2,scale_vec3((0.0,1.0,0.0),high));
      Raylib.DrawLine3D(pp1,pp2,aColor);
   end;

   -- Function to create a plane from a bounding box
   function GetPlaneFromThinBox(bbox:Raylib.BoundingBox) return TPlane is
   begin 
      
      W:=bbox.max.x-bbox.min.x;
      L:=bbox.max.z-bbox.min.z;
      H:=bbox.max.y-bbox.min.y;   
      
      a_point.x:=bbox.min.x+W*0.5;
      a_point.z:=bbox.min.z+L*0.5;
      a_point.y:=bbox.min.y+H*0.5;

      if (W<0.0) then  
         W:=-1.0*W;
      end if;
      if (L<0.0) then  
         L:=-1.0*L;
      end if;
      if (H<0.0) then  
         H:=-1.0*H;
      end if;      

      a_pl:=(a_point,(0.0,1.0,0.0));

      if (L<W*0.5 and L<H*0.5) then
         if bbox.min.z<0.0 then
            a_pl.normal:=(0.0,0.0,1.0);
         else
            a_pl.normal:=(0.0,0.0,1.0);
         end if;
      end if;
      if (W<L*0.5 and W<H*0.5) then
         if bbox.min.x<0.0 then
            a_pl.normal:=(1.0,0.0,0.0);
         else
            a_pl.normal:=(1.0,0.0,0.0);
         end if;
      end if;
      return a_pl;
   end;
   -- Function to calculate the projection of a point on a plane
   function calculatePlanValue(a_plane:TPlane;point:Raylib.Vector3) return CFloat is
      v:CFloat;
      p01:Raylib.Vector3;
   begin
      p01:=sub_vec3(point,a_plane.point0);
      v:=dotProduct(p01,a_plane.normal);
      return v;
   end;

   -- Function to check if a line intersects any bounding boxes
   function isLineInBoxs(p1,p2:Raylib.Vector3;boxs:BoundingBoxs) return Int is 
      aPlane:TPlane;
      v1:CFloat;
      v2:CFloat;
   begin 
      aPlane:=GetPlaneFromThinBox(aboxs(1));
      v1:=calculatePlanValue(aPlane,p1);
      v2:=calculatePlanValue(aPlane,p2);
      if (v1*v2<0.0) then 
         return 1; -- Intersection found
      end if;
      aPlane:=GetPlaneFromThinBox(aboxs(2));
      v1:=calculatePlanValue(aPlane,p1);
      v2:=calculatePlanValue(aPlane,p2);
      if (v1*v2<0.0) then 
         return 1;
      end if;
      aPlane:=GetPlaneFromThinBox(aboxs(3));
      v1:=calculatePlanValue(aPlane,p1);
      v2:=calculatePlanValue(aPlane,p2);
      if (v1*v2<0.0) then 
         return 1;
      end if;
      aPlane:=GetPlaneFromThinBox(aboxs(4));
      v1:=calculatePlanValue(aPlane,p1);
      v2:=calculatePlanValue(aPlane,p2);
      if (v1*v2<0.0) then 
         return 1;
      end if;
      return 0;   -- No intersection
   end ;

   -- Function to check if a ray intersects with any bounding boxes
   function isLineInBoxs0(aRay:Raylib.Ray;boxs:BoundingBoxs) return Raylib.RayCollision is 
   begin 
      -- Check collision with the first bounding box in the array
      Collision:=Raylib.GetRayCollisionBox(aRay, aboxs(1));
       -- If no collision, check the next bounding box
      if not Collision.hit then
         Collision:=Raylib.GetRayCollisionBox(aRay, aboxs(2));
      end if;
      if not Collision.hit then
         Collision:=Raylib.GetRayCollisionBox(aRay, aboxs(3));
      end if;
      if not Collision.hit then
         Collision:=Raylib.GetRayCollisionBox(aRay, aboxs(4));
      end if;
      -- Return the collision data, indicating whether a hit occurred
      return Collision;
   end ;

   -- Initialize screen width and height constants
   screenWidth  : constant := 800;
   screenHeight : constant := 450;
   -- Declare the camera
   Cam : aliased Raylib.Camera3D;
   -- Matrices for transforming the car and the boundaries
   CarMatrix:Raylib.Matrix;
   BoundaryMatrix:Raylib.Matrix;
   -- Models for the car and the race track
   Car : Raylib.Model;
   Race_Track : Raylib.Model;
   -- Models for outer and inner boundaries
   Outer_Boundary : Raylib.Model;
   Outer_Boundary_Mesh : Raylib.Mesh;
   -- Colors for drawing bounding boxes and car bounding box
   aBox_Color : Raylib.Color := (0,121,241,255); -- Blue for general bounding boxes
   aCarBox_Color : Raylib.Color := (255,0,0,255); -- Red for the car bounding box
   -- Inner boundary model and mesh
   Inner_Boundary : Raylib.Model;
   aInner_Boundary_Mesh :access Raylib.Mesh;
   Inner_Boundary_Mesh : Raylib.Mesh;
   -- Vertices for the inner boundary (for potential vertex-based collision detection)
   aInner_vertices :access Interfaces.C.C_float;
   Inner_vertices_1 :Interfaces.C.C_float;
   -- Bounding boxes for the inner and outer boundaries, and the car
   Inner_BBox: Raylib.BoundingBox;
   Outer_BBox: Raylib.BoundingBox;
   car_BBox: Raylib.BoundingBox;
   car_BBox_move: Raylib.BoundingBox;
   -- Variables for world transformation
   World_Pos : Raylib.Vector3 := (0.0, 0.0, 0.0);
   World_Rot_Axis : Raylib.Vector3 := (0.0, 1.0, 0.0); -- Rotation around the Y-axis
   World_Scale : Raylib.Vector3 := (0.2, 0.2, 0.2); -- Uniform scaling factor
   -- Time delta for frame-based updates
   Dt : CFloat;
   -- Points for defining the car's geometry and collision lines
   P00:Raylib.Vector3 := (0.0, 0.0, 0.0);
   P0:Raylib.Vector3 := (0.0, 0.0, 0.0);
   P1:Raylib.Vector3 := (0.0, 0.0, 0.0);
   P2:Raylib.Vector3 := (0.0, 0.0, 0.0);
   Car_Rot_Angle : Cfloat := 0.0; -- Car's rotation angle (around Y-axis)
   -- Size and position for a central bounding box
   Center_BB_Size : Raylib.Vector3 := (1.0, 1.0, 1.0);
   Center_BB_Pos : Raylib.Vector3 := (-Center_BB_Size.x / 2.0, 
                                      0.0, 
                                      -Center_BB_Size.z / 2.0);

   Center_BB : Raylib.BoundingBox := ((0.0, 0.0, 0.0), (100.0, 100.0, 100.0));
   -- Car position variables
   Car_Position_old: Raylib.Vector3 := (0.0, 0.0, 0.0);  
   Car_Position : Raylib.Vector3 := (0.0, 0.0, 0.0);  
   Car_Position1: Raylib.Vector3 := (0.0, 0.0, 0.0); 
   Car_Position2: Raylib.Vector3 := (0.0, 0.0, 0.0); 
   Car_Position3: Raylib.Vector3 := (0.0, 0.0, 0.0); 
   Car_Position4: Raylib.Vector3 := (0.0, 0.0, 0.0); 
   -- Collision data structures
   myCollision : Raylib.RayCollision;
   myCollisionMesh : Raylib.RayCollision;
   myCollision1 : Raylib.RayCollision;
   myCollision2 : Raylib.RayCollision;
   myCollision3 : Raylib.RayCollision;
   myCollision4 : Raylib.RayCollision;
   -- Movement flags and parameters for the car
   Car_isForward:Int:=1;   -- Direction flag: forward (1) or backward (0)
   car_scale:CFloat:=0.1;   -- Scaling factor for the car
   Car_Speed : Float := 0.5;  -- Distance moved per frame
   Car_Rotation : Float := 0.0;  --- Initial rotation of the car
   Car_Rotation_old: Float := 0.0;  -- Previous rotation angle
   Car_Forward: Raylib.Vector3 := (0.0, 0.0, 1.0);   -- Forward direction
   Car_Left: Raylib.Vector3 := (0.0, 0.0, 1.0);   -- Leftward direction

   -- Dimensions of the car
   Car_L:Interfaces.C.C_float := 0.2;  
   Car_W:Interfaces.C.C_float := 0.2;  
   Car_H:Interfaces.C.C_float := 0.2;  
   -- Minimum distance to a collision point
   min_hitDist:Float:=100000.0;
   -- Ray for collision testing
   myRay:raylib.Ray := (Car_Position,Car_Forward); 
   
begin
 
   Raylib.InitWindow (screenWidth, screenHeight, New_String ("Raylib Gym"));
   
   Car := Raylib.LoadModel (New_String ("C:\CSI4900\raylib-ada\examples\share\race_car.gltf"));
   Race_Track := Raylib.LoadModel (New_String ("C:\CSI4900\raylib-ada\examples\share\race_track.gltf"));

   Outer_Boundary := Raylib.LoadModel (New_String ("C:\CSI4900\raylib-ada\examples\share\data\outer_boundary.gltf"));
   Outer_Boundary_Mesh := Outer_Boundary.meshes.all;   -- Extract the mesh data from the outer boundary model
   Inner_Boundary := Raylib.LoadModel (New_String ("C:\CSI4900\raylib-ada\examples\share\data\inner_boundary.gltf"));
   -- Calculate and store the bounding boxes for the outer and inner boundaries
   Outer_BBox:= Raylib.GetModelBoundingBox(Outer_Boundary);   
   Inner_BBox:= Raylib.GetModelBoundingBox(Inner_Boundary);

   car_BBox:= Raylib.GetModelBoundingBox(Car);  -- Calculate and store the bounding box for the car

   -- Scale the car's bounding box to match its scaled size in the simulation
   car_BBox.min:=(car_BBox.min.x* car_scale,car_BBox.min.y*car_scale,car_BBox.min.z*car_scale);
   car_BBox.max:=(car_BBox.max.x* car_scale,car_BBox.max.y* car_scale,car_BBox.max.z* car_scale);
      
   -- Calculate the dimensions of the car's bounding box
   Car_W:=(car_BBox.max.x - car_BBox.min.x)/1.0;
   Car_L:=(car_BBox.max.z - car_BBox.min.z)/1.0;  
   Car_H:=(car_BBox.max.y - car_BBox.min.y)/1.0;  
   -- Ensure dimensions are positive (absolute values)
   if Car_L<0.0 then
      Car_L:=Car_L;
   end if;
   if Car_W<0.0 then
      Car_W:=-Car_W;
   end if;
   if Car_H<0.0 then
      Car_H:=Car_H;
   end if;
   -- Scale the bounding box of the inner boundary
   Inner_BBox.min:=(Inner_BBox.min.x* 0.2,Inner_BBox.min.y* 0.2,Inner_BBox.min.z* 0.2);
   Inner_BBox.max:=(Inner_BBox.max.x* 0.2,Inner_BBox.max.y* 0.2,Inner_BBox.max.z* 0.2);
   -- Scale the bounding box of the outer boundary
   Outer_BBox.min:=(Outer_BBox.min.x* 0.2,Outer_BBox.min.y* 0.2,Outer_BBox.min.z* 0.2);
   Outer_BBox.max:=(Outer_BBox.max.x* 0.2,Outer_BBox.max.y* 0.2,Outer_BBox.max.z* 0.2);
   

   -- Set up the camera properties for the 3D view
   Cam.position := (10.0, 10.0, 10.0);
   Cam.target := (0.0, 0.0, 0.0);
   Cam.up := (0.0, 1.0, 0.0);
   Cam.fovy := 45.0;
   -- Cam.projection := Interfaces.C.int (Raylib.CAMERA_PERSPECTIVE);
   Cam.projection := Raylib.CAMERA_PERSPECTIVE;
   -- Raylib.DisableCursor;
   Raylib.SetTargetFPS (60);
   -- Initialize the car's position
   Car_Position:=(-4.0, 0.0, 0.0);

   while not Raylib.WindowShouldClose loop
      Raylib.BeginDrawing;

      -- WORKING in 2D. So 0,0 is the top left corner. (ScreenSpace)

      Raylib.ClearBackground (Raylib.RAYWHITE); -- Clear the screen with a white background color

      Raylib.BeginMode3D (Cam);
      
      -- WORKING in 3D. So 0,0 is the center of the grid. (WorldSpace)
      -- Draw the outer and inner boundaries of the track
      -- Raylib.DrawModelEx (Race_Track, World_Pos, World_Rot_Axis, 0.0, World_Scale, Raylib.WHITE);
      Raylib.DrawModelEx (Outer_Boundary, World_Pos, World_Rot_Axis, 0.0, World_Scale, Raylib.GRAY);
      Raylib.DrawModelEx (Inner_Boundary, World_Pos, World_Rot_Axis, 0.0, World_Scale, Raylib.GRAY);

      -- Optionally, bounding boxes can be visualized for debugging purposes
      --Raylib.DrawBoundingBox(Outer_BBox, aBox_Color);
      --Raylib.DrawBoundingBox(Inner_BBox, aBox_Color);

      --Inner_BBox_slice:=GetDrawBoxSlices(Inner_BBox,0.02,Raylib.BLUE,0);
      --Outer_BBox_slice:=GetDrawBoxSlices(Outer_BBox,0.02,Raylib.BLUE,0);
      
      -- Declare additional variables for car transformations
      declare
         Pos : Raylib.Vector3 :=Car_Position;
         Rot_Axis : Raylib.Vector3 :=(0.0, 1.0, 0.0);
         Scale : Raylib.Vector3 :=(car_scale,car_scale, car_scale); --World_Scale
      begin
         Dt := 5.0 * Raylib.GetFrameTime;

         Car_Forward.x:=Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.Sin(Car_Rotation * DEG2RAD));
         Car_Forward.z:=Interfaces.C.C_float(Ada.Numerics.Elementary_Functions.Cos(Car_Rotation * DEG2RAD));
         Car_Forward.y:=0.0;

         -- Store the car's previous position and rotation for collision detection
         Car_Position_old:=Car_Position;
         Car_Rotation_old:=Car_Rotation;

         -- Forward Movement
         if Raylib.IsKeyDown(Raylib.KEY_Y) then
            Car_isForward:=1; -- Indicate that the car is moving forward
            --Car_Position.z := Car_Position.z + Interfaces.C.C_float(Float(Car_Speed) * Ada.Numerics.Elementary_Functions.Cos(Car_Rotation * DEG2RAD));
            --Car_Position.x := Car_Position.x - Interfaces.C.C_float(Float(Car_Speed) * Ada.Numerics.Elementary_Functions.Sin(Car_Rotation * DEG2RAD));
         
            Car_Position.z := Car_Position.z  +  Interfaces.C.C_float(Float(Car_Speed) * Float(Dt)* Float(Car_Forward.z));
            Car_Position.x := Car_Position.x  +  Interfaces.C.C_float(Float(Car_Speed) * Float(Dt)* Float(Car_Forward.x));
         end if;

         -- Backward Movement
         if Raylib.IsKeyDown(Raylib.KEY_H) then
            Car_isForward:=0; -- Indicate that the car is moving backward
            --Car_Position.z := Car_Position.z - Interfaces.C.C_float(Float(Car_Speed) * Ada.Numerics.Elementary_Functions.Cos(Car_Rotation * DEG2RAD));
            -- Car_Position.x := Car_Position.x + Interfaces.C.C_float(Float(Car_Speed) * Ada.Numerics.Elementary_Functions.Sin(Car_Rotation * DEG2RAD));
         
            Car_Position.z := Car_Position.z  -  Interfaces.C.C_float(Float(Car_Speed) * Float(Dt)* Float(Car_Forward.z));
            Car_Position.x := Car_Position.x  -  Interfaces.C.C_float(Float(Car_Speed) * Float(Dt)*  Float(Car_Forward.x));
         end if;

         
         -- turn control
         if Raylib.IsKeyDown(Raylib.KEY_G) then
            --turn left :
            if Car_isForward>0 then    -- when forward , Car_Rotation ++
               Car_Rotation := Car_Rotation + Float(Dt)*5.0;
            else                        -- when backward , Car_Rotation --         
               Car_Rotation := Car_Rotation - Float(Dt)*5.0;
            end if;
         end if;

         if Raylib.IsKeyDown(Raylib.KEY_J) then
            
            if Car_isForward>0 then 
               -- right turn
               Car_Rotation := Car_Rotation - Float(Dt)*5.0;
            else
               Car_Rotation := Car_Rotation + Float(Dt)*5.0;
            end if;   
         end if;
         -- Update rotation angle for rendering
         Car_Rot_Angle:=Interfaces.C.C_float(Car_Rotation);
         --Car_Rot_Angle := Lerp (Car_Rot_Angle, 360.0, Dt);
         --CarMatrix:=Raylib.Matrix.Translate(Car_Position.x,Car_Position.y,Car_Position.z);
         --BoundaryMatrix:=Raylib.Matrix.Translate(Car_Position.x,Car_Position.y,Car_Position.z);
         --CarMatrix.m0:= Interfaces.C.C_float(Float(10));

         -- Render the car model at its updated position, orientation, and scale
         Raylib.DrawModelEx (Car, Car_Position, Rot_Axis, Car_Rot_Angle, Scale, Raylib.WHITE);
         -- Update the car's bounding box dimensions based on scaling
         car_BBox:= Raylib.GetModelBoundingBox(Car);
         car_BBox.min:=scale_vec3(car_BBox.min,Float(car_scale));
         car_BBox.max:=scale_vec3(car_BBox.max,Float(car_scale));
         
         -- Optionally render the bounding box for debugging
         -- Raylib.DrawBoundingBox(car_BBox, Raylib.BLUE);

         -- Raylib.DrawModelWiresEx (Car, Car_Position, Rot_Axis, Car_Rot_Angle, Scale, Raylib.WHITE);
         -- Move the bounding box based on the car's position and rotation
         car_BBox_move:=car_BBox;
         
         car_BBox_move.min:=rotateY2(car_BBox_move.min,Car_Rotation);
         car_BBox_move.max:=rotateY2(car_BBox_move.max,Car_Rotation);

         car_BBox_move.min.x:=car_BBox.min.x+Car_Position.x;
         car_BBox_move.min.z:=car_BBox.min.z+Car_Position.z;
         
         car_BBox_move.max.x:=car_BBox.max.x+Car_Position.x;
         car_BBox_move.max.z:=car_BBox.max.z+Car_Position.z;
         
         --Raylib.DrawBoundingBox(car_BBox_move, Raylib.BLUE);   -- the move bbox is not align to axis

         car_BBox_move.min:=(Car_Position.x-Car_Forward.x,Car_Position.y,Car_Position.z-Car_Forward.z);
         car_BBox_move.max:=(Car_Position.x+Car_Forward.x,Car_Position.y,Car_Position.z+Car_Forward.z);
         --Raylib.DrawLine3D(car_BBox_move.min,car_BBox_move.max,aCarBox_Color);
         
         -- Calculate the left side of the car based on its forward direction
         Car_Left:=Vector3CrossProduct(Car_Forward,(0.0,1.0,0.0));         
         Car_Left:=scale_vec3(Car_Left,Float(Car_W*0.5)); 

         -- Calculate the positions of the car's corners for collision detection
         P0:=add_vec3(Car_Position,scale_vec3(Car_Forward,Float(CAR_L*0.5))); --*0.5
         P00:=P0;
         P1:=add_vec3(P0,Car_Left);
         P2:=sub_vec3(P0,Car_Left);
         Car_Position1:=P1;
         Car_Position2:=P2;
         --draw the head board
         --DrawRectangle(P0,P1,P2,Float(Car_H*0.5),aCarBox_Color);

         P0:=sub_vec3(Car_Position,scale_vec3(Car_Forward,Float(CAR_L*0.5))); --*0.5
         P1:=add_vec3(P0,Car_Left);
         P2:=sub_vec3(P0,Car_Left);
         Car_Position3:=P1;
         Car_Position4:=P2;
         --draw the tail board
         --DrawRectangle(P0,P1,P2,Float(Car_H*0.5),aCarBox_Color);

         -- Raylib.DrawCylinderWiresEx(P00,P0,Car_W*0.5,Car_W*0.5,20, Raylib.BLUE);  -- the cylinder around the car
         
         --Raylib.DrawLine3D(P00,P0,Raylib.RED);
         --Raylib.DrawLine3D(P1,cam.position,Raylib.GREEN);
         --Raylib.DrawLine3D(P00,sub_vec3(cam.position,Car_Forward),Raylib.RED); --can show
         --Raylib.DrawLine3D(P00,add_vec3(cam.position,Car_Forward),Raylib.RED);
      end;
      
      --myRay := (Car_Position,Car_Forward);
      --myRay := (add_vec3(Car_Position,scale_vec3(Car_Forward,Float(-100.0*Car_L))),add_vec3(Car_Position,scale_vec3(Car_Forward,Float(100.0*Car_L))));
      --myRay := Raylib.GetMouseRay (Raylib.GetMousePosition, Cam);   
      myRay := ((Car_Position),(0.0,0.0,1.0));    

      --myRay := Raylib.GetMouseRay ((Car_Position.x,Car_Position.z), Cam);    
      --myRay := (Car_Position,sub_vec3(Cam.position,Car_Position));      -- ok1
      --myRay := (Car_Position,sub_vec3(Car_Forward,Car_Position));    
      
      ---Car_Forward:=scale_vec3(Car_Forward,Float(4.0*Car_L));
      --myRay := (Car_Position,Car_Forward); 


      --Ray collision checks for inner and outer boundaries
      Inner_BBox_slice:=GetDrawBoxSlices(Inner_BBox,0.1,Raylib.BLUE,0);
      isHitBox:=isLineInBoxs(P0,P00,Inner_BBox_slice); 
      if isHitBox=0 then 
         isHitBox:=isLineInBoxs(Car_Position1,Car_Position2,Inner_BBox_slice); 
      end if;
      if isHitBox=0 then 
         isHitBox:=isLineInBoxs(Car_Position3,Car_Position4,Inner_BBox_slice); 
      end if;      
      if isHitBox=0 then 
         pp1:=midPoint(Car_Position1,Car_Position3);
         pp2:=midPoint(Car_Position2,Car_Position4);
         isHitBox:=isLineInBoxs(pp1,pp2,Inner_BBox_slice); 
      end if;

      --check collision with outer boundary
      if isHitBox=0 then 
         Outer_BBox_slice:=GetDrawBoxSlices(Outer_BBox,0.1,Raylib.BLUE,0);
         isHitBox:=isLineInBoxs(P0,P00,Outer_BBox_slice); 
      end if;
      if isHitBox=0 then 
         isHitBox:=isLineInBoxs(Car_Position1,Car_Position2,Outer_BBox_slice); 
      end if;
      if isHitBox=0 then 
         isHitBox:=isLineInBoxs(Car_Position3,Car_Position4,Outer_BBox_slice); 
      end if;      
      if isHitBox=0 then 
         pp1:=midPoint(Car_Position1,Car_Position3);
         pp2:=midPoint(Car_Position2,Car_Position4);
         isHitBox:=isLineInBoxs(pp1,pp2,Outer_BBox_slice); 
      end if;
        
      myCollision:= Raylib.GetRayCollisionBox(myRay,Inner_BBox);
      if not myCollision.hit then
         myCollision:= Raylib.GetRayCollisionBox(myRay,Outer_BBox);
      end if;     
      
      --  if 1=0 then    -- below is not used 
      --     --get mesh and check
      --     aInner_Boundary_Mesh:= Outer_Boundary.meshes; -- Inner_Boundary.meshes;
      --     Inner_Boundary_Mesh:=aInner_Boundary_Mesh.all;
      --     aInner_vertices:=Inner_Boundary_Mesh.vertices;
         
      --     Inner_vertices_1:=aInner_vertices.all; -- (3);

      --     myRay := (Car_Position,sub_vec3(Cam.position,Car_Position));
      --     --myRay:=(Car_Position1,sub_vec3(Cam.position,Car_Position1));
      --     Raylib.DrawRay(myRay,Raylib.BLUE);     -- draw ray 
      --     Raylib.DrawLine3D(Car_Position,sub_vec3(Cam.position,Car_Position),Raylib.RED); --can show

      --     Raylib.DrawLine3D(Car_Position1,sub_vec3(Cam.position,Car_Position),Raylib.RED); --can show
      --     Raylib.DrawLine3D(Car_Position3,sub_vec3(Cam.position,Car_Position),Raylib.RED); --can show
      --     --myCollisionMesh:= Raylib.getRayCollisionMesh(myRay,Inner_Boundary_Mesh,Inner_Boundary.transform_f); --Inner_Boundary.transform); -- BoundaryMatrix);
         
      
      --     myCollision1:= Raylib.GetRayCollisionBox(myRay,Inner_BBox);
      --     if not myCollision1.hit then
      --        myCollision1:= Raylib.GetRayCollisionBox(myRay,Outer_BBox);
      --     end if;
      --     Raylib.DrawRay(myRay,Raylib.BLUE);

      --     myRay:=(Car_Position2,sub_vec3(Cam.position,Car_Position2)); 

      --     myCollision2:= Raylib.GetRayCollisionBox(myRay,Inner_BBox);
      --     if not myCollision2.hit then
      --        myCollision2:= Raylib.GetRayCollisionBox(myRay,Outer_BBox);
      --     end if;
      --     Raylib.DrawRay(myRay,Raylib.BLUE);      

      --     myRay:=(Car_Position3,sub_vec3(Cam.position,Car_Position3)); 
      --     myCollision3:= Raylib.GetRayCollisionBox(myRay,Inner_BBox);  
      --     if not myCollision3.hit then    
      --        myCollision3:= Raylib.GetRayCollisionBox(myRay,Outer_BBox);
      --     end if;
      --     Raylib.DrawRay(myRay,Raylib.BLUE);

      --     myRay:=(Car_Position4,sub_vec3(Cam.position,Car_Position4)); 
      --     myCollision4:= Raylib.GetRayCollisionBox(myRay,Inner_BBox);      
      --     if not myCollision4.hit then
      --        myCollision4:= Raylib.GetRayCollisionBox(myRay,Outer_BBox);
      --     end if;
      --     Raylib.DrawRay(myRay,Raylib.BLUE);
         
      --     min_hitDist:=100000.0;
      --     if  myCollision.hit  then
      --        if min_hitDist>Float(myCollision.distance) then
      --           min_hitDist:=Float(myCollision.distance);
      --        end if;
      --     end if;
      --     if  myCollision1.hit  then
      --        if min_hitDist>Float(myCollision1.distance) then
      --           min_hitDist:=Float(myCollision1.distance);
      --        end if;
      --     end if;
         
      --     if  myCollision2.hit  then
      --        if min_hitDist>Float(myCollision2.distance) then
      --           min_hitDist:=Float(myCollision2.distance);
      --        end if;
      --     end if;
         
      --     if  myCollision3.hit  then
      --        if min_hitDist>Float(myCollision3.distance) then
      --           min_hitDist:=Float(myCollision3.distance);
      --        end if;
      --     end if;
         
      --     if  myCollision4.hit  then
      --        if min_hitDist>Float(myCollision4.distance) then
      --           min_hitDist:=Float(myCollision4.distance);
      --        end if;
      --     end if;
      --  end if;
      
      Raylib.DrawGrid (10, 1.0);

      Raylib.EndMode3D;

      --  if 1=0 then 
      --     if (myCollision.hit or myCollision1.hit or myCollision2.hit or myCollision3.hit or myCollision4.hit) then
      --        Raylib.DrawText ("Box Hitted :",100, 20, 20, Raylib.RED); 
      --        Raylib.DrawText (Float'Image(min_hitDist),280, 20, 20, Raylib.RED); -- "Hitted"
      --     else
      --        Raylib.DrawText ("UnHitted",100, 20, 20, Raylib.GREEN);
      --     end if;        
      
      --     Raylib.DrawText ("Car X:",100, 0, 20, Raylib.BLUE);
      --     Raylib.DrawText (Float'Image(Float(Car_Position3.x)),180, 0, 20, Raylib.BLUE);

      --     Raylib.DrawText ("Car Z:",400, 0, 20, Raylib.BLUE);
      --     Raylib.DrawText (Float'Image(Float(Car_Position3.z)),480, 0, 20, Raylib.BLUE);

      --     Raylib.DrawText (Int'Image(Int(Inner_Boundary_Mesh.vertexCount)),100, 40, 16, Raylib.BLUE);      
      --     Raylib.DrawText (Int'Image(Int(Inner_Boundary_Mesh.triangleCount)),100, 56, 16, Raylib.BLUE);
      --     Raylib.DrawText (Int'Image(Int(Inner_Boundary_Mesh.vaoId)),180, 40, 16, Raylib.BLUE);  
      --  end if;

      if (isHitBox>0) then  -- myCollisionMesh.hit or
         Raylib.DrawText ("Mesh hit:",0, 40, 20, Raylib.RED);         
      else
         Raylib.DrawText ("Mesh unhit:",0, 40, 20, Raylib.GREEN);
      end if;

          
    
      Raylib.DrawFPS (10, 10);
      Raylib.EndDrawing;

   end loop;
   Raylib.CloseWindow;
end Raylib_Gym;