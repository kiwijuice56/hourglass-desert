shader_type canvas_item;

// Camera state, set by fractal_navigation.gd
uniform vec3 cam_pos = vec3(0.0);
uniform mat3 cam_mat = mat3(0.0); // The camera basis matrix

// Screen size, set by set by fractal_navigation.gd
uniform float width = 1024.0;
uniform float height = 1024.0;

// Animation constants
const float shimmer_speed = 0.1;
const float scale_speed = 0.05;
const float scale_range = 0.25;
const float scale_center = 2.25;
const float glow_range = 0.03;

// Calculation constants
const float fov = 95.0;
const float universe_size = 16.0;
const float runaway_threshold = 24.0;

// Parameters
uniform int palette = 2;
uniform bool ambient_occlusion = true;
uniform bool glow = true;
uniform bool mirror = false;
uniform float collision_threshold = 9e-4;

// http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
vec3 hsv2rgb(vec3 c) {
	vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
	return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
}

vec3 get_color(int iter, vec3 ray_pos) {
	float x = float(iter) / 128.0;
	
	if (palette == 1) {
		return hsv2rgb(vec3(x + TIME * shimmer_speed, 0.65, 1.0));
	} else if (palette == 2) {
		return vec3(1.0);
	} else if (palette == 3) {
		if (iter == 128) {
			ray_pos = vec3(sin(TIME * shimmer_speed));
		}
		vec3 col = mod(ray_pos, 1.0);
		return hsv2rgb(vec3(col.r + col.g + col.b + x, 0.7, 1.0));
	} else if (palette == 4) { 
		// Scale x to increase the density of colors
		float y = x * 4.0;
		y -= floor(y);
		
		// Rather than let y jump directly from 1 to 0, double it to have a continuous change
		float wave_y = y < 0.5 ? y * 2.0 : 2.0 - 2.0 * y;
		wave_y *= 0.7;
		return vec3(wave_y, 0.5 + wave_y, 0.8 + wave_y);
	} else if (palette == 5) {
		float y = x * (4.0 + sin(TIME) * 2.0);
		y -= floor(y);
		float wave_y = y < 0.5 ? y * 2.0 : 2.0 - 2.0 * y;
		wave_y *= 0.45;
		return vec3(0.5 - wave_y, 0.0, 0.15 - wave_y);
	} else {
		return vec3(0.0);
	}
}

void sphere_fold(inout vec3 p, inout float dz) {
	float r2 = max(0.25, p.x * p.x + p.y * p.y + p.z * p.z);
	if (r2 < 0.5) {
		p *= 0.5 / r2;
		dz *= 0.5 / r2;
	}
}

void box_fold(inout vec3 p) {
	p = clamp(p, -0.5, 0.5) * 2.0 - p;
}

// http://blog.hvidtfeldts.net/index.php/2011/11/distance-estimated-3d-fractals-vi-the-mandelbox/
float mandelbox_de(vec3 p) {
	if (mirror) {
		p = mod(p, universe_size) - vec3(universe_size / 2.0);
	}
	float dz = 1.0;
	vec3 original = p;
	float scale = sin(TIME * scale_speed) * scale_range + scale_center;
	for (int i = 0; i < 10; i++) {
		box_fold(p);
		sphere_fold(p, dz);
		p = p * scale + original;
		dz = dz * scale + 1.0;
	}
	return length(p) / dz;
}

int march(inout vec3 ray_pos, vec3 ray_dir, inout float closest_dist) {
	float dist = universe_size;
	int iter = 0;
	
	// WebGL has a limitation that won't allow the shader to compile
	// if a non-constant is used in for-loops; 128 is `MAX_ITER`
	for (int i = 0; i < 128; i++) {
		dist = abs(mandelbox_de(ray_pos));
		closest_dist = min(closest_dist, dist);
		ray_pos += ray_dir * dist;
		
		// We can quit marching early if we are extremely far from the fractal
		if (dist > runaway_threshold) {
			iter = 128;
			break;
		}
		
		// Once we are close enough to the fractal, we say we "collided" with it
		if (dist < collision_threshold) {
			break;
		}
		iter++;
	}
	return iter;
}

// https://www.scratchapixel.com/lessons/3d-basic-rendering/ray-tracing-generating-camera-rays/generating-camera-rays.html
void fragment() {
	// Take the pixel position (UV) and convert it into a ray direction based 
	// on the camera's orientation
	vec3 ray_pos = cam_pos;
	float px = (2.0 * UV.x - 1.0) * tan(fov / 2.0 * PI / 180.0) * (width / height);
	float py = (1.0 - 2.0 * UV.y * tan(fov / 2.0 * PI / 180.0));
	vec3 ray_dir = vec3(px, py, -1);
	ray_dir = cam_mat * normalize(ray_dir);
	
	float closest_dist = universe_size;
	int iter = march(ray_pos, ray_dir, closest_dist);
	
	vec3 col = get_color(iter, ray_pos);
	
	// Color the fractal if we collided with it, otherwise create a glow with
	// the closest we ever got to the fractal
	COLOR.rgb = col;
	if (iter < 128) {
		if (ambient_occlusion) {
			COLOR.rgb *= vec3(1.0 - float(iter) / 128.0);
		}
	} else {
		if (glow) {
			COLOR.rgb *= (1.0 - pow(closest_dist, glow_range));
		} else {
			COLOR.rgb *= 0.0;
		}
	}
}