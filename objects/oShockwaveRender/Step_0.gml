//Smooth our fps_real
fps_smoothed = lerp( fps_smoothed, fps_real, 0.02 );

//Keyboard input
if ( keyboard_check_pressed( vk_space ) ) global.shockwave_batch = !global.shockwave_batch;

//Click to create shockwaves
if ( mouse_check_button_pressed( mb_left ) ) instance_create_layer( mouse_x, mouse_y, "Instances", oShockwave );
if ( mouse_check_button( mb_right ) ) instance_create_layer( mouse_x, mouse_y, "Instances", oShockwave );

//Regardless of whether we're in batch mode, we want to discard the shockwave vertex buffer every frame
if ( vbf_shockwave != noone )
{
    vertex_delete_buffer( vbf_shockwave );
    vbf_shockwave = noone;
}

//Build a vertex buffer out of the shockwave instances
if ( global.shockwave_batch && ( instance_number( oShockwave ) > 0 ) )
{
    vbf_shockwave = vertex_create_buffer_ext( instance_number( oShockwave )*6*(8+1+8) );
    vertex_begin( vbf_shockwave, global.vft_2d );
    var _vbuff = vbf_shockwave;
    
    //Because with() iterates from newest to oldest, and we want to go oldest to newest, then we have to build an array
    //This is admittedly a matter of taste - sometimes you may want to stick with GM's native behaviour
    var _shockwaves = array_create( instance_number( oShockwave ) );
    var _i = 0;
    with( oShockwave ) _shockwaves[_i++] = id;
    
    for( var _i = instance_number( oShockwave )-1; _i >= 0; _i-- )
    {
        with( _shockwaves[_i] )
        {
            var _colour = make_colour_rgb( 255*( max_radius/SHOCKWAVE_BATCH_GLOBAL_MAX_RADIUS ),
                                           255*( min_radius/SHOCKWAVE_BATCH_GLOBAL_MAX_RADIUS ),
                                           255*( exponent/SHOCKWAVE_BATCH_GLOBAL_MAX_EXPONENT ) );
            
            vertex_position( _vbuff, x - max_radius, y - max_radius ); vertex_color( _vbuff, _colour, alpha ); vertex_texcoord( _vbuff, x, y );
            vertex_position( _vbuff, x + max_radius, y - max_radius ); vertex_color( _vbuff, _colour, alpha ); vertex_texcoord( _vbuff, x, y );
            vertex_position( _vbuff, x - max_radius, y + max_radius ); vertex_color( _vbuff, _colour, alpha ); vertex_texcoord( _vbuff, x, y );
            
            vertex_position( _vbuff, x + max_radius, y - max_radius ); vertex_color( _vbuff, _colour, alpha ); vertex_texcoord( _vbuff, x, y );
            vertex_position( _vbuff, x + max_radius, y + max_radius ); vertex_color( _vbuff, _colour, alpha ); vertex_texcoord( _vbuff, x, y );
            vertex_position( _vbuff, x - max_radius, y + max_radius ); vertex_color( _vbuff, _colour, alpha ); vertex_texcoord( _vbuff, x, y );
        }
    }
    
    vertex_end( vbf_shockwave );
}