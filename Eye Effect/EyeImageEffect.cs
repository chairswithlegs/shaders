using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class EyeImageEffect : MonoBehaviour {


	//Adjustable shader properties
	public Texture2D eyelidTexture;
	[Range(0,1)]
	public float eyelidAmount = 1;
	[Range(0,1)]
	public float blurScale = 0.5f;
	[Range(0,1)]
	public float blurAmount = 0;
	[Range(1,5)]
	public int blurIterations = 5;


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
			material.SetTexture("_EyelidTex", eyelidTexture);
			material.SetFloat ("_EyelidAmount", eyelidAmount);
			material.SetFloat ("_BlurScale", blurScale);
			material.SetFloat ("_BlurAmount", blurAmount);
			material.SetFloat ("_BlurIter", blurIterations);

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
