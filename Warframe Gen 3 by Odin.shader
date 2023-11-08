// Made by odin_v2
Shader "!Odin/WarframeGen3"
{
	Properties
	{
		[NoScaleOffset]_TintMap("TintMap", 2D) = "white" {}
		[NoScaleOffset]_DetailsPack("DetailsPack", 2D) = "white" {}
		[NoScaleOffset]_BumpMap1("NormalMap", 2D) = "bump" {}
		_NormalStrength("NormalStrength", Float) = 1
		[Toggle]_NormalEdgeDefine("NormalEdgeDefine", Float) = 0
		[Header(RedZone)]_RedTint("RedTint", Color) = (0.9528302,0.1393289,0.1393289,0)
		_RedTintGrime("RedTintGrime", Color) = (0.9528302,0.1393289,0.1393289,0)
		_RedTintRoughness("RedTintRoughness", Float) = 1
		_RedTintDarkRoughness("RedTintDarkRoughness", Float) = 0
		_RedzoneGrimeRoughness("RedzoneGrimeRoughness", Float) = 0
		_RedZonePackmap("RedZonePackmap", 2D) = "white" {}
		_RedZoneDetailNrm("RedZoneDetailNrm", 2D) = "white" {}
		_ColorZone1Nrm1("ColorZone1Nrm", Float) = 0
		[Header(GreenZone)]_GreenTint("GreenTint", Color) = (0.9528302,0.1393289,0.1393289,0)
		_GreenTintGrime("GreenTintGrime", Color) = (0.9528302,0.1393289,0.1393289,0)
		_GreenTintRoughness("GreenTintRoughness", Float) = 1
		_GreenTintDarkRoughness("GreenTintDarkRoughness", Float) = 0
		_GreenzoneGrimeRoughness("GreenzoneGrimeRoughness", Float) = 0
		_GreenZonePackmap("GreenZonePackmap", 2D) = "white" {}
		_GreenZoneDetailNrm("GreenZoneDetailNrm", 2D) = "white" {}
		_ColorZoneGreenNrm("ColorZoneGreenNrm", Float) = 0
		[Header(BlueZone)]_BlueTint("BlueTint", Color) = (0.9528302,0.1393289,0.1393289,0)
		_BlueTintGrime("BlueTintGrime", Color) = (0.9528302,0.1393289,0.1393289,0)
		_BlueTintRoughness("BlueTintRoughness", Float) = 1
		_BlueTintDarkRoughness("BlueTintDarkRoughness", Float) = 0
		_BlueZoneGrimeRoughness("BlueZoneGrimeRoughness", Float) = 0
		_BlueZonePackmap("BlueZonePackmap", 2D) = "white" {}
		_BlueZoneDetailNrm("BlueZoneDetailNrm", 2D) = "white" {}
		_ColorZoneBlueNrm("ColorZoneBlueNrm", Float) = 0
		[Header(BlackZone)]_BlackTint("BlackTint", Color) = (0.9528302,0.1393289,0.1393289,0)
		_BlackTintGrime("BlackTintGrime", Color) = (0.9528302,0.1393289,0.1393289,0)
		_BlackZoneRoughness("BlackZoneRoughness", Float) = 1
		_BlackZoneDarkRoughness("BlackZoneDarkRoughness", Float) = 0
		_BlackZoneGrimeRoughness("BlackZoneGrimeRoughness", Float) = 0
		_BlackZonePackmap("BlackZonePackmap", 2D) = "white" {}
		_BlackZoneDetailNrm("BlackZoneDetailNrm", 2D) = "white" {}
		_ColorZoneBlackNrm("ColorZoneBlackNrm", Float) = 0
		[Header(Emissions)]_EM("EM", 2D) = "white" {}
		[HDR]_Emission1("Emission1", Color) = (0,0,0,0)
		[HDR]_Emission2("Emission2", Color) = (0,0,0,0)
		_EmissionScrollY("EmissionScroll Y", Float) = 0
		_EmissionScrollX("EmissionScroll X", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex.SampleBias(samplerTex,coord,bias)
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex.SampleGrad(samplerTex,coord,ddx,ddy)
		#else
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex2Dbias(tex,float4(coord,0,bias))
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex2Dgrad(tex,coord,ddx,ddy)
		#endif

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _RedTint;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TintMap);
		SamplerState sampler_TintMap;
		uniform float4 _RedTintGrime;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailsPack);
		SamplerState sampler_DetailsPack;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_RedZonePackmap);
		uniform float4 _RedZonePackmap_ST;
		SamplerState sampler_RedZonePackmap;
		uniform float4 _GreenTint;
		uniform float4 _GreenTintGrime;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_GreenZonePackmap);
		uniform float4 _GreenZonePackmap_ST;
		SamplerState sampler_GreenZonePackmap;
		uniform float4 _BlueTint;
		uniform float4 _BlueTintGrime;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BlueZonePackmap);
		uniform float4 _BlueZonePackmap_ST;
		SamplerState sampler_BlueZonePackmap;
		uniform float4 _BlackTint;
		uniform float4 _BlackTintGrime;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BlackZonePackmap);
		uniform float4 _BlackZonePackmap_ST;
		SamplerState sampler_BlackZonePackmap;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap1);
		SamplerState sampler_BumpMap1;
		uniform float _NormalEdgeDefine;
		uniform float _NormalStrength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_RedZoneDetailNrm);
		uniform float4 _RedZoneDetailNrm_ST;
		SamplerState sampler_Linear_Repeat;
		uniform float _ColorZone1Nrm1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BlackZoneDetailNrm);
		uniform float4 _BlackZoneDetailNrm_ST;
		uniform float _ColorZoneBlackNrm;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_GreenZoneDetailNrm);
		uniform float4 _GreenZoneDetailNrm_ST;
		uniform float _ColorZoneGreenNrm;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BlueZoneDetailNrm);
		uniform float4 _BlueZoneDetailNrm_ST;
		uniform float _ColorZoneBlueNrm;
		uniform float _BlackZoneGrimeRoughness;
		uniform float _BlueZoneGrimeRoughness;
		uniform float _GreenzoneGrimeRoughness;
		uniform float _RedzoneGrimeRoughness;
		uniform float _RedTintDarkRoughness;
		uniform float _RedTintRoughness;
		uniform float _BlackZoneDarkRoughness;
		uniform float _BlackZoneRoughness;
		uniform float _GreenTintDarkRoughness;
		uniform float _GreenTintRoughness;
		uniform float _BlueTintDarkRoughness;
		uniform float _BlueTintRoughness;
		uniform float4 _Emission2;
		uniform float4 _Emission1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_EM);
		uniform float4 _EM_ST;
		SamplerState sampler_EM;
		uniform float _EmissionScrollX;
		uniform float _EmissionScrollY;


		half OneMinusReflectivity( half metallic )
		{
			   return OneMinusReflectivityFromMetallic(metallic);
		}


		float3 unity_SHArgb(  )
		{
			return float3(unity_SHAr.r,unity_SHAg.g,unity_SHAb.b);
		}


		inline float3 ASESafeNormalize(float3 inVec)
		{
			float dp3 = max( 0.001f , dot( inVec , inVec ) );
			return inVec* rsqrt( dp3);
		}


		float3 returnShadeSH9half4normal332_g211( float4 normal )
		{
			return ShadeSH9(half4(normal));
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_TintMap662 = i.uv_texcoord;
			float4 tex2DNode662 = SAMPLE_TEXTURE2D( _TintMap, sampler_TintMap, uv_TintMap662 );
			float temp_output_663_0 = ( tex2DNode662.r * 1.0 );
			float4 lerpResult678 = lerp( float4( 0,0,0,0 ) , _RedTint , temp_output_663_0);
			float2 uv_DetailsPack672 = i.uv_texcoord;
			float4 tex2DNode672 = SAMPLE_TEXTURE2D( _DetailsPack, sampler_DetailsPack, uv_DetailsPack672 );
			float temp_output_673_0 = ( tex2DNode672.r * 1.0 );
			float Grime793 = temp_output_673_0;
			float temp_output_797_0 = ( Grime793 * temp_output_663_0 );
			float4 lerpResult795 = lerp( float4( 0,0,0,0 ) , _RedTintGrime , temp_output_797_0);
			float2 uv_RedZonePackmap = i.uv_texcoord * _RedZonePackmap_ST.xy + _RedZonePackmap_ST.zw;
			float4 tex2DNode700 = SAMPLE_TEXTURE2D( _RedZonePackmap, sampler_RedZonePackmap, uv_RedZonePackmap );
			float RedTintZone668 = temp_output_663_0;
			float temp_output_664_0 = ( tex2DNode662.g * 1.0 );
			float4 lerpResult682 = lerp( float4( 0,0,0,0 ) , _GreenTint , temp_output_664_0);
			float temp_output_799_0 = ( Grime793 * tex2DNode662.g );
			float4 lerpResult798 = lerp( float4( 0,0,0,0 ) , _GreenTintGrime , temp_output_799_0);
			float2 uv_GreenZonePackmap = i.uv_texcoord * _GreenZonePackmap_ST.xy + _GreenZonePackmap_ST.zw;
			float4 tex2DNode843 = SAMPLE_TEXTURE2D( _GreenZonePackmap, sampler_GreenZonePackmap, uv_GreenZonePackmap );
			float temp_output_665_0 = ( tex2DNode662.b * 1.0 );
			float4 lerpResult683 = lerp( float4( 0,0,0,0 ) , _BlueTint , temp_output_665_0);
			float temp_output_802_0 = ( Grime793 * tex2DNode662.b );
			float4 lerpResult805 = lerp( float4( 0,0,0,0 ) , _BlueTintGrime , temp_output_802_0);
			float2 uv_BlueZonePackmap = i.uv_texcoord * _BlueZonePackmap_ST.xy + _BlueZonePackmap_ST.zw;
			float4 tex2DNode854 = SAMPLE_TEXTURE2D( _BlueZonePackmap, sampler_BlueZonePackmap, uv_BlueZonePackmap );
			float temp_output_667_0 = ( 1.0 - ( temp_output_664_0 + temp_output_665_0 + temp_output_663_0 ) );
			float4 lerpResult685 = lerp( float4( 0,0,0,0 ) , _BlackTint , temp_output_667_0);
			float temp_output_807_0 = ( Grime793 * temp_output_667_0 );
			float4 lerpResult809 = lerp( float4( 0,0,0,0 ) , _BlackTintGrime , temp_output_807_0);
			float2 uv_BlackZonePackmap = i.uv_texcoord * _BlackZonePackmap_ST.xy + _BlackZonePackmap_ST.zw;
			float4 tex2DNode766 = SAMPLE_TEXTURE2D( _BlackZonePackmap, sampler_BlackZonePackmap, uv_BlackZonePackmap );
			float BlackTintZone671 = temp_output_667_0;
			float4 ColorOutput874 = ( ( ( lerpResult678 + lerpResult795 ) * ( tex2DNode700.g * RedTintZone668 ) ) + ( ( lerpResult682 + lerpResult798 ) * tex2DNode843.g ) + ( ( lerpResult683 + lerpResult805 ) * tex2DNode854.g ) + ( ( lerpResult685 + lerpResult809 ) * ( tex2DNode766.g * BlackTintZone671 ) ) );
			float temp_output_675_0 = ( tex2DNode672.b * 1.0 );
			float4 temp_output_696_0 = ( ColorOutput874 * temp_output_675_0 );
			float GreenTintZone669 = temp_output_664_0;
			float BlueTintZone670 = temp_output_665_0;
			float temp_output_837_0 = ( ( tex2DNode766.r * BlackTintZone671 ) + ( tex2DNode700.r * RedTintZone668 ) + ( tex2DNode843.r * GreenTintZone669 ) + ( tex2DNode854.r * BlueTintZone670 ) );
			float3 temp_cast_12 = (temp_output_837_0).xxx;
			half3 specColor313_g210 = (0).xxx;
			half oneMinusReflectivity313_g210 = 0;
			half3 diffuseAndSpecularFromMetallic313_g210 = DiffuseAndSpecularFromMetallic(temp_output_696_0.rgb,temp_cast_12.x,specColor313_g210,oneMinusReflectivity313_g210);
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 
			float3 ase_worldlightDir = 0;
			#else 
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif 
			float3 lightDir14_g210 = ase_worldlightDir;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 viewDir15_g210 = ase_worldViewDir;
			float3 normalizeResult136_g210 = ASESafeNormalize( ( lightDir14_g210 + viewDir15_g210 ) );
			float dotResult137_g210 = dot( lightDir14_g210 , normalizeResult136_g210 );
			float LdotH139_g210 = saturate( dotResult137_g210 );
			float temp_output_891_0 = ( ( temp_output_807_0 * _BlackZoneGrimeRoughness ) + ( temp_output_802_0 * _BlueZoneGrimeRoughness ) + ( temp_output_799_0 * _GreenzoneGrimeRoughness ) + ( temp_output_797_0 * _RedzoneGrimeRoughness ) );
			float lerpResult789 = lerp( _RedTintDarkRoughness , _RedTintRoughness , tex2DNode700.b);
			float lerpResult781 = lerp( _BlackZoneDarkRoughness , _BlackZoneRoughness , tex2DNode766.b);
			float lerpResult839 = lerp( _GreenTintDarkRoughness , _GreenTintRoughness , tex2DNode843.b);
			float lerpResult856 = lerp( _BlueTintDarkRoughness , _BlueTintRoughness , tex2DNode854.b);
			float temp_output_769_0 = ( ( lerpResult789 * RedTintZone668 ) + ( ( lerpResult781 * 1.0 ) * BlackTintZone671 ) + ( lerpResult839 * GreenTintZone669 ) + ( lerpResult856 * BlueTintZone670 ) );
			float lerpResult892 = lerp( temp_output_891_0 , temp_output_769_0 , 0.5);
			float lerpResult893 = lerp( temp_output_891_0 , temp_output_769_0 , 0.5);
			float temp_output_895_0 = saturate( ( lerpResult892 + lerpResult893 ) );
			float smoothness169_g210 = temp_output_895_0;
			float perceprualRoughness188_g210 = ( 1.0 - smoothness169_g210 );
			half fd90273_g210 = ( 0.5 + ( 2.0 * LdotH139_g210 * LdotH139_g210 * perceprualRoughness188_g210 ) );
			float2 uv_BumpMap1695 = i.uv_texcoord;
			float EdgeMap741 = ( tex2DNode672.a * 1.0 );
			float3 tex2DNode695 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BumpMap1, sampler_BumpMap1, uv_BumpMap1695 ), (( _NormalEdgeDefine )?( ( EdgeMap741 * _NormalStrength ) ):( _NormalStrength )) );
			float3 appendResult692 = (float3(tex2DNode695.r , -tex2DNode695.g , 1.0));
			float2 uv_RedZoneDetailNrm = i.uv_texcoord * _RedZoneDetailNrm_ST.xy + _RedZoneDetailNrm_ST.zw;
			float3 localUnpackNormal708 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _RedZoneDetailNrm, sampler_Linear_Repeat, uv_RedZoneDetailNrm ), ( RedTintZone668 * _ColorZone1Nrm1 ) );
			float3 appendResult714 = (float3(localUnpackNormal708.x , 0.0 , 1.0));
			float2 uv_BlackZoneDetailNrm = i.uv_texcoord * _BlackZoneDetailNrm_ST.xy + _BlackZoneDetailNrm_ST.zw;
			float3 localUnpackNormal770 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BlackZoneDetailNrm, sampler_Linear_Repeat, uv_BlackZoneDetailNrm ), ( BlackTintZone671 * _ColorZoneBlackNrm ) );
			float3 appendResult774 = (float3(localUnpackNormal770.x , 0.0 , 1.0));
			float2 uv_GreenZoneDetailNrm = i.uv_texcoord * _GreenZoneDetailNrm_ST.xy + _GreenZoneDetailNrm_ST.zw;
			float3 localUnpackNormal814 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _GreenZoneDetailNrm, sampler_Linear_Repeat, uv_GreenZoneDetailNrm ), ( GreenTintZone669 * _ColorZoneGreenNrm ) );
			float3 appendResult818 = (float3(localUnpackNormal814.x , 0.0 , 1.0));
			float2 uv_BlueZoneDetailNrm = i.uv_texcoord * _BlueZoneDetailNrm_ST.xy + _BlueZoneDetailNrm_ST.zw;
			float3 localUnpackNormal825 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BlueZoneDetailNrm, sampler_Linear_Repeat, uv_BlueZoneDetailNrm ), ( BlueTintZone670 * _ColorZoneBlueNrm ) );
			float3 appendResult829 = (float3(localUnpackNormal825.x , 0.0 , 1.0));
			float3 NMAP744 = BlendNormals( BlendNormals( BlendNormals( BlendNormals( appendResult692 , saturate( appendResult714 ) ) , saturate( appendResult774 ) ) , saturate( appendResult818 ) ) , saturate( appendResult829 ) );
			float3 temp_output_30_0_g210 = NMAP744;
			float3 normalizeResult25_g210 = normalize( (WorldNormalVector( i , temp_output_30_0_g210 )) );
			float3 normalDir28_g210 = normalizeResult25_g210;
			float dotResult21_g210 = dot( lightDir14_g210 , normalDir28_g210 );
			float NdotL20_g210 = saturate( dotResult21_g210 );
			half lightScatter253_g210 = ( ( ( fd90273_g210 - 1.0 ) * pow( ( 1.0 - NdotL20_g210 ) , 5.0 ) ) + 1.0 );
			float dotResult56_g210 = dot( normalDir28_g210 , viewDir15_g210 );
			float NdotV55_g210 = saturate( dotResult56_g210 );
			half viewScatter254_g210 = ( 1.0 + ( pow( ( 1.0 - NdotV55_g210 ) , 5.0 ) * ( fd90273_g210 - 1.0 ) ) );
			half disneydiffuse251_g210 = ( lightScatter253_g210 * viewScatter254_g210 );
			half Diffuseterm281_g210 = ( disneydiffuse251_g210 * NdotL20_g210 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 lightAtten296_g210 = ( ase_lightColor.rgb * ase_lightAtten );
			float3 normal198_g210 = temp_output_30_0_g210;
			UnityGI gi203_g210 = gi;
			float3 diffNorm203_g210 = normalize( WorldNormalVector( i , normal198_g210 ) );
			gi203_g210 = UnityGI_Base( data, 1, diffNorm203_g210 );
			float3 indirectDiffuse203_g210 = gi203_g210.indirect.diffuse + diffNorm203_g210 * 0.0001;
			float occlusion306_g210 = temp_output_675_0;
			half Roughness64_g210 = max( ( perceprualRoughness188_g210 * perceprualRoughness188_g210 ) , 0.002 );
			half SmithJointGGXVisibilityTerm42_g210 = ( 0.5 / ( ( ( ( NdotV55_g210 * ( 1.0 - Roughness64_g210 ) ) + Roughness64_g210 ) * NdotL20_g210 ) + 1E-05 + ( NdotV55_g210 * ( Roughness64_g210 + ( ( 1.0 - Roughness64_g210 ) * NdotL20_g210 ) ) ) ) );
			float a266_g210 = ( Roughness64_g210 * Roughness64_g210 );
			float3 normalizeResult87_g210 = ASESafeNormalize( ( lightDir14_g210 + viewDir15_g210 ) );
			float dotResult88_g210 = dot( normalDir28_g210 , normalizeResult87_g210 );
			float NdotH90_g210 = saturate( dotResult88_g210 );
			float d99_g210 = ( ( ( ( NdotH90_g210 * a266_g210 ) - NdotH90_g210 ) * NdotH90_g210 ) + 1.0 );
			half GGXTerm43_g210 = ( ( ( 1.0 / UNITY_PI ) * a266_g210 ) / ( ( d99_g210 * d99_g210 ) + 1E-07 ) );
			float temp_output_36_0_g210 = ( SmithJointGGXVisibilityTerm42_g210 * GGXTerm43_g210 * UNITY_PI );
			#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch5_g210 = sqrt( max( 0.0001 , temp_output_36_0_g210 ) );
			#else
				float staticSwitch5_g210 = temp_output_36_0_g210;
			#endif
			#ifdef _SPECULARHIGHLIGHTS_OFF
				float staticSwitch119_g210 = 0.0;
			#else
				float staticSwitch119_g210 = max( 0.0 , ( staticSwitch5_g210 * NdotL20_g210 ) );
			#endif
			float3 SpecColor140_g210 = specColor313_g210;
			float SpecularTerm34_g210 = ( staticSwitch119_g210 * ( SpecColor140_g210.x == float3( 0,0,0 ) ? 0.0 : 1.0 ) );
			half3 FresnelTerm130_g210 = ( ( pow( ( 1.0 - LdotH139_g210 ) , 5.0 ) * ( 1.0 - SpecColor140_g210 ) ) + SpecColor140_g210 );
			half metallic176_g210 = 0.0;
			half localOneMinusReflectivity176_g210 = OneMinusReflectivity( metallic176_g210 );
			half GrazingTerm163_g210 = saturate( ( smoothness169_g210 + ( 1.0 - localOneMinusReflectivity176_g210 ) ) );
			float3 temp_cast_19 = (GrazingTerm163_g210).xxx;
			float3 lerpResult159_g210 = lerp( SpecColor140_g210 , temp_cast_19 , pow( ( 1.0 - NdotV55_g210 ) , 5.0 ));
			half3 FresnelLerp165_g210 = lerpResult159_g210;
			#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch183_g210 = ( 1.0 - ( 0.28 * Roughness64_g210 * perceprualRoughness188_g210 ) );
			#else
				float staticSwitch183_g210 = ( 1.0 / ( ( Roughness64_g210 * Roughness64_g210 ) + 1.0 ) );
			#endif
			half SurfaceReduction182_g210 = staticSwitch183_g210;
			float3 indirectNormal299_g210 = normalize( WorldNormalVector( i , normal198_g210 ) );
			Unity_GlossyEnvironmentData g299_g210 = UnityGlossyEnvironmentSetup( smoothness169_g210, data.worldViewDir, indirectNormal299_g210, float3(0,0,0));
			float3 indirectSpecular299_g210 = UnityGI_IndirectSpecular( data, occlusion306_g210, indirectNormal299_g210, g299_g210 );
			#ifdef UNITY_PASS_FORWARDADD
				float3 staticSwitch305_g210 = float3( 0,0,0 );
			#else
				float3 staticSwitch305_g210 = ( FresnelLerp165_g210 * SurfaceReduction182_g210 * indirectSpecular299_g210 );
			#endif
			c.rgb = ( float4( ( ( diffuseAndSpecularFromMetallic313_g210 * ( ( Diffuseterm281_g210 * lightAtten296_g210 ) + ( indirectDiffuse203_g210 * occlusion306_g210 ) ) ) + ( SpecularTerm34_g210 * lightAtten296_g210 * FresnelTerm130_g210 ) + staticSwitch305_g210 ) , 0.0 ) * ( i.vertexColor + float4( 0,0,0,0 ) ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_TintMap662 = i.uv_texcoord;
			float4 tex2DNode662 = SAMPLE_TEXTURE2D( _TintMap, sampler_TintMap, uv_TintMap662 );
			float temp_output_663_0 = ( tex2DNode662.r * 1.0 );
			float4 lerpResult678 = lerp( float4( 0,0,0,0 ) , _RedTint , temp_output_663_0);
			float2 uv_DetailsPack672 = i.uv_texcoord;
			float4 tex2DNode672 = SAMPLE_TEXTURE2D( _DetailsPack, sampler_DetailsPack, uv_DetailsPack672 );
			float temp_output_673_0 = ( tex2DNode672.r * 1.0 );
			float Grime793 = temp_output_673_0;
			float temp_output_797_0 = ( Grime793 * temp_output_663_0 );
			float4 lerpResult795 = lerp( float4( 0,0,0,0 ) , _RedTintGrime , temp_output_797_0);
			float2 uv_RedZonePackmap = i.uv_texcoord * _RedZonePackmap_ST.xy + _RedZonePackmap_ST.zw;
			float4 tex2DNode700 = SAMPLE_TEXTURE2D( _RedZonePackmap, sampler_RedZonePackmap, uv_RedZonePackmap );
			float RedTintZone668 = temp_output_663_0;
			float temp_output_664_0 = ( tex2DNode662.g * 1.0 );
			float4 lerpResult682 = lerp( float4( 0,0,0,0 ) , _GreenTint , temp_output_664_0);
			float temp_output_799_0 = ( Grime793 * tex2DNode662.g );
			float4 lerpResult798 = lerp( float4( 0,0,0,0 ) , _GreenTintGrime , temp_output_799_0);
			float2 uv_GreenZonePackmap = i.uv_texcoord * _GreenZonePackmap_ST.xy + _GreenZonePackmap_ST.zw;
			float4 tex2DNode843 = SAMPLE_TEXTURE2D( _GreenZonePackmap, sampler_GreenZonePackmap, uv_GreenZonePackmap );
			float temp_output_665_0 = ( tex2DNode662.b * 1.0 );
			float4 lerpResult683 = lerp( float4( 0,0,0,0 ) , _BlueTint , temp_output_665_0);
			float temp_output_802_0 = ( Grime793 * tex2DNode662.b );
			float4 lerpResult805 = lerp( float4( 0,0,0,0 ) , _BlueTintGrime , temp_output_802_0);
			float2 uv_BlueZonePackmap = i.uv_texcoord * _BlueZonePackmap_ST.xy + _BlueZonePackmap_ST.zw;
			float4 tex2DNode854 = SAMPLE_TEXTURE2D( _BlueZonePackmap, sampler_BlueZonePackmap, uv_BlueZonePackmap );
			float temp_output_667_0 = ( 1.0 - ( temp_output_664_0 + temp_output_665_0 + temp_output_663_0 ) );
			float4 lerpResult685 = lerp( float4( 0,0,0,0 ) , _BlackTint , temp_output_667_0);
			float temp_output_807_0 = ( Grime793 * temp_output_667_0 );
			float4 lerpResult809 = lerp( float4( 0,0,0,0 ) , _BlackTintGrime , temp_output_807_0);
			float2 uv_BlackZonePackmap = i.uv_texcoord * _BlackZonePackmap_ST.xy + _BlackZonePackmap_ST.zw;
			float4 tex2DNode766 = SAMPLE_TEXTURE2D( _BlackZonePackmap, sampler_BlackZonePackmap, uv_BlackZonePackmap );
			float BlackTintZone671 = temp_output_667_0;
			float4 ColorOutput874 = ( ( ( lerpResult678 + lerpResult795 ) * ( tex2DNode700.g * RedTintZone668 ) ) + ( ( lerpResult682 + lerpResult798 ) * tex2DNode843.g ) + ( ( lerpResult683 + lerpResult805 ) * tex2DNode854.g ) + ( ( lerpResult685 + lerpResult809 ) * ( tex2DNode766.g * BlackTintZone671 ) ) );
			float temp_output_675_0 = ( tex2DNode672.b * 1.0 );
			float4 temp_output_696_0 = ( ColorOutput874 * temp_output_675_0 );
			o.Albedo = temp_output_696_0.rgb;
			float2 uv_BumpMap1695 = i.uv_texcoord;
			float EdgeMap741 = ( tex2DNode672.a * 1.0 );
			float3 tex2DNode695 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BumpMap1, sampler_BumpMap1, uv_BumpMap1695 ), (( _NormalEdgeDefine )?( ( EdgeMap741 * _NormalStrength ) ):( _NormalStrength )) );
			float3 appendResult692 = (float3(tex2DNode695.r , -tex2DNode695.g , 1.0));
			float2 uv_RedZoneDetailNrm = i.uv_texcoord * _RedZoneDetailNrm_ST.xy + _RedZoneDetailNrm_ST.zw;
			float3 localUnpackNormal708 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _RedZoneDetailNrm, sampler_Linear_Repeat, uv_RedZoneDetailNrm ), ( RedTintZone668 * _ColorZone1Nrm1 ) );
			float3 appendResult714 = (float3(localUnpackNormal708.x , 0.0 , 1.0));
			float2 uv_BlackZoneDetailNrm = i.uv_texcoord * _BlackZoneDetailNrm_ST.xy + _BlackZoneDetailNrm_ST.zw;
			float3 localUnpackNormal770 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BlackZoneDetailNrm, sampler_Linear_Repeat, uv_BlackZoneDetailNrm ), ( BlackTintZone671 * _ColorZoneBlackNrm ) );
			float3 appendResult774 = (float3(localUnpackNormal770.x , 0.0 , 1.0));
			float2 uv_GreenZoneDetailNrm = i.uv_texcoord * _GreenZoneDetailNrm_ST.xy + _GreenZoneDetailNrm_ST.zw;
			float GreenTintZone669 = temp_output_664_0;
			float3 localUnpackNormal814 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _GreenZoneDetailNrm, sampler_Linear_Repeat, uv_GreenZoneDetailNrm ), ( GreenTintZone669 * _ColorZoneGreenNrm ) );
			float3 appendResult818 = (float3(localUnpackNormal814.x , 0.0 , 1.0));
			float2 uv_BlueZoneDetailNrm = i.uv_texcoord * _BlueZoneDetailNrm_ST.xy + _BlueZoneDetailNrm_ST.zw;
			float BlueTintZone670 = temp_output_665_0;
			float3 localUnpackNormal825 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _BlueZoneDetailNrm, sampler_Linear_Repeat, uv_BlueZoneDetailNrm ), ( BlueTintZone670 * _ColorZoneBlueNrm ) );
			float3 appendResult829 = (float3(localUnpackNormal825.x , 0.0 , 1.0));
			float3 NMAP744 = BlendNormals( BlendNormals( BlendNormals( BlendNormals( appendResult692 , saturate( appendResult714 ) ) , saturate( appendResult774 ) ) , saturate( appendResult818 ) ) , saturate( appendResult829 ) );
			float3 temp_output_30_0_g211 = NMAP744;
			float3 normalizeResult25_g211 = normalize( (WorldNormalVector( i , temp_output_30_0_g211 )) );
			float3 normalDir28_g211 = normalizeResult25_g211;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 viewDir15_g211 = ase_worldViewDir;
			float dotResult56_g211 = dot( normalDir28_g211 , viewDir15_g211 );
			float NdotV55_g211 = saturate( dotResult56_g211 );
			float temp_output_891_0 = ( ( temp_output_807_0 * _BlackZoneGrimeRoughness ) + ( temp_output_802_0 * _BlueZoneGrimeRoughness ) + ( temp_output_799_0 * _GreenzoneGrimeRoughness ) + ( temp_output_797_0 * _RedzoneGrimeRoughness ) );
			float lerpResult789 = lerp( _RedTintDarkRoughness , _RedTintRoughness , tex2DNode700.b);
			float lerpResult781 = lerp( _BlackZoneDarkRoughness , _BlackZoneRoughness , tex2DNode766.b);
			float lerpResult839 = lerp( _GreenTintDarkRoughness , _GreenTintRoughness , tex2DNode843.b);
			float lerpResult856 = lerp( _BlueTintDarkRoughness , _BlueTintRoughness , tex2DNode854.b);
			float temp_output_769_0 = ( ( lerpResult789 * RedTintZone668 ) + ( ( lerpResult781 * 1.0 ) * BlackTintZone671 ) + ( lerpResult839 * GreenTintZone669 ) + ( lerpResult856 * BlueTintZone670 ) );
			float lerpResult892 = lerp( temp_output_891_0 , temp_output_769_0 , 0.5);
			float lerpResult893 = lerp( temp_output_891_0 , temp_output_769_0 , 0.5);
			float temp_output_895_0 = saturate( ( lerpResult892 + lerpResult893 ) );
			float smoothness169_g211 = temp_output_895_0;
			float perceprualRoughness188_g211 = ( 1.0 - smoothness169_g211 );
			half Roughness64_g211 = max( ( perceprualRoughness188_g211 * perceprualRoughness188_g211 ) , 0.002 );
			float3 localunity_SHArgb326_g211 = unity_SHArgb();
			float3 normalizeResult322_g211 = ASESafeNormalize( localunity_SHArgb326_g211 );
			float3 LightProbeDir330_g211 = normalizeResult322_g211;
			float3 lightDir14_g211 = LightProbeDir330_g211;
			float dotResult21_g211 = dot( lightDir14_g211 , normalDir28_g211 );
			float NdotL20_g211 = saturate( dotResult21_g211 );
			half SmithJointGGXVisibilityTerm42_g211 = ( 0.5 / ( ( ( ( NdotV55_g211 * ( 1.0 - Roughness64_g211 ) ) + Roughness64_g211 ) * NdotL20_g211 ) + 1E-05 + ( NdotV55_g211 * ( Roughness64_g211 + ( ( 1.0 - Roughness64_g211 ) * NdotL20_g211 ) ) ) ) );
			float a266_g211 = ( Roughness64_g211 * Roughness64_g211 );
			float3 normalizeResult87_g211 = ASESafeNormalize( ( lightDir14_g211 + viewDir15_g211 ) );
			float dotResult88_g211 = dot( normalDir28_g211 , normalizeResult87_g211 );
			float NdotH90_g211 = saturate( dotResult88_g211 );
			float d99_g211 = ( ( ( ( NdotH90_g211 * a266_g211 ) - NdotH90_g211 ) * NdotH90_g211 ) + 1.0 );
			half GGXTerm43_g211 = ( ( ( 1.0 / UNITY_PI ) * a266_g211 ) / ( ( d99_g211 * d99_g211 ) + 1E-07 ) );
			float temp_output_36_0_g211 = ( SmithJointGGXVisibilityTerm42_g211 * GGXTerm43_g211 * UNITY_PI );
			#ifdef UNITY_COLORSPACE_GAMMA
				float staticSwitch5_g211 = sqrt( 0.0 );
			#else
				float staticSwitch5_g211 = temp_output_36_0_g211;
			#endif
			#ifdef _SPECULARHIGHLIGHTS_OFF
				float staticSwitch119_g211 = 0.0;
			#else
				float staticSwitch119_g211 = max( 0.0 , ( staticSwitch5_g211 * NdotL20_g211 ) );
			#endif
			float temp_output_837_0 = ( ( tex2DNode766.r * BlackTintZone671 ) + ( tex2DNode700.r * RedTintZone668 ) + ( tex2DNode843.r * GreenTintZone669 ) + ( tex2DNode854.r * BlueTintZone670 ) );
			float3 temp_cast_6 = (temp_output_837_0).xxx;
			half3 specColor314_g211 = (0).xxx;
			half oneMinusReflectivity314_g211 = 0;
			half3 diffuseAndSpecularFromMetallic314_g211 = DiffuseAndSpecularFromMetallic(ColorOutput874.rgb,temp_cast_6.x,specColor314_g211,oneMinusReflectivity314_g211);
			float3 SpecColor140_g211 = specColor314_g211;
			float SpecularTerm34_g211 = ( staticSwitch119_g211 * ( SpecColor140_g211.x == float3( 0,0,0 ) ? 0.0 : 1.0 ) );
			float4 appendResult329_g211 = (float4(LightProbeDir330_g211 , 1.0));
			float4 normal332_g211 = appendResult329_g211;
			float3 localreturnShadeSH9half4normal332_g211 = returnShadeSH9half4normal332_g211( normal332_g211 );
			float3 normalizeResult136_g211 = ASESafeNormalize( ( lightDir14_g211 + viewDir15_g211 ) );
			float dotResult137_g211 = dot( lightDir14_g211 , normalizeResult136_g211 );
			float LdotH139_g211 = saturate( dotResult137_g211 );
			half3 FresnelTerm130_g211 = ( ( pow( ( 1.0 - LdotH139_g211 ) , 5.0 ) * ( 1.0 - SpecColor140_g211 ) ) + SpecColor140_g211 );
			float2 uv_EM = i.uv_texcoord * _EM_ST.xy + _EM_ST.zw;
			float4 tex2DNode869 = SAMPLE_TEXTURE2D( _EM, sampler_EM, uv_EM );
			float4 lerpResult861 = lerp( _Emission2 , _Emission1 , tex2DNode869.r);
			float mulTime871 = _Time.y * _EmissionScrollX;
			float mulTime867 = _Time.y * _EmissionScrollY;
			float2 appendResult866 = (float2(mulTime871 , mulTime867));
			float2 uv_TexCoord864 = i.uv_texcoord + appendResult866;
			float4 EmissionResult879 = ( ( lerpResult861 * tex2DNode869.r ) * ( SAMPLE_TEXTURE2D( _EM, sampler_EM, uv_TexCoord864 ).g * 1.0 ) );
			o.Emission = ( float4( ( SpecularTerm34_g211 * max( localreturnShadeSH9half4normal332_g211 , float3( 0,0,0 ) ) * FresnelTerm130_g211 ) , 0.0 ) + EmissionResult879 ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}