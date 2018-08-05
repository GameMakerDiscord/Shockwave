if ( keyboard_check( vk_anykey ) )
{
    draw_surface( surface, 0, 0 );
}
else
{
    shader_set( shdShockwaveRender );
    var _texture = surface_get_texture( surface );
    texture_set_stage( shader_get_sampler_index( shader_current(), "u_sShockwave" ), _texture );
    shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fStrength" ), 20 );
    shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fTexelSize" ), texture_get_texel_width( _texture ), texture_get_texel_height( _texture ) )
    draw_surface( application_surface, 0, 0 );
    shader_reset();
}