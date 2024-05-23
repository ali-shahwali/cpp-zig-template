const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "cglm",
        .target = target,
        .optimize = optimize,
    });

    lib.installHeadersDirectory(b.path("include/"), ".", .{});

    lib.addCSourceFiles(.{
        .files = &sources,
        .flags = &flags,
    });

    lib.linkLibC();

    b.installArtifact(lib);
}

const flags = [_][]const u8{
    "-std=c99",
};

const sources = [_][]const u8{
    "src/aabb2d.c",
    "src/affine.c",
    "src/affine2d.c",
    "src/bezier.c",
    "src/box.c",
    "src/cam.c",
    "src/clipspace/ortho_lh_no.c",
    "src/clipspace/ortho_lh_zo.c",
    "src/clipspace/ortho_rh_no.c",
    "src/clipspace/ortho_rh_zo.c",
    "src/clipspace/persp_lh_no.c",
    "src/clipspace/persp_lh_zo.c",
    "src/clipspace/persp_rh_no.c",
    "src/clipspace/persp_rh_zo.c",
    "src/clipspace/project_no.c",
    "src/clipspace/project_zo.c",
    "src/clipspace/view_lh_no.c",
    "src/clipspace/view_lh_zo.c",
    "src/clipspace/view_rh_no.c",
    "src/clipspace/view_rh_zo.c",
    "src/config.h",
    "src/curve.c",
    "src/ease.c",
    "src/euler.c",
    "src/frustum.c",
    "src/io.c",
    "src/ivec2.c",
    "src/ivec3.c",
    "src/ivec4.c",
    "src/mat2.c",
    "src/mat2x3.c",
    "src/mat2x4.c",
    "src/mat3.c",
    "src/mat3x2.c",
    "src/mat3x4.c",
    "src/mat4.c",
    "src/mat4x2.c",
    "src/mat4x3.c",
    "src/plane.c",
    "src/project.c",
    "src/quat.c",
    "src/ray.c",
    "src/sphere.c",
    "src/swift/empty.c",
    "src/vec2.c",
    "src/vec3.c",
    "src/vec4.c",
};
