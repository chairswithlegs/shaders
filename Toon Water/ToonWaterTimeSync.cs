using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//Updates water material timescale. Used with ToonWaterBuoyant.cs to create buoyancy effects.
public class ToonWaterTimeSync : MonoBehaviour {
	//Water material
	public Material mat;

	// Update is called once per frame
	void Update () {
		mat.SetFloat ("_Time0", Time.time);
	}
}
