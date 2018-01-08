using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Purkinje : MonoBehaviour {

	//Adjustable shader properties
	public Color colorBias = Color.white;

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
			material.SetColor ("_Color", colorBias);

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
