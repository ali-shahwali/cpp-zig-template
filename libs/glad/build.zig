const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "glad",
        .target = target,
        .optimize = optimize,
    });

    lib.installHeadersDirectory(b.path("glad/"), "glad", .{});
    lib.installHeadersDirectory(b.path("KHR/"), ".", .{});

    lib.addCSourceFile(.{
        .file = b.path("gl.c"),
        .flags = &.{"-std=c17"},
    });

    lib.linkLibC();

    b.installArtifact(lib);
}
