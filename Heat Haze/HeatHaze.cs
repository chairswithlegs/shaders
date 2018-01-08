using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class HeatHaze : MonoBehaviour {


	//Adjustable shader properties
	public Texture2D noiseTex;
	[Range(0.0f,1.0f)]
	public float max;
	[Range(0.0f,1.0f)]
	public float min;
	[Range(0.01f,1.0f)]
	public float falloff;
	[Range(0f,1.0f)]
	public float speed;


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

		gameObject.GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
	}


	void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) {
		if (currentShader != null) {
			//Inject shader values here
			material.SetTexture("_NoiseTex", noiseTex);
			material.SetFloat ("_Max", max);
			material.SetFloat ("_Min", min);
			material.SetFloat ("_Falloff", falloff);
			material.SetFloat ("_Speed", speed);

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
