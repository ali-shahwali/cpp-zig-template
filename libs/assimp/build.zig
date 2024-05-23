const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "assimp",
        .target = target,
        .optimize = optimize,
    });

    lib.linkLibC();
    lib.linkLibCpp();

    const config_h = b.addConfigHeader(.{
        .style = .{
            .cmake = b.path("include/assimp/config.h.in"),
        },
        .include_path = "assimp/config.h",
    }, .{});

    lib.addConfigHeader(config_h);
    lib.installConfigHeader(config_h);

    const zlib_config_h = b.addConfigHeader(.{
        .style = .{
            .cmake = b.path("contrib/zlib/zconf.h.in"),
        },
        .include_path = "zconf.h",
    }, .{});
    lib.addConfigHeader(zlib_config_h);
    lib.installConfigHeader(zlib_config_h);

    lib.addIncludePath(b.path(""));

    lib.addIncludePath(b.path("include"));

    lib.addIncludePath(b.path("contrib"));
    lib.addIncludePath(b.path("contrib/pugixml/src"));
    lib.addIncludePath(b.path("contrib/poly2tri"));
    lib.addIncludePath(b.path("contrib/rapidjson/include"));
    lib.addIncludePath(b.path("contrib/unzip"));
    lib.addIncludePath(b.path("contrib/zlib"));
    lib.addIncludePath(b.path("contrib/utf8cpp/source"));
    lib.addIncludePath(b.path("contrib/unzip"));
    lib.addIncludePath(b.path("contrib/openddlparser/include"));

    lib.addIncludePath(b.path("code"));

    lib.defineCMacro("RAPIDJSON_HAS_STDSTRING", "1");

    lib.installHeadersDirectory(b.path("include/assimp"), "assimp", .{
        .include_extensions = &.{ ".inl", ".h", ".hpp" },
    });
    lib.installHeadersDirectory(b.path("code"), ".", .{});
    lib.installHeadersDirectory(b.path("contrib"), "contrib", .{});

    const flags = [_][]const u8{};

    lib.addCSourceFiles(.{
        .files = &sources,
        .flags = &flags,
    });

    lib.addCSourceFiles(.{
        .files = &contrib_sources,
        .flags = &flags,
    });

    // msvc only
    lib.defineCMacro("ASSIMP_BUILD_NO_C4D_IMPORTER", null);
    lib.defineCMacro("ASSIMP_BUILD_NO_C4D_EXPORTER", null);

    lib.defineCMacro("ASSIMP_BUILD_NO_IFC_IMPORTER", null);
    lib.defineCMacro("ASSIMP_BUILD_NO_IFC_EXPORTER", null);

    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "code/AssetLib/3DS/3DSConverter.cpp",
    "code/AssetLib/3DS/3DSExporter.cpp",
    "code/AssetLib/3DS/3DSLoader.cpp",
    "code/AssetLib/3MF/D3MFExporter.cpp",
    "code/AssetLib/3MF/D3MFImporter.cpp",
    "code/AssetLib/3MF/D3MFOpcPackage.cpp",
    "code/AssetLib/3MF/XmlSerializer.cpp",
    "code/AssetLib/AC/ACLoader.cpp",
    "code/AssetLib/AMF/AMFImporter.cpp",
    "code/AssetLib/AMF/AMFImporter_Geometry.cpp",
    "code/AssetLib/AMF/AMFImporter_Material.cpp",
    "code/AssetLib/AMF/AMFImporter_Postprocess.cpp",
    "code/AssetLib/ASE/ASELoader.cpp",
    "code/AssetLib/ASE/ASEParser.cpp",
    "code/AssetLib/Assbin/AssbinExporter.cpp",
    "code/AssetLib/Assbin/AssbinFileWriter.cpp",
    "code/AssetLib/Assbin/AssbinLoader.cpp",
    "code/AssetLib/Assjson/json_exporter.cpp",
    "code/AssetLib/Assjson/mesh_splitter.cpp",
    "code/AssetLib/Assxml/AssxmlExporter.cpp",
    "code/AssetLib/Assxml/AssxmlFileWriter.cpp",
    "code/AssetLib/B3D/B3DImporter.cpp",
    "code/AssetLib/Blender/BlenderBMesh.cpp",
    "code/AssetLib/Blender/BlenderCustomData.cpp",
    "code/AssetLib/Blender/BlenderDNA.cpp",
    "code/AssetLib/Blender/BlenderLoader.cpp",
    "code/AssetLib/Blender/BlenderModifier.cpp",
    "code/AssetLib/Blender/BlenderScene.cpp",
    "code/AssetLib/Blender/BlenderTessellator.cpp",
    "code/AssetLib/BVH/BVHLoader.cpp",
    "code/AssetLib/C4D/C4DImporter.cpp",
    "code/AssetLib/COB/COBLoader.cpp",
    "code/AssetLib/Collada/ColladaExporter.cpp",
    "code/AssetLib/Collada/ColladaHelper.cpp",
    "code/AssetLib/Collada/ColladaLoader.cpp",
    "code/AssetLib/Collada/ColladaParser.cpp",
    "code/AssetLib/CSM/CSMLoader.cpp",
    "code/AssetLib/DXF/DXFLoader.cpp",
    "code/AssetLib/FBX/FBXAnimation.cpp",
    "code/AssetLib/FBX/FBXBinaryTokenizer.cpp",
    "code/AssetLib/FBX/FBXConverter.cpp",
    "code/AssetLib/FBX/FBXDeformer.cpp",
    "code/AssetLib/FBX/FBXDocument.cpp",
    "code/AssetLib/FBX/FBXDocumentUtil.cpp",
    "code/AssetLib/FBX/FBXExporter.cpp",
    "code/AssetLib/FBX/FBXExportNode.cpp",
    "code/AssetLib/FBX/FBXExportProperty.cpp",
    "code/AssetLib/FBX/FBXImporter.cpp",
    "code/AssetLib/FBX/FBXMaterial.cpp",
    "code/AssetLib/FBX/FBXMeshGeometry.cpp",
    "code/AssetLib/FBX/FBXModel.cpp",
    "code/AssetLib/FBX/FBXNodeAttribute.cpp",
    "code/AssetLib/FBX/FBXParser.cpp",
    "code/AssetLib/FBX/FBXProperties.cpp",
    "code/AssetLib/FBX/FBXTokenizer.cpp",
    "code/AssetLib/FBX/FBXUtil.cpp",
    "code/AssetLib/glTF/glTFCommon.cpp",
    "code/AssetLib/glTF/glTFExporter.cpp",
    "code/AssetLib/glTF/glTFImporter.cpp",
    "code/AssetLib/glTF2/glTF2Exporter.cpp",
    "code/AssetLib/glTF2/glTF2Importer.cpp",
    "code/AssetLib/HMP/HMPLoader.cpp",
    "code/AssetLib/IFC/IFCBoolean.cpp",
    "code/AssetLib/IFC/IFCCurve.cpp",
    "code/AssetLib/IFC/IFCGeometry.cpp",
    "code/AssetLib/IFC/IFCLoader.cpp",
    "code/AssetLib/IFC/IFCMaterial.cpp",
    "code/AssetLib/IFC/IFCOpenings.cpp",
    "code/AssetLib/IFC/IFCProfile.cpp",
    "code/AssetLib/IFC/IFCReaderGen1_2x3.cpp",
    "code/AssetLib/IFC/IFCReaderGen2_2x3.cpp",
    "code/AssetLib/IFC/IFCReaderGen_4.cpp",
    "code/AssetLib/IFC/IFCUtil.cpp",
    "code/AssetLib/IQM/IQMImporter.cpp",
    "code/AssetLib/Irr/IRRLoader.cpp",
    "code/AssetLib/Irr/IRRMeshLoader.cpp",
    "code/AssetLib/Irr/IRRShared.cpp",
    "code/AssetLib/LWO/LWOAnimation.cpp",
    "code/AssetLib/LWO/LWOBLoader.cpp",
    "code/AssetLib/LWO/LWOLoader.cpp",
    "code/AssetLib/LWO/LWOMaterial.cpp",
    "code/AssetLib/LWS/LWSLoader.cpp",
    "code/AssetLib/M3D/M3DExporter.cpp",
    "code/AssetLib/M3D/M3DImporter.cpp",
    "code/AssetLib/M3D/M3DWrapper.cpp",
    "code/AssetLib/MD2/MD2Loader.cpp",
    "code/AssetLib/MD3/MD3Loader.cpp",
    "code/AssetLib/MD5/MD5Loader.cpp",
    "code/AssetLib/MD5/MD5Parser.cpp",
    "code/AssetLib/MDC/MDCLoader.cpp",
    "code/AssetLib/MDL/HalfLife/HL1MDLLoader.cpp",
    "code/AssetLib/MDL/HalfLife/UniqueNameGenerator.cpp",
    "code/AssetLib/MDL/MDLLoader.cpp",
    "code/AssetLib/MDL/MDLMaterialLoader.cpp",
    "code/AssetLib/MMD/MMDImporter.cpp",
    "code/AssetLib/MMD/MMDPmxParser.cpp",
    "code/AssetLib/MS3D/MS3DLoader.cpp",
    "code/AssetLib/NDO/NDOLoader.cpp",
    "code/AssetLib/NFF/NFFLoader.cpp",
    "code/AssetLib/Obj/ObjExporter.cpp",
    "code/AssetLib/Obj/ObjFileImporter.cpp",
    "code/AssetLib/Obj/ObjFileMtlImporter.cpp",
    "code/AssetLib/Obj/ObjFileParser.cpp",
    "code/AssetLib/OFF/OFFLoader.cpp",
    "code/AssetLib/Ogre/OgreBinarySerializer.cpp",
    "code/AssetLib/Ogre/OgreImporter.cpp",
    "code/AssetLib/Ogre/OgreMaterial.cpp",
    "code/AssetLib/Ogre/OgreStructs.cpp",
    "code/AssetLib/Ogre/OgreXmlSerializer.cpp",
    "code/AssetLib/OpenGEX/OpenGEXExporter.cpp",
    "code/AssetLib/OpenGEX/OpenGEXImporter.cpp",
    "code/AssetLib/Ply/PlyExporter.cpp",
    "code/AssetLib/Ply/PlyLoader.cpp",
    "code/AssetLib/Ply/PlyParser.cpp",
    "code/AssetLib/Q3BSP/Q3BSPFileImporter.cpp",
    "code/AssetLib/Q3BSP/Q3BSPFileParser.cpp",
    "code/AssetLib/Q3D/Q3DLoader.cpp",
    "code/AssetLib/Raw/RawLoader.cpp",
    "code/AssetLib/SIB/SIBImporter.cpp",
    "code/AssetLib/SMD/SMDLoader.cpp",
    "code/AssetLib/Step/StepExporter.cpp",
    "code/AssetLib/STEPParser/STEPFileEncoding.cpp",
    "code/AssetLib/STEPParser/STEPFileReader.cpp",
    "code/AssetLib/STL/STLExporter.cpp",
    "code/AssetLib/STL/STLLoader.cpp",
    "code/AssetLib/Terragen/TerragenLoader.cpp",
    "code/AssetLib/Unreal/UnrealLoader.cpp",
    "code/AssetLib/X/XFileExporter.cpp",
    "code/AssetLib/X/XFileImporter.cpp",
    "code/AssetLib/X/XFileParser.cpp",
    "code/AssetLib/X3D/X3DExporter.cpp",
    "code/AssetLib/X3D/X3DGeoHelper.cpp",
    "code/AssetLib/X3D/X3DImporter.cpp",
    "code/AssetLib/X3D/X3DImporter_Geometry2D.cpp",
    "code/AssetLib/X3D/X3DImporter_Geometry3D.cpp",
    "code/AssetLib/X3D/X3DImporter_Group.cpp",
    "code/AssetLib/X3D/X3DImporter_Light.cpp",
    "code/AssetLib/X3D/X3DImporter_Metadata.cpp",
    "code/AssetLib/X3D/X3DImporter_Networking.cpp",
    "code/AssetLib/X3D/X3DImporter_Postprocess.cpp",
    "code/AssetLib/X3D/X3DImporter_Rendering.cpp",
    "code/AssetLib/X3D/X3DImporter_Shape.cpp",
    "code/AssetLib/X3D/X3DImporter_Texturing.cpp",
    "code/AssetLib/X3D/X3DXmlHelper.cpp",
    "code/AssetLib/XGL/XGLLoader.cpp",
    "code/CApi/AssimpCExport.cpp",
    "code/CApi/CInterfaceIOWrapper.cpp",
    "code/Common/AssertHandler.cpp",
    "code/Common/Assimp.cpp",
    "code/Common/Base64.cpp",
    "code/Common/BaseImporter.cpp",
    "code/Common/BaseProcess.cpp",
    "code/Common/Bitmap.cpp",
    "code/Common/Compression.cpp",
    "code/Common/CreateAnimMesh.cpp",
    "code/Common/DefaultIOStream.cpp",
    "code/Common/DefaultIOSystem.cpp",
    "code/Common/DefaultLogger.cpp",
    "code/Common/Exceptional.cpp",
    "code/Common/Exporter.cpp",
    "code/Common/Importer.cpp",
    "code/Common/ImporterRegistry.cpp",
    "code/Common/IOSystem.cpp",
    "code/Common/material.cpp",
    "code/Common/PostStepRegistry.cpp",
    "code/Common/RemoveComments.cpp",
    "code/Common/scene.cpp",
    "code/Common/SceneCombiner.cpp",
    "code/Common/ScenePreprocessor.cpp",
    "code/Common/SGSpatialSort.cpp",
    "code/Common/simd.cpp",
    "code/Common/SkeletonMeshBuilder.cpp",
    "code/Common/SpatialSort.cpp",
    "code/Common/StandardShapes.cpp",
    "code/Common/Subdivision.cpp",
    "code/Common/TargetAnimation.cpp",
    // "code/Common/Version.cpp",
    "code/Common/VertexTriangleAdjacency.cpp",
    "code/Common/ZipArchiveIOSystem.cpp",
    "code/Geometry/GeometryUtils.cpp",
    "code/Material/MaterialSystem.cpp",
    "code/Pbrt/PbrtExporter.cpp",
    "code/PostProcessing/ArmaturePopulate.cpp",
    "code/PostProcessing/CalcTangentsProcess.cpp",
    "code/PostProcessing/ComputeUVMappingProcess.cpp",
    "code/PostProcessing/ConvertToLHProcess.cpp",
    "code/PostProcessing/DeboneProcess.cpp",
    "code/PostProcessing/DropFaceNormalsProcess.cpp",
    "code/PostProcessing/EmbedTexturesProcess.cpp",
    "code/PostProcessing/FindDegenerates.cpp",
    "code/PostProcessing/FindInstancesProcess.cpp",
    "code/PostProcessing/FindInvalidDataProcess.cpp",
    "code/PostProcessing/FixNormalsStep.cpp",
    "code/PostProcessing/GenBoundingBoxesProcess.cpp",
    "code/PostProcessing/GenFaceNormalsProcess.cpp",
    "code/PostProcessing/GenVertexNormalsProcess.cpp",
    "code/PostProcessing/ImproveCacheLocality.cpp",
    "code/PostProcessing/JoinVerticesProcess.cpp",
    "code/PostProcessing/LimitBoneWeightsProcess.cpp",
    "code/PostProcessing/MakeVerboseFormat.cpp",
    "code/PostProcessing/OptimizeGraph.cpp",
    "code/PostProcessing/OptimizeMeshes.cpp",
    "code/PostProcessing/PretransformVertices.cpp",
    "code/PostProcessing/ProcessHelper.cpp",
    "code/PostProcessing/RemoveRedundantMaterials.cpp",
    "code/PostProcessing/RemoveVCProcess.cpp",
    "code/PostProcessing/ScaleProcess.cpp",
    "code/PostProcessing/SortByPTypeProcess.cpp",
    "code/PostProcessing/SplitByBoneCountProcess.cpp",
    "code/PostProcessing/SplitLargeMeshes.cpp",
    "code/PostProcessing/TextureTransform.cpp",
    "code/PostProcessing/TriangulateProcess.cpp",
    "code/PostProcessing/ValidateDataStructure.cpp",
};

const contrib_sources = [_][]const u8{
    "contrib/clipper/clipper.cpp",
    "contrib/Open3DGC/o3dgcArithmeticCodec.cpp",
    "contrib/Open3DGC/o3dgcDynamicVectorDecoder.cpp",
    "contrib/Open3DGC/o3dgcDynamicVectorEncoder.cpp",
    "contrib/Open3DGC/o3dgcTools.cpp",
    "contrib/Open3DGC/o3dgcTriangleFans.cpp",
    "contrib/openddlparser/code/DDLNode.cpp",
    "contrib/openddlparser/code/OpenDDLCommon.cpp",
    "contrib/openddlparser/code/OpenDDLExport.cpp",
    "contrib/openddlparser/code/OpenDDLParser.cpp",
    "contrib/openddlparser/code/OpenDDLStream.cpp",
    "contrib/openddlparser/code/Value.cpp",
    "contrib/pugixml/src/pugixml.cpp",
    "contrib/poly2tri/poly2tri/common/shapes.cc",
    "contrib/poly2tri/poly2tri/sweep/advancing_front.cc",
    "contrib/poly2tri/poly2tri/sweep/cdt.cc",
    "contrib/poly2tri/poly2tri/sweep/sweep.cc",
    "contrib/poly2tri/poly2tri/sweep/sweep_context.cc",
    "contrib/unzip/ioapi.c",
    "contrib/unzip/unzip.c",
    "contrib/zip/src/zip.c",
    "contrib/zlib/inflate.c",
    "contrib/zlib/infback.c",
    "contrib/zlib/gzclose.c",
    "contrib/zlib/gzread.c",
    "contrib/zlib/inftrees.c",
    "contrib/zlib/gzwrite.c",
    "contrib/zlib/compress.c",
    "contrib/zlib/inffast.c",
    "contrib/zlib/uncompr.c",
    "contrib/zlib/gzlib.c",
    "contrib/zlib/trees.c",
    "contrib/zlib/zutil.c",
    "contrib/zlib/deflate.c",
    "contrib/zlib/crc32.c",
    "contrib/zlib/adler32.c",
};
