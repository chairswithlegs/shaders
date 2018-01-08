using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TelevisionEffect : MonoBehaviour {

	//Adjustable shader properties
	[Range(0,10)]
	public float contrast = 1.0f;
	[Range(-1,1)]
	public float brightness = 0.0f;
	[Range(0,5)]
	public float luminosity = 1.0f;

	public Color color = Color.white;
	[Range(0,1)]
	public float colorAmount = 0.0f;

	public Texture2D scanLineTexture;
	[Range(0,10)]
	public float scanLineSize = 4.0f;
	[Range(-10,10)]
	public float scanLineSpeed = 1.0f;
	[Range(0,1)]
	public float scanLineAmount = 1.0f;

	public Texture2D noiseTexture;
	[Range(0,1)]
	public float noiseAmount = 1.0f;

	public Texture2D vignetteTexture;
	[Range(-1,1)]
	public float vignetteAmount = 1.0f;

	public float distortion = 0.0f;
	public float scale = 1.0f;


	//Required shader variables
	public Shader currentShader;
	private Material curMaterial;

	Material material {
		get {
			if (!curMaterial) {
				curMaterial = new Material (currentShader);
				curMaterial.hideFlags = HideFlags.HideAndDontSave;
			}
			return curMaterial;
		}
	}


	// Use this for initialization
	void Start () {
		if (!SystemInfo.supportsImageEffects) {
			enabled = false;
			return;
		}

		if (!currentShader && !currentShader.isSupported) {
			enabled = false;
		}
	}


	void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) {
		if (currentShader != null) {
			//Inject shader values here
			material.SetFloat("_Contrast", contrast);
			material.SetFloat ("_Brightness", brightness);
			material.SetFloat ("_Luminosity", luminosity);
			material.SetFloat ("_ColorAmount", colorAmount);
			material.SetColor ("_Color", color);
			material.SetFloat ("_Distortion", distortion);
			material.SetFloat ("_Scale", scale);

			if (scanLineTexture) {
				material.SetTexture ("_ScanLineTex", scanLineTexture);
				material.SetFloat ("_ScanTile", scanLineSize);
				material.SetFloat ("_ScanLineSpeed", scanLineSpeed);
				material.SetFloat ("_ScanLineAmount", scanLineAmount);
			}

			if (noiseTexture) {
				material.SetTexture ("_NoiseTex", noiseTexture);
				material.SetFloat ("_NoiseAmount", noiseAmount);
				material.SetFloat ("_RandomValue", Random.value);
			}

			if (vignetteTexture) {
				material.SetTexture ("_VignetteTex", vignetteTexture);
				material.SetFloat ("_VignetteAmount", vignetteAmount);
			}

			Graphics.Blit (sourceTexture, destTexture, material);
		} else {
			Graphics.Blit (sourceTexture, destTexture);
		}
	}

	void OnDisable() {
		if (curMaterial) {
			DestroyImmediate(curMaterial);
		}
	}
}
