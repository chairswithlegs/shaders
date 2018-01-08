using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Colorize : MonoBehaviour {

	//Adjustable shader properties
	[Range(0,1)]
	public float red = 1.0f;
	[Range(0,1)]
	public float green = 1.0f;
	[Range(0,1)]
	public float blue = 1.0f;

	[Range(0,1)]
	public float contrast = 0.5f;
	[Range(0,1)]
	public float brightness = 0.5f;
	[Range(0,1)]
	public float saturation = 0.5f;


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
			material.SetFloat("_Contrast", (contrast * 2));
			material.SetFloat ("_Brightness", brightness - 0.5f);
			material.SetFloat ("_Saturation", saturation * 2);
			material.SetFloat ("_Red", red);
			material.SetFloat ("_Blue", blue);
			material.SetFloat ("_Green", green);

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
