const std = @import("std");

const version = std.SemanticVersion{
    .major = 0,
    .minor = 9,
    .patch = 5,
};

const Build = enum {
    Shared,
    Static,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const cglm_shared = b.option(bool, "cglm_shared", "Build shared library") orelse false;
    const cglm_static = b.option(bool, "cglm_static", "Build static library") orelse false;
    const cglm_use_c99 = b.option(bool, "cglm_use_c99", "Build using c99 standard") orelse false;

    const cglm_build: Build = if (!cglm_static and cglm_shared) .Shared else if (cglm_static) .Static else .Shared;

    const lib = switch (cglm_build) {
        inline .Static => b.addStaticLibrary(.{
            .name = "cglm",
            .target = target,
            .optimize = optimize,
            .version = version,
        }),
        inline .Shared => b.addSharedLibrary(.{
            .name = "cglm",
            .target = target,
            .optimize = optimize,
            .version = version,
        }),
    };

    lib.linkLibC();

    lib.installHeadersDirectory(b.path("include/"), ".", .{});

    var flags = std.BoundedArray([]const u8, 16).init(0) catch unreachable;

    if (cglm_use_c99) flags.append("-std=c99") catch unreachable else flags.append("-std=c11") catch unreachable;

    switch (cglm_build) {
        inline .Static => flags.append("-DCGLM_STATIC") catch unreachable,
        inline .Shared => flags.append("-DCGLM_EXPORTS") catch unreachable,
    }

    lib.addCSourceFiles(.{
        .files = &sources,
        .flags = flags.slice(),
    });

    b.installArtifact(lib);

    const test_exe = b.addExecutable(.{
        .name = "cglm-test",
        .target = target,
        .optimize = optimize,
    });

    test_exe.linkLibC();
    test_exe.linkLibrary(lib);

    test_exe.addIncludePath(b.path("test/include"));

    test_exe.addCSourceFiles(.{
        .files = &test_sources,
        .flags = &.{"-DGLM_TESTS_NO_COLORFUL_OUTPUT"},
    });

    const run_test_cmd = b.addRunArtifact(test_exe);

    run_test_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_test_cmd.addArgs(args);
    }

    const run_test_step = b.step("test", "Run the tests");
    run_test_step.dependOn(&run_test_cmd.step);
}

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

const test_sources = [_][]const u8{
    "test/runner.c",
    "test/src/tests.c",
    "test/src/test_bezier.c",
    "test/src/test_clamp.c",
    "test/src/test_common.c",
    "test/src/test_euler.c",
    "test/src/test_struct.c",
};
